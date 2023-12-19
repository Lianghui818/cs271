TITLE Program Template     (Project 5.asm)

; Author: Lianghui Wang
; Last Modified: 
; OSU email address: wangl9@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:   project5              Due Date:
; Description: Program generates 200 random integers in the range of 15 (LO) to 50 (HI) and stores them in consecutive elements of an array (ARRAYSIZE = 200).


INCLUDE Irvine32.inc

;  constant definitions 
  
   HI           =   50
   LO           =   15
   ARRAYSIZE    =   200

.data
  
;  variable definitions 

   programTitle     BYTE    "Generating, Sorting, and Counting Random integers!                      Programmed by Lianghui", 0
   intro1           BYTE    "This program generates 200 random integers between 15 and 50, inclusive.", 0
   intro2           BYTE    "It then displays the original list, sorts the list, displays the median value of the list,", 0
   intro3           BYTE    "displays the list sorted in ascending order, and finally displays the number of instances", 0
   intro4           BYTE    "of each generated value, starting with the number of lowest.", 0
   ec1              BYTE    "--Program Intro--", 0
   ec2              BYTE    "**EC1: Display the numbers ordered by column instead of by row. These numbers should still be printed 20-per-row, filling the first row before printing the second row.", 0
   ec3              BYTE    "**EC2: Generate the numbers directly into a file, then read the file into the array. This may modify your procedure parameters significantly. ", 0
   ec4              BYTE    "--Program prompts, etc?", 0
   unsortTitle      BYTE    "Your unsorted random numbers: ", 0
   sortTitle        BYTE    "Your sorted random numbers: ", 0
   medianTitle      BYTE    "The median value of the array: ", 0
   countsTitle      BYTE    "Your list of instances of each generated number, starting with the smallest value: ", 0
   goodbye          BYTE    "Goodbye, and thanks for using my program!", 0
   twoSpace         BYTE    " ", 0
   randArray        DWORD   ARRAYSIZE   DUP(?)
   counts           DWORD   36  DUP(0) 
   

.code

main PROC
    
    push    OFFSET  programTitle
    push    OFFSET  intro1
    push    OFFSET  intro2
    push    OFFSET  intro3
    push    OFFSET  intro4
    push    OFFSET  ec1
    push    OFFSET  ec2
    push    OFFSET  ec3
    push    OFFSET  ec4
    call    introduction                                        ; Call introduction procedure

    call    Randomize                                           ; Choose random number

    push    OFFSET   randArray
    call    fillArray                   						; Generate and fill an array with random integers
 
    push    OFFSET   randArray
    push    OFFSET   unsortTitle
    push    OFFSET   twoSpace
    push    OFFSET   twoSpace
    push    OFFSET   counts
    push    OFFSET   twoSpace
    call    displayList										    ; Display the unsorted array

    push    OFFSET   randArray
    call    sortList    										; Sort the array

    push    OFFSET   randArray
    push    OFFSET   counts
    call    countList									    	; Count occurrences of each value in the array

    push    OFFSET   randArray
    push    OFFSET   medianTitle
    call    displayMedian								    	; Display the median of the array

    push    OFFSET   randArray
    push    OFFSET   sortTitle
    push    OFFSET   twoSpace
    push    OFFSET   countsTitle
    push    OFFSET   counts
    push    OFFSET   twoSpace
    call    displayList 										; Display the sorted array

    push  OFFSET   goodbye
    call  bye  											; Display goodbye message

    exit   
main ENDP

