; *****************************************************************
;  Assignment: 6
;  Description:	Simple assembly language program to calculate 
;		the diameters if a circle for a series of circles.
;		The circle radii lengths are provided as septenary values
;		represented as ASCII characters and must be converted into
;		integer in order to perform the calculations.

; =====================================================================
;  STEP #2
;  Macro to convert ASCII/septenary value into an integer.
;  Reads <string>, convert to integer and place in <integer>
;  Assumes valid data, no error checking is performed.

;  Arguments:
;	%1 -> <string>, register -> string address
;	%2 -> <integer>, register -> result

;  Macro usgae
;	aSept2int  <string>, <integer>

;  Example usage:
;	aSept2int	rbx, tmpInteger

;  For example, to get address into a local register:
;		mov	rsi, %1

;  Note, the register used for the macro call (rbx in this example)
;  must not be altered before the address is copied into
;  another register (if desired).

%macro	aSept2int	2

push 	rax	; final value
push	r8	; running sum
push	rcx	; index
push	rdx	; used for powers of 7

mov	r8d, 0			
mov 	rcx, 11		

%%convert
	dec 	rcx		; align
	push 	rcx		; hold my index
	
	neg	rcx		; need - rcx
	add	rcx, 10		; length - rcx is correct offset

	movsx	eax, byte[%1+rcx]	; current char at offset index rcx
	
	pop rcx			; give it back pls
	
	cmp	eax, 32		; check if whitespace
	je	%%convert	; skip whitespace
	
	cmp	eax, 43		; ensure im not converting a +
	je	%%storeSymb		
	
	cmp	eax, 45		; ensure not converting -
	je	%%storeSymb
	
	; eax has a number in ASCII at this point
	
	sub	eax, 48		; numbered offset for ASCII -> int, '0' 
	
	mov rdx, 1		; start base at 1
	
	cmp	rcx, 0		; if were at the last digit then we are both done with string &
	je %%end		; the values are the same since n * 7^0 = n
	
	push 	rcx		; hold my index

	%%compPow:
		imul rdx, 7		; compute 7 ^ s
		loop %%compPow
		
	pop rcx			; gimme my index back
	
	imul	rdx 		; perform n * 7 ^ s, n is number base 7
	add	r8d, eax		; compute sum
	jmp %%convert
	
%%storeSymb:
	push rax
	jmp %%convert
	
%%end:				; power of 0 will end
	add	r8d, eax	; adds last digit of number onto sum
	
	pop	rax		; pull sign
	cmp	eax, 43		; Making the assumption that if its not a + it should be -
	je %%done
	
	neg r8d			; r8 = -r8 negate full register otherwise wont sign properly
	
	%%done:
	mov	dword[%2], r8d	; length is size dword

	


pop	rdx
pop	rcx
pop	r8
pop	rax
	
%endmacro

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
	mov byte[%2+(rcx-1)], SPACE	; store space
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
;  Initialized variables.

section	.data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
NOSUCCESS	equ	1			; unsuccessful operation

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
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

NUMS_PER_LINE	equ	4


; -----
;  Assignment #6 Provided Data

STR_LENGTH	equ	12			; chars in string, with NULL

septRadii	db	"         +5", NULL, "        +10", NULL, "        +16", NULL
		db	"        +24", NULL, "        +35", NULL, "        +46", NULL
		db	"        +55", NULL, "        +63", NULL, "       +106", NULL
		db	"       +143", NULL, "       +144", NULL, "       +155", NULL
		db	"      -2542", NULL, "      -1610", NULL, "      -1361", NULL
		db	"       +266", NULL, "       +330", NULL, "       +421", NULL
		db	"       +502", NULL, "       +516", NULL, "       +642", NULL
		db	"      +1161", NULL, "      +1135", NULL, "      +1246", NULL
		db	"      -1116", NULL, "      -1000", NULL, "       -136", NULL
		db	"      +1540", NULL, "      +1651", NULL, "      +2151", NULL
		db	"      +2161", NULL, "     +10063", NULL, "     -11341", NULL
		db	"     +12224", NULL
