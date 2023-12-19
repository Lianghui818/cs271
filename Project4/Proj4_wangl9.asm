TITLE Program Template     (project_4.asm)

; Author: Lianghui Wang
; Last Modified: 2023/11/19
; OSU email address: wangl9@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  Project_4               Due Date: 2023/11/19
; Description:	1. Designing and implementing procedures 2. Designing and implementing loops 3. Writing nested loops 4. Understanding data validation

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)
nppage		EQU		199					; shown 20 rows of primes per page, 10 * 20 = 200

.data
	intro1		BYTE	"Prime Numbers Programmed by Lianghui", 0
	intro2		BYTE	"Enter the number of primes you would like to see", 0
	intro3		BYTE	"I'll accept orders for up to 4000 primes.",0
	prompt		BYTE	"Enter the number of primes to display [1..4000]:  ", 0
	errmsg		BYTE	"No primes for you! Number out of range. Try again.", 0
	goodbye		BYTE	"Results certified by Lianghui. Goodbye.", 0
	prnumber	BYTE	10							; each row have 10 prime numbers
	prcount		DWORD	?
	upbound		DWORD	4000						; Extend the range of primes to display up to 4000 primes
	lwbound		DWORD	1
	count		DWORD	2
	check		DWORD	2
	ec1			BYTE	"---Program Intro---", 0
	ec2			BYTE	"**EC: Align the output columns.", 0 
	ec3			BYTE	"**EC: Extend the range of primes to display up to 4000 primes, shown 20 rows of primes per page.", 0
	ec4			BYTE	"---Program prompts, etc---", 0
	space1		BYTE	" ", 0
	space2		BYTE	"  ", 0
	space3		BYTE	"   ", 0
	space4		BYTE	"    ", 0
	space5		BYTE	"     ", 0
	primeCt		DWORD	0
	nxpage		BYTE	"Press any key to continue ...", 0ah
	

.code

main PROC
	mov primeCt, 0										; Initialize prime count to 0

; Display program introduction and instruct user to enter number of primes to be displayed
	call	introduction

; Prompt for integer in range [1...4000] and validate 1 <= n <= 4000
	call	getUserData
	mov		prcount, eax								; Store the user input in prcount for later use

; Calculate and display all primes up to and including nth prime
	call	showPrimes

; Say goodbye to user
	call	bye

	exit

main ENDP


;------------------------------------------------------------
; Name: introduction
; Procedure to display program introduction to user
; intro1,intro2 and intro3 are type BYTE
; Receives: intro1,intro2 and intro3
; Return: edx, OFFSET = info in intro1,intro2 and intro3
;------------------------------------------------------------
introduction PROC

	mov	edx, OFFSET intro1
	call	WriteString						; display program name and author name
	call	Crlf
	call	Crlf
	mov		edx, OFFSET intro2
	call	WriteString			
	call	Crlf
	mov		edx, OFFSET intro3
	call	WriteString						; display instructions for user
	call	Crlf
	call	Crlf
	ret
introduction ENDP

 
;------------------------------------------------------------
; Name: getUserData
; Procedure to get data from user and and valitates the user input
; Uses ReadDec to read a decimal number input by the user
; prompt and errmsg are type BYTE, prcount is type DWORD
; Receives: prompt, prcount
; Return: errmsg or pass the prcount number
;------------------------------------------------------------
getUserData PROC


validateInput:
; Validates the input to be within the range [1...4000]
	mov		edx, OFFSET prompt
	call	WriteString						
	call	ReadDec							; Read the user's input
	mov		prcount, eax					; Store the input in prcount

	; Validate the input
	cmp		prcount, 4000
	jg		invalidInput					; If the enter number greater than 4000: invalid
	cmp		prcount, 1
	jl		invalidInput					; If the enter number less than 1: invalid
	ret

invalidInput:
	mov		edx, OFFSET errmsg				
	call	WriteString
	call	CrLf
	jmp		validateInput					; ask user input again
	ret
getUserData ENDP


;------------------------------------------------------------
; Name: showPrimes
; Procedure to calculate and display all prime number in screen
; Loop for finging prime numbers up to the user-requested count
; Start at 2, if the number can be divided by anything other than itself and 1, it will not print.
; prcount, count and check are type DWORD
; Receives: prcount, count and check
; Return: count
;------------------------------------------------------------
showPrimes PROC
	
	inc		prcount							; Increment the prime count to include the upper bound

primeloop:
; The main loop for checking and displaying primes
; Uses division and checks the remainder to determine primality

	mov		edx, 0							; Reset the remainder
	mov		eax, count						; Current number to check for primality
	mov		ecx, check						
	div		ecx								

	cmp		edx, 0							; If remainder is 0, it's not a prime
	je		isprime							
	inc		check						
	jmp		primeloop						; Loop back to try the next divisor

	isprime:
		cmp		eax, 1						
		je		printprimes					; print the prime number
		jmp		notprime

	printprimes:
		mov		eax, count						
		call	writeDec					
		call	aligncolumn					; Align the output column
		dec		prcount						; Decrement the prime count
		inc		primeCt						
		mov		ecx, prcount				; Move the updated count back into ecx for the loop

	notprime:
	; If the number is not prime, set up to check the next number
		mov		eax, 2
		mov		check, eax					; Move the reset divisor into the check variable
		inc		count						

	loop	primeloop
	ret

showPrimes ENDP


;------------------------------------------------------------
; Name: aligncolumn
; Procedure to aligns the output columns by adding spaces based on the number's length
; prnumbe is type DWORD, spaces are type BYTE
; Receives: prnumber, spaces
; Return: eax
;------------------------------------------------------------
aligncolumn PROC

	dec		prnumber						; Decrement the primes per row counter
	mov		cl, prnumber
	cmp		cl, 0							; Check if we need a new row
	je		newpage							; If we've printed 10 primes, start a new row

	cmp		eax, 10
    jl		space_5							; If the number is less than 10, add 5 spaces

	cmp		eax, 100
    jl		space_4							; If the number is less than 100, add 4 spaces

	cmp		eax, 1000
    jl		space_3							; If the number is less than 1000, add 3 spaces

	cmp		eax, 10000
    jl		space_2							; If the number is less than 10000, add 2 spaces

	cmp		eax, 100000
    jl		space_1							; If the number is less than 100000, add 1 space

	mov edx, offset space5					
	call writeString
    ret

space_1:
; Subroutine for adding 1 space
    mov		edx, offset space1
    call	writeString
    ret

space_2:
; Subroutine for adding 2 space
    mov		edx, offset space2
    call	writeString
    ret

space_3:
; Subroutine for adding 3 space
    mov		edx, offset space3
    call	writeString
    ret

space_4:
; Subroutine for adding 4 space
    mov		edx, offset space4
    call	writeString
    ret

space_5:
; Subroutine for adding 5 space
    mov		edx, offset space5	
    call	writeString
    ret

newpage:
; Creat a new row for primes
	call	CrLf						
    mov		prnumber, 10							; each row have 10 prime numbers

	; Check if we need a new page
    mov		eax, primeCt							; Get the total prime counter
    cmp		eax, nppage								; Compare against the primes per page constant
    jl		noNewPage
    call	nextPage								; New procedure to handle pausin
	ret

noNewPage:
    ret

aligncolumn ENDP


;------------------------------------------------------------
; Name: nextPage
; Handles the creation of a new row for primes
; prnumbe is type DWORD, spaces are type BYTE
; Receives: ecs, nxpage
; Return: none
;------------------------------------------------------------
nextPage PROC
	call	CrLf
	mov		edx, offset ec1						
    call	WriteString
	call	CrLf
	mov		edx, offset ec2						
    call	WriteString
	call	CrLf
	mov		edx, offset ec3				
    call	WriteString
	call	CrLf
	mov		edx, offset ec4				
    call	WriteString								; Print extra credit information
	call	CrLf
    mov		edx, offset nxpage						; Message to press any key
    call	WriteString
    call	ReadChar								; Wait for any key press
    mov		eax, 0									; Reset prime count after a page
    mov		primeCt, eax
    ret
nextPage ENDP


;------------------------------------------------------------
; Name: bye
; ;Displays a farewell message and say good bye to user
; goodbye is type BYTE
; Receives: goodbye
; Return: goodbye message
;------------------------------------------------------------
bye PROC
	call	Crlf
	mov		edx, OFFSET goodbye						; Print a farewell message and say good bye to user
	call	WriteString							
	call	Crlf
	ret
bye ENDP

END main
