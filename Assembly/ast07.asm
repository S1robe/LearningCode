; *****************************************************************
;  Assignment: 7
;  Description:	Sort a list of number using the shell sort
;		algorithm.  Also finds the minimum, median, 
;		maximum, and average of the list.

; -----
; Shell Sort

;	h = 1;
;       while ( (h*3+1) < a.length) {
;	    h = 3 * h + 1;
;	}

;       while( h > 0 ) {
;           for (i = h-1; i < a.length; i++) {
;               tmp = a[i];
;               j = i;
;               for( j = i; (j >= h) && (a[j-h] > B); j -= h) {
;                   a[j] = a[j-h];
;               }
;               a[j] = tmp;
;           }
;           h = h / 3;
;       }

; =====================================================================
;  Macro to convert integer to septenary value in ASCII format.
;  Reads <integer>, converts to ASCII/septenary string including
;	NULL into <string>

;  Note, the macro is calling using RSI, so the macro itself should
;	 NOT use the RSI register until is saved elsewhere.

;  Arguments:
;	%1 -> <integer>, value
;	%2 -> <string>, string address

;  Macro usgae
;	int2aSept	<integer-value>, <string-address>

;  Example usage:
;	int2aSept	dword [diamsArrays+rsi*4], tempString

;  For example, to get value into a local register:
;		mov	eax, %1

%macro	int2aSept	2

push rax
push rbx
push rcx
push r9

mov eax, %1		; sum var
cmp eax, 0

jl $+11			; skip pushing a + if its negative
mov rbx, '+'
jmp $+11		; skip pushing -  and negation if its positive
mov rbx, '-'
neg eax

mov ecx, 0		; digit counter for spacing
mov r9d, 7		; static divsior
%%convt:
	cdq		; convert
	inc ecx		; increase digit counter
	idiv	r9d	; / 7
	add edx, 48	; convert to ascii
	push rdx	; store for reversal
	cmp eax, 0	; is number 0? ( stop : keep dividing)
	jne %%convt

push rbx

add rcx, 1	; symbol and null this is adjusted for index( would add 2, but -1 for index

neg rcx
add rcx, STR_LENGTH	; length - digit count = # of spaces

push rcx		; hold for next loop

%%strSpc:
	mov byte[%2+(rcx-1)], 32	; store space
	dec rcx		
	cmp rcx, 0	; 0 is last valid index
	jne %%strSpc

pop rcx			; good to use since this index-1 was a space
mov rdx, STR_LENGTH	; max length
%%strNum:
	pop rax
	mov byte[%2+(rcx-1)], al	; store ascii septenary
	inc rcx
	cmp rcx, rdx			; last valid index is 11
	jne %%strNum
	
mov byte[%2+rdx+1], NULL	; last value must be null


pop r9
pop rcx
pop rbx
pop rax


%endmacro


; =====================================================================
;  Simple macro to display a string to the console.
;  Count characters (excluding NULL).
;  Display string starting at address <stringAddr>

;  Macro usage:
;	printString  <stringAddr>

;  Arguments:
;	%1 -> <stringAddr>, string address

%macro	printString	1
	push	rax			; save altered registers (cautionary)
	push	rdi
	push	rsi
	push	rdx
	push	rcx

	lea	rdi, [%1]		; get address
	mov	rdx, 0			; character count
%%countLoop:
	cmp	byte [rdi], NULL
	je	%%countLoopDone
	inc	rdi
	inc	rdx
	jmp	%%countLoop
%%countLoopDone:

	mov	rax, SYS_write		; system call for write (SYS_write)
	mov	rdi, STDOUT		; standard output
	lea	rsi, [%1]		; address of the string
	syscall				; call the kernel

	pop	rcx			; restore registers to original values
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax
%endmacro

; =====================================================================
;  Data Declarations.

section	.data

; -----
;  Define constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; system call code for read
SYS_write	equ	1			; system call code for write
SYS_open	equ	2			; system call code for file open
SYS_close	equ	3			; system call code for file close
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF		equ	10
NULL		equ	0
ESC		equ	27

; -----
;  Provided data

lst	dd	1113, 1232, 2146, 1376, 5120, 2356,  164, 4565, 155, 3157
	dd	 759, 326,  171,  147, 5628, 7527, 7569,  177, 6785, 3514
	dd	1001,  128, 1133, 1105,  327,  101,  115, 1108,    1,  115
	dd	1227, 1226, 5129,  117,  107,  105,  109,  999,  150,  414
	dd	 107, 6103,  245, 6440, 1465, 2311,  254, 4528, 1913, 6722
	dd	1149,  126, 5671, 4647,  628,  327, 2390,  177, 8275,  614
	dd	3121,  415,  615,  122, 7217,    1,  410, 1129,  812, 2134
	dd	 221, 2234,  151,  432,  114, 1629,  114,  522, 2413,  131
	dd	5639,  126, 1162,  441,  127,  877,  199,  679, 1101, 3414
	dd	2101,  133, 1133, 2450,  532, 8619,  115, 1618, 9999,  115
	dd	 219, 3116,  612,  217,  127, 6787, 4569,  679,  675, 4314
	dd	1104,  825, 1184, 2143, 1176,  134, 4626,  100, 4566,  346
	dd	1214, 6786,  617,  183,  512, 7881, 8320, 3467,  559, 1190
	dd	 103,  112,    1, 2186,  191,   86,  134, 1125, 5675,  476
	dd	5527, 1344, 1130, 2172,  224, 7525,  100,    1,  100, 1134   
	dd	 181,  155, 1145,  132,  167,  185,  150,  149,  182,  434
	dd	 581,  625, 6315,    1,  617,  855, 6737,  129, 4512,    1
	dd	 177,  164,  160, 1172,  184,  175,  166, 6762,  158, 4572
	dd	6561,  283, 1133, 1150,  135, 5631, 8185,  178, 1197,  185
	dd	 649, 6366, 1162,  167,  167,  177,  169, 1177,  175, 1169

len	dd	200

min	dd	0
med	dd	0
max	dd	0
sum	dd	0
avg	dd	0


; -----
;  Misc. data definitions (if any).

h		dd	0
i		dd	0
j		dd	0
tmp		dd	0


; -----
;  Provided string definitions.

STR_LENGTH	equ	12			; chars in string, with NULL

newLine		db	LF, NULL

hdr		db	"---------------------------"
		db	"---------------------------"
		db	LF, ESC, "[1m", "CS 218 - Assignment #7", ESC, "[0m"
		db	LF, "Shell Sort", LF, LF, NULL

hdrMin		db	"Minimum:  ", NULL
hdrMed		db	"Median:   ", NULL
hdrMax		db	"Maximum:  ", NULL
hdrSum		db	"Sum:      ", NULL
hdrAve		db	"Average:  ", NULL

; ---------------------------------------------

section .bss

tmpString	resb	STR_LENGTH

; ---------------------------------------------

section	.text
global	_start
_start:

; ******************************
;  Shell Sort.
;  Find sum and compute the average.
;  Get/save min and max.
;  Find median.

; eax = h

mov eax, 1
mov r15d, 3

mov r8d, dword[len]	

calcMaxH:
	mov ebx, eax	; hold old value of h for when 3h +1 >= length
	mul r15d
	inc eax
	cmp eax, r8d
	jl calcMaxH
mov eax, ebx	; return previous h if 3h+1 > length

performSort:
	mov rcx, rax		; i = h -1
	dec rcx			
	
	InnerFor1:
		cmp ecx, dword[len]  ; i < length
		jge end1		; skip this for loop if i >= length
	
		mov r8d, dword[lst+(rcx)*4] ; tmp = lst[i]

		InnerFor2:
		
			push rcx 		    	; j = i
			lea r11, [lst+(rcx)*4]		; hold address of lst[j]
			
			cmp rcx, rax			; j >= h or skip this loop
			jl end2			
			
			sub rcx, rax			; j-h
			mov r10d, dword[lst+(rcx)*4]	; lst[j-h]
			
			cmp r10d, r8d			; is lst[j-h] > tmp or skip this loop
			jle end2			
			
			mov dword[r11], r10d		; lst[j] = lst[j-h]
			jmp InnerFor2 
		
		end2:
		pop rcx			; restore i
		mov dword[r11], r8d	; lst[j] = tmp 
		
		inc rcx
		jmp InnerFor1
	end1:
	
	
	mov rdx, 0	; clear for division
	div r15d	; h= h/3
	cmp eax, 0	; again if h > 0
	jg performSort
	
mov eax, dword[lst]
mov dword[min], eax
mov dword[max], eax
mov dword[sum], eax

mov rbx, 0		; running sum
mov ecx, dword[len]	; need all but last

sumLoop:

	dec rcx				; first run aligns us
	cmp rcx, 0			; if were done then time to avg
	je doAvg
	
	mov eax, dword[lst+rcx*4]	; grab element
	add ebx, eax			; add to sum
	
	;min
	cmp eax, dword[min]		; is current < currentMin
	jg $+9				; skip assigning new Min if not
	mov dword[min], eax
	
	;max
	cmp eax, dword[max]		; is current > currentMax 
	jl $+9				; skip assigning new max if not
	mov dword[max], eax	
	jmp sumLoop			; again!
	
doAvg:
	add dword[sum], ebx		; store previous sum
	mov eax, dword[sum]		; reload to eax for division
	cdq
	idiv dword[len]			; convert & divide
	mov dword[avg], eax		; yay answer
	
doMedianEven:
	;length is even need average of middle 2 elements
	; if it was odd the middle (len/2 would suffice)
	
	mov eax, dword[len]
	dec eax
	mov ebx, 2
	mov rdx, 0
	div ebx
	
	mov ebx, eax		; move it back
	
	mov eax, dword[lst+ebx*4]    ; middle left
	add eax, dword[lst+(ebx+1)*4]  ; middle right
	mov edx, 0
	mov ebx, 2
	div ebx			; average of middle
	
	mov dword[med], eax



; ******************************
;  Display results to screen in septenary.

	printString	hdr

	printString	hdrMin
	int2aSept	dword [min], tmpString
	printString	tmpString
	printString	newLine

	printString	hdrMed
	int2aSept	dword [med], tmpString
	printString	tmpString
	printString	newLine

	printString	hdrMax
	int2aSept	dword [max], tmpString
	printString	tmpString
	printString	newLine

	printString	hdrSum
	int2aSept	dword [sum], tmpString
	printString	tmpString
	printString	newLine

	printString	hdrAve
	int2aSept	dword [avg], tmpString
	printString	tmpString
	printString	newLine
	printString	newLine

; ******************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall

