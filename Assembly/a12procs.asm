; *****************************************************************
;  Assignment: 12
;  Description: This is a simple assembly program that will calculate the all the narcissistic numbers from 0 to either a user defined limit or 4 billion, whichever is smaller. This program attempts to employ thread-safe practices in an attempt to improove performance.

; -----
;  Narcissistic Numbers
;	0, 1, 2, 3, 4, 5,
;	6, 7, 8, 9, 153,
;	370, 371, 407, 1634, 8208,
;	9474, 54748, 92727, 93084, 548834,
;	1741725, 4210818, 9800817, 9926315, 24678050,
;	24678051, 88593477, 146511208, 472335975, 534494836,
;	912985153, 4679307774, 32164049650, 32164049651

; ***************************************************************

section	.data

; -----
;  Define standard constants.

LF		equ	10			; line feed
NULL		equ	0			; end of string
ESC		equ	27			; escape key

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1			; Unsuccessful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; call code for read
SYS_write	equ	1			; call code for write
SYS_open	equ	2			; call code for file open
SYS_close	equ	3			; call code for file close
SYS_fork	equ	57			; call code for fork
SYS_exit	equ	60			; call code for terminate
SYS_creat	equ	85			; call code for file open/create
SYS_time	equ	201			; call code for get time

; -----
;  Globals (used by threads)

currentIndex	dq	0
myLock		dq	0
BLOCK_SIZE	dq	1000

; -----
;  Local variables for thread function(s).

msgThread1	db	" ...Thread starting...", LF, NULL

; -----
;  Local variables for getUserArgs function

LIMITMIN	equ	1000
LIMITMAX	equ	4000000000

errUsage	db	"Usgae: ./narCounter -t <1|2|3|4|5|6> ",
		db	"-l <septNumber>", LF, NULL
errOptions	db	"Error, invalid command line options."
		db	LF, NULL
errLSpec	db	"Error, invalid limit specifier."
		db	LF, NULL
errLValue	db	"Error, limit out of range."
		db	LF, NULL
errTSpec	db	"Error, invalid thread count specifier."
		db	LF, NULL
errTValue	db	"Error, thread count out of range."
		db	LF, NULL
		
; -----
;  Local variables for sept2int function

qSeven		dq	7
qTen		dq	10

; ***************************************************************

section	.text

; ******************************************************************
;  Thread function, numberTypeCounter()
;	Detemrine if narcissisticCount for all numbers between
;	1 and userLimit (gloabally available)

; -----
;  Arguments:
;	N/A (global variable accessed)
;  Returns:
;	N/A (global variable accessed)

common	userLimit	1:8
common	narcissisticCount	1:8
common	narcissisticNumbers	100:8

global narcissisticNumberCounter
narcissisticNumberCounter:
mov rdi, msgThread1
call printString

restart:
call spinLock

mov r8, qword[currentIndex] 	; get low also index
cmp r8, qword[userLimit]		; out of numbers
jge release

mov r9, r8
add r9, qword[BLOCK_SIZE]		; get ending index, this will include this number
cmp r9, qword[userLimit]	; makes sure that we are within bounds
jle begin
; at this point the # of #'s is less than the BLOCK_SIZE and therefore this thread will be the last one to execute
mov r9, qword[userLimit]
begin:
inc r9
mov qword[currentIndex], r9	; remove the numbers im working on from the pool
call spinUnlock

loop2:

	mov r11, 0
	mov rsi, 0		; temp sum var
	cmp r8, r9
	je restart

	cont:
	mov rdx, 0
	; tmpNum is digit counter
	mov rax, r8
	; repeatedly divide by 10, to get the digits
	loopDigitCount:
		mov rdx, 0		; reset for division
		div qword[qTen] ; divide by 10
		push rdx
		inc r11	; count digits
		cmp rax, 0		; ensure not 0
		jne loopDigitCount

	mov rdi, r11	; counter for pops
	loopSum:	; this loop was responsilbe for repeated division i am storing the digits on the stack of this thread
		mov rcx, r11	; decremental counter
		pop r10		; last digit of number
		dec rdi
		mov rax, 1

		loopPower:
			mul r10	; repeatedly multiply by my digit till were done.
		loop loopPower

		add rsi, rax	; add D^power
		cmp rdi, 0
		jne loopSum

		cmp rsi, r8			; does the sum add to itself?
		jne endSum

		call spinLock

		mov rax, qword[narcissisticCount]
		mov qword[narcissisticNumbers + (rax * 8)],  r8 	;
		inc qword[narcissisticCount] ; add counter


		call spinUnlock

	endSum:
		inc r8
		jmp loop2

release:
call spinUnlock
ret


; ******************************************************************
;  Mutex lock
;	checks lock (shared gloabl variable)
;		if unlocked, sets lock
;		if locked, lops to recheck until lock is free

global	spinLock
spinLock:
	mov	rax, 1			; Set the EAX register to 1.

lock	xchg	rax, qword [myLock]	; Atomically swap the RAX register with
					;  the lock variable.
					; This will always store 1 to the lock, leaving
					;  the previous value in the RAX register.

	test	rax, rax	        ; Test RAX with itself. Among other things, this will
					;  set the processor's Zero Flag if RAX is 0.
					; If RAX is 0, then the lock was unlocked and
					;  we just locked it.
					; Otherwise, RAX is 1 and we didn't acquire the lock.

	jnz	spinLock		; Jump back to the MOV instruction if the Zero Flag is
					;  not set; the lock was previously locked, and so
					; we need to spin until it becomes unlocked.
	ret

; ******************************************************************
;  Mutex unlock
;	unlock the lock (shared global variable)

global	spinUnlock
spinUnlock:
	mov	rax, 0			; Set the RAX register to 0.

	xchg	rax, qword [myLock]	; Atomically swap the RAX register with
					;  the lock variable.
	ret

; ******************************************************************
;  Function getUserArgs()
;	Get, check, convert, verify range, and return the
;	sequential/parallel option and the limit.

;  Example HLL call:
;	stat = getUserArgs(argc, argv, &parFlag, &numberLimit)

;  This routine performs all error checking, conversion of ASCII/septenary
;  to integer, verifies legal range.
;  For errors, applicable message is displayed and FALSE is returned.
;  For good data, all values are returned via addresses with TRUE returned.

;  Command line format (fixed order):
;	-t <1|2|3|4|5|6> -l <septNumber>

; -----
;  Arguments:
;	1) ARGC, value						rdi
;	2) ARGV, address					rsi
;	3) thread count (dword), address	rdx
;	4) user limit (qword), address		rcx
global getUserArgs
getUserArgs:
mov r8, errUsage
cmp rdi, 1
jle fail

mov r8, errOptions
cmp rdi, 5
jne fail

add rsi, 8		; dont care about the name of the program.


mov r10, qword[rsi]	; give r10 the string address of the '-t'


mov r8, errTSpec
cmp byte[r10], "-"
jne fail
inc r10
cmp byte[r10], "t"
jne fail
inc r10
cmp byte[r10], 0
jne fail

add rsi, 8	 			; advance argV

mov r10, qword[rsi]	; threadded count
sub byte[r10], 48		; convert ascii to decimal

mov r8, errTValue
cmp byte[r10], 6		; no more than
jg fail
cmp byte[r10], 1		; no less than
jl fail

movzx r11, byte[r10]	; store thread count
mov dword[rdx], r11d

inc r10
cmp byte[r10], 0		; non singular digit
jne fail

add rsi, 8	; advacne argV to -lm
mov r10, qword[rsi]	; "-lm"

mov r8, errLSpec
cmp byte[r10], "-"
jne fail
inc r10
cmp byte[r10], "l"
jne fail
inc r10
cmp byte[r10], 0
jne fail

add rsi, 8
mov rdi, qword[rsi] ; string is in rdi ready for calling
mov rsi, rcx		; move address of number os i can set it
call aSept2int

mov r8, errLValue
cmp rax, FALSE
je fail

mov rax, LIMITMAX

cmp qword[rcx], rax
jg fail

cmp qword[rcx], LIMITMIN
jl fail

mov rax, TRUE
ret


fail:
mov rdi, r8
call printString
mov rax, FALSE
ret


; ******************************************************************
;  Function: Check and convert ASCII/septenary to integer.

;  Example HLL Call:
;	bool = aSept2int(septStr, &num);
global aSept2int
aSept2int:
mov rax, 0	; result
mov r9, 0	; sum

cmp byte[rdi], 0	; strings are null terminated
je fail2

lope:
	cmp byte[rdi], 0	; strings are null terminated
	je done

	mov r9b, byte[rdi]
	sub r9b, 48

	cmp r9b, 0	; 0 allowed, but not below
	jl fail2

	cmp r9b, 7	; 7 & greater not allowed
	jge fail2

	mul qword[qSeven]	; result in rax:rdx
	add rax, r9

	inc rdi

	jmp lope

fail2:
mov rax, FALSE
ret

done:
mov qword[rsi], rax	; return result
mov rax, TRUE
ret





; ******************************************************************
;  Generic function to display a string to the screen.
;  String must be NULL terminated.
;  Algorithm:
;	Count characters in string (excluding NULL)
;	Use syscall to output characters

;  Arguments:
;	1) address, string
;  Returns:
;	nothing

global	printString
printString:
	push	rbx

; -----
;  Count characters in string.

	mov	rbx, rdi			; str addr
	mov	rdx, 0
strCountLoop:
	cmp	byte [rbx], NULL
	je	strCountDone
	inc	rbx
	inc	rdx
	jmp	strCountLoop
strCountDone:

	cmp	rdx, 0
	je	prtDone

; -----
;  Call OS to output string.

	mov	rax, SYS_write			; system code for write()
	mov	rsi, rdi			; address of characters to write
	mov	rdi, STDOUT			; file descriptor for standard in
						; EDX=count to write, set above
	syscall					; system call

; -----
;  String printed, return to calling routine.

prtDone:
	pop	rbx
	ret

; ******************************************************************

