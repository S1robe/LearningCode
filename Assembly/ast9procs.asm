; *****************************************************************
;  Assignment: 9
;  Description: A simple assembly program that implements the backend for a pair program file 'main.cpp'
;				This program take input from the user( a septenary value <= +100000 or >= -100000 within a buffer
;				of 50 characters or less. No input is accepted after the 50th byte, and will be rejected if not ending
;				with a null or line feed (Enter key). The value supplied is then converted to base 10
;				and added to a list defined within 'main.cpp'.
;				After the user is done supplying input, this program will then calculate the statistics on the set of input that the user provided.

; -----------------------------------------------------------------------------
;  Write assembly language functions.

;  Function, shellSort(), sorts the numbers into ascending
;  order (small to large).  Uses the shell sort algorithm
;  modified to sort in ascending order.

;  Function lstSum() to return the sum of a list.

;  Function lstAverage() to return the average of a list.
;  Must call the lstSum() function.

;  Fucntion basicStats() finds the minimum, median, and maximum,
;  sum, and average for a list of numbers.
;  The median is determined after the list is sorted.
;  Must call the lstSum() and lstAverage() functions.

;  Function linearRegression() computes the linear regression.
;  for the two data sets.  Must call the lstAverage() function.

;  Function readSeptNum() should read a septenary number
;  from the user (STDIN) and perform apprpriate error checking.


; ******************************************************************************

section	.data

; -----
;  Define standard constants.

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
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

; -----
;  Define program specific constants.

SUCCESS 	equ	0
NOSUCCESS	equ	1
OUTOFRANGEMIN	equ	2
OUTOFRANGEMAX	equ	3
INPUTOVERFLOW	equ	4
ENDOFINPUT	equ	5

LIMIT		equ	1510

MIN		equ	-100000		;min : -16807  b2digits : 16, fits in a word
MAX		equ	100000		;max : +16807  b2digits : 14, fits in a word

BUFFSIZE	equ	50			; 50 chars including NULL

; -----
;  NO static local variables allowed...


; ******************************************************************************

section	.text

; -----------------------------------------------------------------------------
;  Read an ASCII septenary number from the user.

;  Return codes:
;	SUCCESS			Successful conversion
;	NOSUCCESS		Invalid input entered
;	OUTOFRANGEMIN		Input below minimum value
;	OUTOFRANGEMAX		Input above maximum value
;	INPUTOVERFLOW		User entry character count exceeds maximum length
;	ENDOFINPUT		End of the input

; -----
;  Call:
;	status = readSeptNum(&numberRead);

;  Arguments Passed:
;	1) numberRead, addr - rdi

;  Returns:
;	number read (via reference)
;	status code (as above)

global readSeptNum
readSeptNum:
push rdi			; hold where im supposed to put this silly number
push rbp			; hold my old base
mov rbp, rsp		; hold original rsp

sub rsp, BUFFSIZE	; yay 50 byte buffer
inc rsp				; sign wont be stored, LF cant be helped

mov rsi, rbp		; start from base
mov rcx, 0			; flag register
					; 0b0010		BIT 1: for + sign
					; 0b0100		BIT 2: for - sign
					;
collect:
	dec rsi						; fill rbp - 1 -> rsp (Inclusive)
	mov rax, INPUTOVERFLOW		; assume the worst!
	cmp rsi, rsp
	jb preflush					; rsi is at a lower address than my rsp so we have did not get LF when rsi = rsp (last index in buffer)
collectNoBuffer:
	push rcx				; rcx is used by syscall

							; RAX is overwritten to what we need it to here.
	mov rax, SYS_read		; sys_read 0 call
	mov rdi, STDIN			; place to read is id 0
	; rsi is already set
	mov rdx, 1				; chomp byte
	syscall					; execute my code you computer you!
	pop rcx

	mov rdx, rcx		; hold this

; ------------------- Line Feed -----------------------

	cmp byte[rsi], LF		; is this a line feed.
	je validate			; yes, end input lets validate

; ------------------- SPACE Check ---------------------

	cmp byte[rsi], SPACE	; is it a space?
	jne notSpace
							; yes now check if we had valid input
	mov rax, NOSUCCESS		; Assume its bad
	and cl, 6;0110			; do we have a partial number? i.e given a sign before this
	jnz preflush			; reject x1x 1xx xx1
	mov rcx, rdx			; input was valid

	jmp collectNoBuffer		; the space is valid and we can ignore it.

; ------------------- END SPACE Check ---------------------

; ------------------- Sign Checks -------------------------
notSpace:
	cmp byte[rsi], 43		; plus sign!
	jne checkMinus

; Validate that we havent been given a sign before
	mov rax, NOSUCCESS
	and cl, 6;0110			; kick if x1x, 1xx
	jnz preflush			; I was given a sign after already recieving it or given a number ex 2+ or ++
	mov rcx, rdx			; input was valid

	or cl, 2;0010b			; store the +
	jmp collectNoBuffer

checkMinus:
	cmp byte[rsi], 45			; minus sign!
	jne checkNum

; Validate that we havent been given a sign before

	mov rax, NOSUCCESS
	and cl, 6;0110b		; kick if x1x, 1xx
	jnz preflush		; I was given a sign after already recieving it or given a number ex 2+ or +
	mov rcx, rdx		; input was valid

	or cl, 4;0100b		; store the -
	jmp collectNoBuffer

; ------------------- End Sign Checks -------------------------

; ------------------- Number Check ----------------------------

checkNum:
	mov rax, NOSUCCESS
	and cl, 6;0110b
	jz preflush				; this result being zero implies i havent been given a sign yet

	mov rcx, rdx

	sub byte[rsi], 48		; assume number: if < 0 || > 7 -> invalid
	cmp byte[rsi], 0
	jl preflush			; you gave me something that isnt a number
	cmp byte[rsi], 7
	jge preflush		; you gave me a number greater than 6

; ------------------- END Number Check ----------------------------
	jmp collect


; ------------------------- END BUFFER FILL -----------------------



; Initial checks, handles if LF is only thing in the buffer.
validate:
	mov rax, NOSUCCESS
	push rbp
	sub rbp, rsi		; rbp > rsi for all rsi, if this is 1, we either have an LF or a +/- + LF
	cmp rbp, 1
	je checkForSign		; if length of used buffer is 1, then we must check for sign
	pop rbp
	jmp preConvert		; at this point buffer > 1,  buffer cannot be 0, only options are numbers ending in LF

checkForSign:
	pop rbp
	and cl, 6; 0b0110		; check for if signed
	jnz finish
	mov rax, ENDOFINPUT		; nothing in buffer, EOI
	jmp finish

preConvert:
mov r9, 16807 ; max in sept
mov r10, 7
mov r8, 0
mov rsp, rsi ; if we are here, then rsi will be the address of our line feed
			; collection loop went RBP|----------(rsi)>--------|RSP
mov rsi, rbp ; mov
mov eax, 0	 ; clear conversion sum
convert:
		dec rsi		; move into buffmem on first loop
		cmp rsi, rsp
		je done		; if rsi = rsp, we are at our LF and can be done.

		mul r10d	; init (7*0)
		movzx r11d, byte[rsi]
		add eax, r11d 		; add converted sept(int) into sum

		cmp eax, r9d
		jg fail			; if eax > r9, then we are above/below our max/min

		jmp convert

done:
	mov r8, rax
	mov rax, SUCCESS
	and cl, 4		; if this isnt zero then 0b0100 (BIT 2) was set implies -
	jnz applyNeg
	jmp finish

	applyNeg:
	neg r8			; negate response
	jmp finish

fail:
	and cl, 4		; if this isnt zero then 0b0100 (BIT 2) was set implies -
	jnz failMin
	mov rax, OUTOFRANGEMAX
	jmp finish

	failMin:
	mov rax, OUTOFRANGEMIN
	jmp finish


; This is only reached if we fail validity checks.
preflush:
push rax
mov r9, rbp
sub r9, rsi; construct index in r9
flush:
	mov rax, SYS_read	; sys_read 0 call
	mov rdi, STDIN		; place to read is id 0
	; rsi is already set
	mov rdx, 1			; chomp byte
	syscall				; execute my code you computer you!
	inc r9
	cmp byte[rsi], LF		; Line Feed
	jne flush

	cmp r9, BUFFSIZE	; r9 counts the characters we have, if its greater than the buffer size
	jg override			; then we force override return

	pop rax				; otherwise we just return normally
	jmp finish
	override:
	pop rax
	mov rax, INPUTOVERFLOW

finish:
	mov rsp, rbp		; restore old top
	pop rbp				; restore old bottom
	pop rdi				; adjust stack
	mov dword[rdi], r8d
	ret					; rax was set already





; -----------------------------------------------------------------------------
;  Shell sort function.

; -----
;  HLL Call:
;	call shellSort(list, len)

;  Arguments Passed:
;	1) list, addr
;	2) length, value

;  Returns:
;	sorted list (list passed by reference)


global	shellSort
shellSort:
mov rax, 1
mov r9d, 3

mov r8, rsi	

calcMaxH:
	mov r10, rax	; hold old value of h for when 3h +1 >= length
	mul r9d
	inc rax
	cmp rax, r8
	jl calcMaxH
	
mov rax, r10	; return previous h if 3h+1 > length

performSort:
	mov rcx, rax		; i = h -1
	dec rcx			
	
	InnerFor1:
		cmp rcx, rsi    ; i < length
		jge end1		; skip this for loop if i >= length
	
		mov r8d, dword[rdi+(rcx)*4] ; tmp = lst[i]
		
		mov r9, rcx			; j = i
		InnerFor2:
		
			lea r11, [rdi+(r9)*4]		; hold address of lst[j]
			
			cmp r9, rax			; j >= h or skip this loop
			jl end2			
			
			sub r9, rax			; j-h
			mov r10d, dword[rdi+(r9)*4]	; lst[j-h]
			
			cmp r10d, r8d			; is lst[j-h] > tmp or skip this loop
			jle end2
			
			mov dword[r11], r10d		; lst[j] = lst[j-h]
			jmp InnerFor2 
		
		end2:
		mov dword[r11], r8d	; lst[j] = tmp 
		
		inc rcx
		jmp InnerFor1
	end1:
	
	mov rdx, 0	; clear for division
	mov r9, 3
	div r9d	; h= h/3
	cmp eax, 0	; again if h > 0
	jg performSort

	ret



; -----------------------------------------------------------------------------
;  Find basic statistical information for a list of integers:
;	minimum, median, maximum, sum, and average

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

;  This function must call the lstSum() and lstAvergae() functions
;  to get the corresponding values.

;  Note, assumes the list is already sorted.

; -----
;  HLL Call:
;	call basicStats(list, len, min, med, max, sum, ave)

;  Returns:
;	minimum, median, maximum, sum, and average
;	via pass-by-reference (addresses on stack)



global basicStats
basicStats:
push rdx		; hold min for division

mov rax, rsi	; clone length
dec rax
mov rdx, 0
mov r10, 2		; prepare //2
div r10d		; len-1/2 in eax

cmp edx, 0		; check if length was odd -> doOdd else -> even
je doOddMedian

mov edx, eax		; move it back

mov eax, dword[rdi+rdx*4]    ; middle left
add eax, dword[rdi+(rdx+1)*4]  ; middle right
mov edx, 0
mov r10, 2
div r10d			; average of middle
jmp notOdd

doOddMedian:
mov eax, dword[rdi+rax*4]		; median of odd list is middle

notOdd:
mov dword[rcx], eax				; median stored
pop rdx							; restore minimum addr

mov eax, dword[rdi]
mov dword[rdx], eax				; min
mov eax, dword[rdi+(rsi-1)*4]	; sorted lo-hi list, min is low, max hi
mov dword[r8], eax				; max

	call lstAve
	mov r8, qword[rsp+8]
	mov dword[r8], eax	; address of average is on stack
	call lstSum
	mov dword[r9], eax		; yay sum

	ret




; -----------------------------------------------------------------------------
;  Function to calculate the sum of a list.

; -----
;  Call:
;	ans = lstSum(lst, len)

;  Arguments Passed:
;	1) list, address
;	2) length, value

;  Returns:
;	sum (in eax)

global	lstSum
lstSum:
mov eax, 0
doSum:
	add eax, dword[rdi+(rsi-1)*4] ; sum from end
	dec rsi
	cmp rsi, 0		; is length now 0
	jne doSum		
	ret



; -----------------------------------------------------------------------------
;  Function to calculate the average of a list.
;  Note, must call the lstSum() fucntion.

; -----
;  Call:
;	ans = lstAve(lst, len)

;  Arguments Passed:
;	1) list, address
;	2) length, value

;  Returns:
;	average (in eax)


global	lstAve
lstAve:
	push rsi	; hold counter
	call lstSum	; compute sum
	cdq
	pop rsi		; restore counter
	idiv esi	; compute average
	ret



; -----------------------------------------------------------------------------
;  Function to calculate the linear regression
;  between two lists (of equal size).

; -----
;  Call:
;	linearRegression(xList, yList, len, xAve, yAve, b0, b1)

;  Arguments Passed:
;	1) xList, address
;	2) yList, address
;	3) length, value
;	4) xList average, value
;	5) yList average, value
;	6) b0, address
;	7) b1, address

;  Returns:
;	b0 and b1 via reference

global linearRegression
linearRegression:
push r12		; sum denom
push r13		; sum numer
mov r12, 0
mov r13, 0

;NOTE for me, check each x-XA and y-YA
doCompute:
	movsxd rax, dword[rdi+(rdx-1)*4]	; xi
	movsxd r10, dword[rsi+(rdx-1)*4]    ; yi
	
	sub rax, rcx			; xi -xA
	sub r10, r8			; yi -yA
	
	push rdx			; hold my counter
	push rax			; hold my (xi-xA)
	
	imul r10			; (xi-xA)(yi-yA) -> rDX:rAX	
	add r13, rax
	
	pop rax				; gimme x difference from mean
	imul rax			; square it
	add r12, rax			; sum
	
	pop rdx				; count again :D
	dec rdx
	cmp rdx, 0
	jne doCompute

break:
movsxd rax, r13d		; for some reason this will only fill for the bits i have, its not an auto replace
cqo			; 128 bit division 
idiv r12

pop r12
pop r13			; restore registers that will not be used further to address stack properly

mov r10, qword[rsp+8]	; 
mov dword[r10], eax	; stored b1

imul rcx		; b1 * xA

sub r8, rax
mov dword[r9], r8d
	
	ret



; -----------------------------------------------------------------------------