; ---------------------------------------------------------------------------------
; Name: introduction
; Description: Print introduction to user
; Receives: None
; Returns: intro message
; Registers Changed: EAX, EBX, ECX, EDX
; ---------------------------------------------------------------------------------
introduction PROC

    push    ebp                                        ; Set up stack frame
    mov     ebp, esp

    ; Display program title
    mov     edx, [ebp+40]
    call    WriteString
    call    CrLf
    call    CrLf

    ; Display introdction and extra credits info
    mov     edx, [ebp+36]
    call    WriteString
    call    CrLf
    mov     edx, [ebp+32]
    call    WriteString
    call    CrLf
    mov     edx, [ebp+28]
    call    WriteString
    call    CrLf
    mov     edx, [ebp+24]
    call    WriteString
    call    CrLf
    mov     edx, [ebp+20]
    call    WriteString
    call    CrLf
    call    CrLf
    mov     edx, [ebp+16]
    call    WriteString
    call    CrLf
    call    CrLf
    mov     edx, [ebp+12]
    call    WriteString
    call    CrLf
    mov     edx, [ebp+8]
    call    WriteString
    call    CrLf
    call    CrLf

    pop     ebp                                       ; Restore previous stack frame
    ret     12                                        ; Clean up and return
introduction ENDP


; ---------------------------------------------------------------------------------
; Name: fillArray
; Description: Fills array with random integers in range [15, 50].
; Receives: Array integers' address
; Returns: Array
; Registers Changed: EAX, ESI
; ---------------------------------------------------------------------------------
fillArray PROC

    push    ebp                                      ; Set up stack frame
    mov     ebp, esp
    mov     esi, [ebp+8]                             ; Get the address of the array
    mov     ecx, ARRAYSIZE                           ; Set the loop counter depends on array size

addElement:
    mov     eax, HI         
    sub     eax, LO                                  ; Set up the range
    inc     eax
    call    RandomRange     
    add     eax, LO         
    mov     [esi], eax                               ; Store the random number in the array

    add     esi, 4                                   
    loop    addElement                               ; Add elements until all elements are filled

    pop     ebp                                         
    ret     4                               
fillArray ENDP


; ---------------------------------------------------------------------------------
; Name: sortList
; Description: Sorts an array of integers by using bubble sort
; Receives: The address of the array to be sorted
; Returns: A sortted array
; Registers Changed: EAX, EBX, ECX, EDX, ESI
; ---------------------------------------------------------------------------------
sortList PROC

    push   ebp              
    mov    ebp, esp
    mov    esi, [ebp+8]                             ; Get the address of the array
    mov    ecx, ARRAYSIZE           
    dec    ecx                              

outerLoop:
    mov    eax, [esi]
    mov    edx, esi
    push   ecx

innerLoop:
    mov    ebx, [esi+4]
    mov    eax, [edx]
    cmp    eax, ebx
    jle    skipSwap
    add    esi, 4
    push   esi
    push   edx
    push   ecx
    call   exchangeElements
    sub    esi, 4

skipSwap:
    add    esi, 4
    loop   innerLoop

    pop    ecx
    mov    esi, edx

    add    esi, 4
    loop   outerLoop

    pop    ebp              
    ret    8                

sortList ENDP

; ---------------------------------------------------------------------------------
; Name: ExchangeElements
; Description: Exchanges the values at two given addresses
; Receives: The addresses of the two elements need to be exchanged
; Returns: Two elements have been exchange
; Registers Changed: EAX, EBX, ECX, EDX, ESI
; ---------------------------------------------------------------------------------
ExchangeElements PROC

    push    ebp             
    mov     ebp, esp
    pushad                  

    mov     eax, [ebp+16]                           ; Get the address of the first element
    mov     ebx, [ebp+12]                           ; Get the address of the second element

    mov     edx, eax
    sub     edx, ebx

    mov     esi, ebx
    mov     ecx, [ebx]                              ; Save the second element' value
    mov     eax, [eax]                              ; Get the first element' value

    mov     [esi], eax                              ; Store the value of the first element at the second element
    add     esi, edx        
    mov     [esi], ecx      

    popad                   
    pop     ebp             
    ret     12              
ExchangeElements ENDP

; ---------------------------------------------------------------------------------
; Name: displayMedian
; Description: Displays the median of an array 
; Receives: The address of the array to find the median
; Returns: The median number address
; Registers Changed: EAX, EBX, ECX, EDX, ESI
; ---------------------------------------------------------------------------------
displayMedian PROC

    push     ebp            
    mov      ebp, esp
    mov      esi, [ebp+12]                          ; Get the address of the array
    mov      eax, ARRAYSIZE                         ; Set the loop counter to the array size
    mov      edx, [ebp+8]                           ; Get the address of the title string
    call     WriteString

    mov      edx, 0
    mov      ebx, 2
    div      ebx
    mov      ecx, eax