aSeptLength	db	"        +46", NULL
length		dd	0

diamSum		dd	0
diamAve		dd	0
diamMin		dd	0
diamMax		dd	0

; -----
;  Misc. variables for main.

hdr		db	"-----------------------------------------------------"
		db	LF, ESC, "[1m", "CS 218 - Assignment #6", ESC, "[0m", LF
		db	"Diameter Calculations", LF, LF
		db	"Diameters:", LF, NULL
shdr		db	LF, "Diameters Sum:  ", NULL
avhdr		db	LF, "Diameters Ave:  ", NULL
minhdr		db	LF, "Diameters Min:  ", NULL
maxhdr		db	LF, "Diameters Max:  ", NULL

newLine		db	LF, NULL
spaces		db	"   ", NULL

ddTwo		dd	2

; =====================================================================
;  Uninitialized variables

section	.bss

tmpInteger	resd	1				; temporaty value

diamsArray	resd	34

lenString	resb	STR_LENGTH
tempString	resb	STR_LENGTH			; bytes

diamSumString	resb	STR_LENGTH
diamAveString	resb	STR_LENGTH
diamMinString	resb	STR_LENGTH
diamMaxString	resb	STR_LENGTH

; **************************************************************

section	.text
global	_start
_start:

; -----
;  Display assignment initial headers.

	printString	hdr

; -----
;  STEP #1
;	Convert integer length, in ASCII septenary format to integer.
;	Do not use macro here...
;	Read string aSeptLength1, convert to integer, and store in length

mov	r8d, 0			; running sum
mov 	rcx, 11			; index
	
cvtL:	
	dec 	rcx		; align
	push 	rcx		; hold my index
	
	neg	rcx		; need - rcx
	add	rcx, 10		

	movsx	eax, byte[aSeptLength+rcx]	; current char at offset index rcx
	
	pop rcx			; give it back pls
	
	cmp	eax, 32		; check if whitespace
	je	cvtL		; skip whitespace
	
	cmp	eax, 43		; ensure im not converting a +
	je	.storeSym		
	
	cmp	eax, 45		; ensure not converting -
	je	.storeSym
	
	; eax has a number in ASCII at this point
	
	sub	eax, 48		; numbered offset for ASCII -> int, '0' 
	
	mov rdx, 1		; start base at 1
	
	cmp	rcx, 0		; if were at the last digit then we are both done with string &
	je end			; the values are the same since n * 7^0 = n
	
	push 	rcx		; hold my index
	
	.computePower:
		imul rdx, 7		; compute 7 ^ s
		loop .computePower
		
	pop rcx			; gimme my index back
	
	imul	rdx 		; perform n * 7 ^ s, n is number base 7
	add	r8d, eax	; compute sum
	jmp cvtL
		
.storeSym:
	push rax
	jmp cvtL
	
end:			; power of 0 will end
	add	r8d, eax	; adds last digit of number onto sum
	
	pop	rax		; pull sign
	cmp	eax, 43		; Making the assumption that if its not a + it should be -
	je done
	
	neg r8d		; r8 = -r8 negate full register otherwise wont sign properly
	
	done: mov	dword[length], r8d

; -----
;  Convert radii from ASCII/septenary format to integer.
;  STEP #2 must complete before this code.

	mov	ecx, dword [length]
	mov	rdi, 0					; index for radii
	mov	rbx, septRadii
cvtLoop:
	push	rbx					; safety push's
	push	rcx
	push	rdi
	aSept2int	rbx, tmpInteger
	pop	rdi
	pop	rcx
	pop	rbx

	mov	eax, dword [tmpInteger]
	mul	dword [ddTwo]				; diam = radius * 2
	mov	dword [diamsArray+rdi*4], eax
	add	rbx, STR_LENGTH

	inc	rdi
	dec	ecx
	cmp	ecx, 0
	jne	cvtLoop

; -----
;  Display each the diamsArray (four per line).

	mov	ecx, dword [length]
	mov	rsi, 0
	mov	r12, 0
printLoop:
	push	rcx					; safety push's
	push	rsi
	push	r12

	mov	eax, dword [diamsArray+rsi*4]
	int2aSept	eax, tempString

	printString	tempString
	printString	spaces

	pop	r12
	pop	rsi
	pop	rcx

	inc	r12
	cmp	r12, 4
	jne	skipNewline
	mov	r12, 0
	printString	newLine
skipNewline:
	inc	rsi

	dec	ecx
	cmp	ecx, 0
	jne	printLoop
	printString	newLine

; -----
;  STEP #3
;	Find diamaters array stats (sum, min, max, and average).
;	Reads data from diamsArray (set above).

mov eax, dword[diamsArray]
mov dword[diamSum], eax
mov dword[diamMin], eax
mov dword[diamMax], eax

mov rbx, 0		; running sum
mov ecx, dword[length]	; need all but last

sumLoop:

	dec rcx
	cmp rcx, 0
	je doAvg
	
	mov eax, dword[diamsArray+rcx*4]
	add ebx, eax
	
	;min
	cmp eax, dword[diamMin]
	jg $+9
	mov dword[diamMin], eax
	
	;max
	cmp eax, dword[diamMax]
	jl $+9
	mov dword[diamMax], eax
	jmp sumLoop
	
doAvg:
	add dword[diamSum], ebx
	mov eax, dword[diamSum]
	cdq
	idiv dword[length]
	mov dword[diamAve], eax

; -----
;  STEP #4
;	Convert sum to ASCII/septenary for printing.
;	Do not use macro here...

	printString	shdr

;	Read diamsArray sum inetger (set above), convert to
;		ASCII/septenary and store in diamSumString.

mov eax, dword[diamSum]	; sum var

cmp eax, 0

jl $+11		; skip pushing a + if its negative
mov rbx, '+'
jmp $+11		; skip pushing -  and negation if its positive
mov rbx, '-'
neg eax

mov ecx, 0		; digit counter for spacing
mov r9d, 7		; static divsior
convert:
	cdq		; convert
	inc ecx		; increase digit counter
	idiv	r9d	; / 7
	add edx, 48	; convert to ascii
	push rdx	; store for reversal
	cmp eax, 0	; is number 0? ( stop : keep dividing)
	jne convert
; rcx here is the # of digits
push rbx	; push sign

add rcx, 1	; account for symbol

neg rcx
add rcx, STR_LENGTH	; length - digit count = # of spaces

push rcx		; hold for next loop
storeSpaces:
	mov byte[diamSumString+(rcx-1)], SPACE	; store space
	dec rcx		
	cmp rcx, 0	; 0 is last valid index
	jne storeSpaces

pop rcx			; good to use since this index-1 was a space
mov rdx, STR_LENGTH	; max length
storeNumber:
	pop rax
	mov byte[diamSumString+(rcx-1)], al	; store ascii septenary
	inc rcx
	cmp rcx, rdx			; last valid index is 11
	jne storeNumber
	
mov byte[diamSumString+rdx+1], NULL	; last value must be null

;	print the diamSumString (set above).
	printString	diamSumString

; -----
;  Convert average, min, and max integers to ASCII/septenary for printing.
;  STEP #5 must complete before this code.

	printString	avhdr
	int2aSept	dword [diamAve], diamAveString
	printString	diamAveString

	printString	minhdr
	int2aSept	dword [diamMin], diamMinString
	printString	diamMinString

	printString	maxhdr
	int2aSept	dword [diamMax], diamMaxString
	printString	diamMaxString

	printString	newLine
	printString	newLine

; *****************************************************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall

