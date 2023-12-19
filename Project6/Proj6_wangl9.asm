TITLE Program Template     (template.asm)

; Author: Lianghui Wang
; Last Modified:
; OSU email address: wangl9@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:   6              Due Date: 2023/12/10
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.


INCLUDE Irvine32.inc

ARRAY_SIZE      EQU 10
MAX_SIZE        EQU 32
MAX_NUM         EQU 2147483647

.data   
    introStr        BYTE "PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 10,
                    "Written by: Lianghui Wang", 10, 10,
                    "Please provide 10 signed decimal integers.",10,
                    "Each number needs to be small enough to fit inside a 32 bit register.",
                    " After you have finished inputting the raw numbers I will display a list of the integers, their sum, and their average value.", 10, 10, 0
    inputVal        SDWORD ?
    Array           SDWORD ARRAY_SIZE dup(0)
    totalSum        SDWORD 0
    input1          BYTE "Please enter a signed number: ", 0
    errorMsg        BYTE "ERROR: You did not enter a signed number or your number was too big.", 10, "Please try again: ", 0
    displayNumber   BYTE 10, "You entered the following numbers: ", 10, 0
    displaySum      BYTE "The sum of these numbers is: ", 0
    displayAvg      BYTE "The truncated average is: ", 0
    thanksPrompt    BYTE 10, 10, "Thanks for playing! ", 0
    comma           BYTE ", ", 0
	newline 	    BYTE 10, 0

; mDisplayString: Macro to print a string to the console
mDisplayString MACRO str
    PUSH    EDX
    MOV     EDX, str ; move address of string to EDX
    CALL    WriteString     ; call WriteString to print the string
    POP     EDX
ENDM



;------------------------------------------------------------------------------
; Name:mGetString
; Description: Displays a prompt to the user, Macro to read a string from user
; Receives: prompt to display (reference), string buffer (reference), length of string buffer (value)
; Returns: none
; Registers changed: edx, ecx
;------------------------------------------------------------------------------

mGetString MACRO prompt, str, len
    PUSH    EDX
    PUSH    EAX
    MOV     EDX, prompt     ; move address of prompt to EDX
    CALL    WriteString     ; call WriteString to print the prompt
    MOV     EDX, str        ; move address of string to EDX
    MOV     ECX, MAX_SIZE   ; move size to ECX
    CALL    ReadString      ; call ReadString to get input from the user
    MOV     len, EAX        ; move the length of the string to len
    POP     EAX
    POP     EDX
ENDM


.code

main PROC
    ; Display introduction
    mDisplayString OFFSET introStr

    MOV     ECX, ARRAY_SIZE
    MOV     EDI, OFFSET Array
    MOV     ESI, EDI

    ; Get 10 numbers
get_number:
    PUSH    OFFSET input1
    PUSH    OFFSET errorMsg
    PUSH    OFFSET inputVal
    CALL    ReadVal

    ; add number to total sum
	MOV     EAX, inputVal
    ADD     totalSum, EAX

    ; add number to array
    MOV     [EDI], EAX
    ADD     EDI, 4

    LOOP    get_number

    ; Display numbers
    MOV     ECX, ARRAY_SIZE
    mDisplayString OFFSET displayNumber

display_numbers:
    PUSH    [ESI]
    CALL    WriteVal
    ADD		ESI, 4

    CMP     ECX, 1
    JE      display_sum

    mDisplayString  OFFSET comma
    LOOP            display_numbers

display_sum:
    mDisplayString  OFFSET newline
    mDisplayString  OFFSET displaySum
    PUSH            totalSum
    CALL            WriteVal

dsiplay_avergae:
    mDisplayString OFFSET newline
    mDisplayString OFFSET displayAvg

    ; Calculate the rounded integer average
    MOV     EAX, totalSum
    MOV		ECX, 10
    CDQ
    IDIV    ECX
    PUSH    EAX
    CALL    WriteVal

ExitProgram:
    mDisplayString OFFSET thanksPrompt
    INVOKE  ExitProcess, 0
main ENDP

; --------------------------------------------------------
; Name: ReadVal
; Description: Procedure to get input from user and convertToNum it. The procedure prompts the user for input, checks if it's a valid signed number, and if not, displays an error message and reprompts.
; Receives: [EBP+16]: input prompt, [EBP+12]: error message prompt, [EBP+8]: inputVal address
; Returns: None
; Registers changed: ebp (saved by LOCAL), eax, ebx, esi, ecx
; --------------------------------------------------------

ReadVal PROC
    LOCAL    inputString[MAX_SIZE]:BYTE

    ; Preserve registers
    PUSHAD

    MOV     EBX, [EBP+16]		; input prompt
    MOV     EDX, [EBP+12]		; error message prompt
    MOV     EDI, [EBP+8]		; inputVal address
    LEA		ESI, inputString	; input string array

GetInput:
    ; Use the mGetString macro to get input from the user
    mGetString  EBX, ESI, ECX
    JMP     ConvertString

GetInputAfterError:
    ; Use mGetString macro to get input from the user when previous input is invalid
    mGetString  EDX, ESI, ECX

ConvertString:
    PUSH    ESI
    PUSH    ECX
    CALL    convertToNum        ; convert string to number
                                ; result stored in EBX
                                ; if error occured, EAX is set to 1
    CMP     EAX, 1
    JE      GetInputAfterError

    MOV     [EDI], EBX  ; move converted number to memory

    POPAD
    RET     12          ; Return
ReadVal ENDP


; --------------------------------------------------------
; Name: convertToNum
; Description: Procedure to convert ascii input to integer number.  
; This procedure takes a string and its length as arguments and converts the string to an integer and returns the integer value in EBX.
; If there is an error during conversion (for example, if the string contains non-numeric characters),
; the procedure sets EAX to 1. If the string starts with '-' the result will be negated, '+' is just skipped.
; Receives: [EBP+12+12]: start of string, [EBP+8+12]: length of string
;Returns: EAX, EBX
; --------------------------------------------------------
convertToNum PROC USES EDX ESI ECX
    PUSH    EBP
    MOV     EBP, ESP

    MOV     ESI, [EBP+12+12]   ; start of string
    MOV     ECX, [EBP+8+12]    ; length of string

    MOV     EDX, 1          ; negative multiplier
    XOR     EAX, EAX        ; error indicator
    XOR     EBX, EBX        ; result

    ; check signs
checkSigns:
    LODSB
    CMP     AL, 0           ; if end of string, exit
    JE      convertToNum_done
    CMP     AL, '-'
    JNE     notNegative
    NEG     EDX             ; negate multiplier
    JMP     convertToNum_loop
notNegative:
    CMP     AL, '+'
    JE      convertToNum_loop        ; if positive sign, skip
    JNE     convert_digit   ; probably a digit, try converting

convertToNum_loop:
    LODSB
    CMP     AL, 0           ; if end of string, exit
    JE      convertToNum_done

convert_digit:
    ; check if it's a digit
    CMP     AL, '0'
    JB      convertToNum_error
    CMP     AL, '9'
    JA      convertToNum_error

    ; convert ascii to integer
    SUB     AL, '0'
    IMUL    EBX, 10
    ADD     EBX, EAX

    ; check if number is within bounds
    CMP     EBX, MAX_NUM
    JA      convertToNum_error

    LOOP    convertToNum_loop
    JMP     convertToNum_done

convertToNum_error:
    MOV     EAX, 1      ; indicate error
    JMP     convertToNum_exit

convertToNum_done:
	IMUL    EBX, EDX    ; muliplier
    MOV     EAX, 0      ; no error

convertToNum_exit:
    POP     EBP
    RET     8       ; Return
convertToNum ENDP


; --------------------------------------------------------
; Name: WriteVal
; Description: Procedure for converting integer to string and displaying it. This procedure takes an integer and the address of a string as arguments. 
; It then converts the integer to a string and displays it to the user.
; Receives: [EBP + 12]: integer number (value), [EBP + 8]: address of display string
; Returns: None
; --------------------------------------------------------
WriteVal PROC
    LOCAL    numberString[MAX_SIZE]:BYTE
    PUSHAD

    ; get parameters from stack
    MOV     EAX, [EBP + 8] ; the number
    LEA     EDI, numberString

    PUSH    EAX
    PUSH    EDI
    ; convert integer to string
    CALL    convertToStr

    ; display the string
    mDisplayString EDI

    POPAD
    RET     4
WriteVal ENDP


; --------------------------------------------------------
; Name: convertToStr
; Description: Procedure to convert integer to ascii string.
; This procedure takes an integer and the address of a string as arguments and converts the integer into an ASCII string.
; If the integer is negative, it converts the absolute value of the integer to a string and adds a negative sign to the front.
; Receives:[EBP + 12]: the number, [EBP + 8]: address of display string
; Returns: none
; --------------------------------------------------------
convertToStr PROC
    LOCAL    isNegative:WORD
    PUSHAD

    ; get parameters from stack
    MOV     EAX, [EBP + 12] ; the number
    MOV     ESI, [EBP + 8]  ; address of display string
    MOV     EDI, ESI  		; copy of string address

    ; convert integer to ascii
    MOV     EBX, 10             ; base 10
    ADD     ESI, 11             ; move to end of string
    MOV     BYTE PTR [ESI], 0   ; null terminator
    MOV     isNegative, 0		; false (initially)

    ; check if number is negative
    CMP     EAX, 0
    JL      negative
    JGE     convertToStr_loop

negative:
    ; if negative, set isNegative and negate number
    MOV     isNegative, 1
    NEG     EAX

convertToStr_loop:
    XOR     EDX, EDX
    DIV     EBX                 ; divide EAX by 10
    ADD     EDX, 30h            ; convert remainder to ascii
    DEC     ESI                 ; point to previous char
    MOV     [ESI], DL           ; store ascii char
    TEST    EAX, EAX
    JNZ     convertToStr_loop           ; if quotient is not zero, repeat

    ; if number is negative, add negative sign
    CMP     isNegative, 1
    JNE     convertToStr_done

    DEC     ESI
    MOV     BYTE PTR [ESI], '-'

convertToStr_done:
    ; move converted string to start of passed string
    ; start of converted string already in ESI
    ; start of destination string (passed on stack) in EDI
    MOV     ECX, 12

move_string:
    LODSB
    STOSB
    LOOP move_string

    POPAD
    RET     8
convertToStr ENDP



END main