medianLoop:
    add      esi, 4
    loop     medianLoop

    mov      eax, [esi - 4]
    add      eax, [esi]
    mov      edx, 0
    mov      ebx, 2
    div      ebx
    call     WriteDec
    call     CrLf
    call     CrLf
    pop      ebp
    ret      8

displayMedian ENDP

; ---------------------------------------------------------------------------------
; Name: displayList
; Description: Displays the contents of an array, presenting 20 numbers per line
; Receives: The address of the array to be displayed, and the title string.
; Returns: The array
; Registers Changed: EAX, EBX, ECX, EDX, ESI
; ---------------------------------------------------------------------------------
displayList PROC

    push    ebp            
    mov     ebp, esp
    mov     esi, [ebp+28]                             ; Get the address of the array
    mov     edx, [ebp+24]                             ; Get the address of the title string
    call    WriteString                               ; Display the title
    call    CrLf

    mov     edx, [ebp+20]      
    mov     ebx, 0            

    ; Outer loop for 20 rows
    mov     ecx, 10           

rowLoop:
    push    ecx

    ; Inner loop for 10 columns
    mov     ecx, 20           
    mov     edi, ebx                                  ; Current row index

columnLoop:
    mov     eax, [esi + edi*4] 
    call    WriteDec           
    push    edx                                            
    call    WriteString            
    pop     edx              
    add     edi, 10                                    ; move to next element
    loop    columnLoop

    pop     ecx
    call    CrLf                                      ; Move to the next line
    inc     ebx                                       ; Increment the new line counter
    loop    rowLoop

   call     Crlf
   mov      edx, [ebp+16]                              ; Get the address of the counts title string
   call     WriteString
   call     Crlf
   mov      ecx, 36               
   mov      esi, [ebp+12]

   printCounts:
   mov      eax, [esi]
   cmp      eax, 0
   je       skip
   call     WriteDec
   mov      edx, [ebp+8]
   call     WriteString
   inc      ebx
   
   cmp      ebx, 30                                    ; Check if the maximum limit of integers per line is reached
   jl       skipNextLinee
   call     CrLf
   mov      ebx, 0       ;the counter is refreshed

   skipNextLinee:
   add      esi, 4       ;move to next element of the array
   loop     printCounts
 
 skip:
   pop      ebp
   ret


displayList ENDP


; ---------------------------------------------------------------------------------
; Name: countList 
; Description: Counts each value in the array and updates the corresponding counts array
; Receives: The address of the array to be counted.
; Returns: Counts array
; Registers Changed: EAX, EDX, ESI, EDI, ECX, EBP
; ---------------------------------------------------------------------------------
countList PROC

    push    ebp                 
    mov     ebp, esp
    mov     esi, [ebp+12]                                   ; Get the address of the array
    mov     edi, [ebp+8]                                    ; Get the address of the counts array
    mov     ecx, ARRAYSIZE      

countLoop:
    mov     eax, [esi]                                      ; Get the value at the current index
    sub     eax, LO                                         ; Convert to the counts array index
    mov     edx, [edi + eax*4]                              ; Get the current count
    inc     edx             
    mov     [edi + eax*4], edx                              ; Update the count in the counts array
    add     esi, 4          
    loop    countLoop

    pop     ebp             
    ret     4               
countList ENDP





; ---------------------------------------------------------------------------------
; Name: bye
; Description: Print goodbye message to users
; Receives: The address of the goodbye message
; Returns: goodbye message
; Registers Changed: EDX, EBP
; ---------------------------------------------------------------------------------
bye PROC

    push    ebp                                 ; Set up stack frame
    mov     ebp, esp
    call    CrLf
    call    CrLf
    mov     edx, [ebp+8]                        ; Get the address of the goodbye 
    call    WriteString
    call    CrLf
    call    CrLf

    pop     ebp             
    ret     4               

bye ENDP

END main

