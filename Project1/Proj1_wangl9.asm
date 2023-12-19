TITLE Program Template     (template.asm)

; Author: Lianghui Wang
; Last Modified: 2023/10/21
; OSU email address: wangl9@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: Project 1         Due Date: 2023/10/21
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

; (insert variable definitions here)


titleandname	BYTE	"Elementary Arithmetic ---- by Lianghui Wang", 0
userintro		BYTE	"Please enter 3 numbers A > B > C, and I'll show you the sums and difference: ", 0
prompt1			BYTE	"Please enter the first number A: ", 0
prompt2			BYTE	"Please enter the second number B: ", 0
prompt3			BYTE	"Please enter the third number C: ", 0
plus			BYTE	" + ", 0
minus			BYTE	" - ",0
equal			BYTE	" = ", 0
promptC			BYTE "Do you want to continue? (Yes=1 / No=0): ", 0
promptC1		BYTE "--Program Intro--", 0
promptC2		BYTE "**EC: Extra Credit Options 1: Repeat until the user chooses to quit", 0
promptC3		BYTE "--Program prompts, etc¡ª", 0
goodbye			BYTE	"Thank you for using Elementary Arithmetic! Goodbye!", 0


numA			DWORD	0
numB			DWORD	0
numC			DWORD	0
sumAB			DWORD	0
diffAB			DWORD	0
sumAC			DWORD	0
diffAC			DWORD	0
sumBC			DWORD	0
diffBC			DWORD	0
sumABC			DWORD	0


.code
main PROC

; (insert executable instructions here)
; Introdaction
	mov		edx, OFFSET titleandname
	call	WriteString
	call	Crlf
	mov		edx, OFFSET userintro
	call	WriteString
	call	Crlf


repeatprogram:
; Get numA
	mov		edx, OFFSET prompt1
	call	WriteString
	call	ReadInt
	mov		numA, eax
	call	Crlf

; Get numB
	mov		edx, OFFSET prompt2
	call	WriteString
	call	ReadInt
	mov		numB, eax
	call	Crlf

; Get numC
	mov		edx, OFFSET prompt3
	call	WriteString
	call	ReadInt
	mov		numC, eax
	call	CrLf

; Caculate
; A + B
	mov		eax, numA
	add		eax, numB
	mov		sumAB, eax

; A + C
	mov		eax, numA
	add		eax, numC
	mov		sumAC, eax

; B + C
	mov		eax, numB
	add		eax, numC
	mov		sumBC, eax

; A - B
	mov		eax, numA
	sub		eax, numB
	mov		diffAB, eax

; A - C
	mov		eax, numA
	sub		eax, numC
	mov		diffAC, eax

; B - C
	mov		eax, numB
	sub		eax, numC
	mov		diffBC, eax

; A + B + C
	mov		eax, numA
	add		eax, numB
	add		eax, numC
	mov		sumABC, eax

; Display results
; A + B
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, sumAB
	call	WriteDec
	call	CrLf

; A + C
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, sumAC
	call	WriteDec
	call	CrLf

; B + C
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, sumBC
	call	WriteDec
	call	CrLf

; A - B
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, diffAB
	call	WriteDec
	call	CrLf

; A - C
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, diffAC
	call	WriteDec
	call	CrLf

; B - C
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, diffBC
	call	WriteDec
	call	CrLf

; A + B + C
	mov		eax, numA
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, numB
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, numC
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, sumABC
	call	WriteDec
	call	CrLf

	jmp endloop

endloop:
	; Ask user if they want to continue
	mov		edx, OFFSET promptC1
	call	WriteString
	call	Crlf
	mov		edx, OFFSET promptC2
	call	WriteString
	call	Crlf
	mov		edx, OFFSET promptC3
	call	WriteString
	call	Crlf
	mov edx, OFFSET promptC
    call WriteString
    call ReadDec
    cmp ax, 1
    je repeatprogram


; Goodbye
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
