TITLE Program 3     (Proj3_wangl9.asm)

; Author: Lianghui Wang
; Last Modified: 2023/11/5
; OSU email address: wangl9@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:  Project_3             Due Date: 2023/11/5
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)
MIN_RANGE1		EQU		-200        ; 
MAX_RANGE1		EQU		-100
MIN_RANGE2		EQU		-50
MAX_RANGE2		EQU		-1

.data

    intro1      BYTE        "Welcome to the Integer Accumulator by Lianghui Wang", 0
    intro2      BYTE        "We will be accumulating user-input negative integers between the specified bounds, then displaying", 0dh, 0ah
                BYTE        "statistics of the input values including minimum, maximum, and average values values, total sum,", 0dh, 0ah
                BYTE        "and total number of valid inputs.", 0dh, 0ah
    prompt1     BYTE        "What is your name? ", 0
    prompt2     BYTE        "Hello there, ", 0
    prompt3     BYTE        " Enter number: ", 0
    input1      BYTE        "Please enter numbers in [-200, -100] or [-50, -1].", 0
    input2      BYTE        "Enter a non-negative number when you are finished, and input stats will be shown.", 0dh, 0ah
    msg1        BYTE        "This is not a number we're looking for (Invalid Input)!", 0
    msg2        BYTE        "You entered ", 0
    msg3        BYTE        " valid numbers.", 0
    msg4        BYTE        "No valid numbers were entered.", 0
    disp1       BYTE        "The maximum valid number is ", 0
    disp2       BYTE        "The minimum valid number is ", 0
    disp3       BYTE        "The sum of your valid numbers is ", 0
    disp4       BYTE        "The rounded average is ", 0
    goodbye     BYTE        "We have to stop meeting like this. Farewell, ", 0
    maxNum      SDWORD      -201          ; Initialize the maximum number with -201
    minNum      SDWORD      0             ; Initialize the minimum number with 0
    sum         SDWORD      0             ; Initialize the sum with 0
    avg         SDWORD      0             ; Initialize the average with 0
    count       DWORD       0             ; Initialize the count with 0
    userName    BYTE        21 DUP(0)     ; Store the user's name
    count_1     DWORD       1             ; Counter for line numbers during input
    excd1       BYTE        "--Program Intro--", 0
    excd2       BYTE        "**EC: Number the lines during user input. Increment the line number only for valid number entries. ", 0
    excd3       BYTE        "**EC: Calculate and display the average as a decimal-point number , rounded to the nearest .01. ", 0
    excd4       BYTE        "--Program prompts, etc--", 0dh, 0ah
    rema        DWORD       ?
    floatp      BYTE        ".", 0
    fltpro      BYTE        "As a floating point number: ", 0
    neg1k       DWORD       -1000
    pos1k       DWORD       1000
    subt        DWORD       ?
    floatp_1    DWORD       ?

.code

main PROC
    ; Display the program introduction and programmer¡¯s name
    mov         edx,    OFFSET intro1                       ; print introductions
    call        WriteString
    call        Crlf
    mov         edx,    OFFSET intro2                       
    call        WriteString
    call        Crlf

    ; Get the user's name and greet the user
    mov         edx,    OFFSET prompt1                     ; ask user's name
    call        WriteString
    mov         edx,    OFFSET userName                    ; read and space the name
    mov         ecx,    SIZEOF userName
    call        ReadString

    mov         edx,    OFFSET prompt2                       ; print greetins message
    call        WriteString
    mov         edx,    OFFSET userName     
    call        WriteString
    call        Crlf

    ; Display instructions for the user
    mov         edx,    OFFSET input1                       ; print instructions for numbers range
    call        WriteString
    call        Crlf
    mov         edx,    OFFSET input2
    call        WriteString
    call        Crlf
    mov         edx,    OFFSET excd1                       
    call        WriteString
    call        Crlf
    mov         edx,    OFFSET excd2                      
    call        WriteString
    call        Crlf
    mov         edx,    OFFSET excd4              
    call        WriteString
    call        Crlf
; Repeatedly prompt the user to enter a number.

Loopforinput:
    ; Loop for user to enter numbers
    mov         eax,    count_1
    call        WriteDec
    add         eax,    1
    mov         count_1,    eax
    
    mov         edx,    OFFSET prompt3
    call        WriteString
    call        ReadInt
    cmp         eax,    0
    JNS         endLoop                               ; if user enter a non-negative number, then goto extLoop
    
    ; Check if number is within first range
    cmp         eax,    MIN_RANGE1
    jl          NumberOutOfRange
    cmp         eax,    MAX_RANGE1
    jle         NumberIsValid
    
; Check if number is within second range
NumberOutOfRange:
    cmp         eax,    MIN_RANGE2
    jl          err
    cmp         eax,    MAX_RANGE2
    jle         NumberIsValid
    jmp         err

; check the number is valid   
NumberIsValid:
    ; Update sum, max, and min
    add         sum,    eax
    cmp         eax,    maxNum
    jle         CheckMin
    mov         maxNum,     eax             ; check and update the max number

; check and update the min number
CheckMin:
    cmp         eax,    minNum
    jge         ContinueLoop
    mov         minNum,     eax

ContinueLoop:
    ; count the valid numbers
    inc         count
    jmp         Loopforinput

; Notify the user of any invalid numbers
err:
    ; Only print the error message if an invalid number was entered
    mov         edx,    OFFSET msg1
    call        WriteString
    call        Crlf
    jmp         Loopforinput

endLoop:
    ; Check if any valid numbers were entered
    cmp         count,  0
    jne         displaypart         
    ; if the number is invalid, print message to tell user no valid numbers were entered
    mov         edx,    OFFSET msg4
    call        WriteString
    call        Crlf
    jmp         gbye

    ; otherwise

displaypart:
    mov         esi,    sum
    mov         edi,    count
    fild        sum     
    fidiv       count

    call        CrLf
    mov         edx,    OFFSET msg2                        ; display number of valid numbers
    call        WriteString
    mov         eax,    edi
    call        WriteDec
    mov         edx,    OFFSET msg3
    call        WriteString
    call        Crlf

    mov         edx,    OFFSET disp1                       ; display maximum number
    call        WriteString
    mov         eax,    maxNum
    call        WriteInt
    call        Crlf

    mov         edx,    OFFSET disp2                       ; display minimum number
    call        WriteString
    mov         eax,    minNum
    call        WriteInt
    call        Crlf

    mov         edx,    OFFSET disp3                       ; display the sum of the given numbers
    call        WriteString
    mov         eax,    sum
    call        WriteInt
    call        Crlf

    mov         edx,    OFFSET disp4                       ; display rounded average of the given numbers
    call        WriteString
    frndint
    fist        avg
    mov         eax,    avg
    call        WriteInt
    call        Crlf

    ; integer average for accumulator
    mov         edx,    OFFSET excd1                       
    call        WriteString
    call        Crlf
    mov         edx,    OFFSET excd3                      
    call        WriteString
    call        Crlf
    mov         edx,    OFFSET excd4              
    call        WriteString
    call        Crlf
    mov         rema,   edx
    mov         edx,    OFFSET fltpro
    call        WriteString
    call        WriteInt
    mov         edx,    OFFSET floatp
    call    WriteString


    ; Convert the integer average to a floating point representation and display it
    mov         eax,    rema
    mul         neg1k
    mov         rema,   eax 
    mov         eax,    count_1
    sub         eax,    2          
    mul         pos1k
    mov         subt, eax

    fld         rema
    fdiv        subt
    fimul       pos1k
    frndint
    fist        floatp_1
    mov         eax,    floatp_1
    call        WriteDec
    call        CrLf


; Say goodbye to the user and exit the program
gbye:                                              ; print goodbye message
    mov         edx,    OFFSET goodbye
    call        WriteString
    mov         edx,    OFFSET userName
    call        WriteString
    call        Crlf
    Invoke  ExitProcess, 0

main ENDP

END main