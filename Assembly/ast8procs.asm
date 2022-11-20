; *****************************************************************
;  Assignment: 8
;  Description: Sorts a given set of data in descending order using shell sort with a gap length of 3
;				Implements a sum function to compute the sum of a list of numbers
;				Computes the average of a list of numbers using function lstSum()
;				Implements a function basicStats() which computes: Min, max, median, average for a provided list
;				Implements a function LinearRegression(), which computes a linear regression b1 and b0 for two provided data sets.


; -----------------------------------------------------------------
;  Write some assembly language functions.

;  The function, shellSort(), sorts the numbers into descending
;  order (large to small).  Uses the shell sort algorithm from
;  assignment #7 (modified to sort in descending order).

;  The function, basicStats(), finds the minimum, median, and maximum,
;  sum, and average for a list of numbers.
;  Note, the median is determined after the list is sorted.
;	This function must call the lstSum() and lstAvergae()
;	functions to get the corresponding values.
;	The lstAvergae() function must call the lstSum() function.

;  The function, linearRegression(), computes the linear regression of
;  the two data sets.  Summation and division performed as integer.

; *****************************************************************

section	.data

; -----
;  Define constants.

TRUE		equ	1
FALSE		equ	0

; -----
;  Local variables for shellSort() function (if any).



; -----
;  Local variables for basicStats() function (if any).


; -----------------------------------------------------------------

section	.bss

; -----
;  Local variables for linearRegression() function (if any).

qSum		resq	1
dSum		resd	1


; *****************************************************************

section	.text

; --------------------------------------------------------
;  Shell sort function (form asst #7).
;	Updated to sort in descending order.

; -----
;  HLL Call:
;	call shellSort(list, len)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value - rsi

;  Returns:
;	sorted list (liss passed by reference)

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
			
			cmp r10d, r8d			; is lst[j-h] < tmp or skip this loop
			jge end2			
			
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

; --------------------------------------------------------
;  Find basic statistical information for a list of integers:
;	minimum, median, maximum, sum, and average

;  Note, for an odd number of items, the median value is defined as
;  the middle value.  For an even number of values, it is the integer
;  average of the two middle values.

;  This function must call the lstSum() and lstAvergae() functions
;  to get the corresponding values.

;  Note, assumes the list is already sorted.

; -----
;  Call:
;	call basicStats(list, len, min, med, max, sum, ave)

;  Arguments Passed:
;	1) list, addr - rdi
;	2) length, value - rsi
;	3) minimum, addr - rdx
;	4) median, addr - rcx
;	5) maximum, addr - r8
;	6) sum, addr - r9
;	7) ave, addr - stack, rbp+16

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

mov eax, dword[rdi+(rsi-1)*4]	; set max and min to last value
mov dword[rdx], eax				; min
mov dword[r8], eax				; max
push rsi						; store my length
doLoop:
	dec rsi
	cmp rsi, 0					; loop( length -1 -> 0 )
	je endLoop
	mov eax, dword[rdi+(rsi-1)*4]	; mutating rsi as index
	
	;min
	cmp eax, dword[rdx]	; is current < currentMin
	jg $+9				; skip assigning new Min if not
	mov dword[rdx], eax
	
	;max
	cmp eax, dword[r8]	; is current > currentMax 
	jl $+9				; skip assigning new max if not
	mov dword[r8], eax	
	jmp doLoop			; again!
	
	endLoop:
						;Min and max are calculated at this point
						
	pop rsi			; pull old rsi off stack
	call lstAve
	mov r8, qword[rsp+8]
	mov dword[r8], eax	; address of average is on stack
	call lstSum
	mov dword[r9], eax		; yay sum

	ret

; --------------------------------------------------------
;  Function to calculate the sum of a list.

; -----
;  Call:
;	ans = lstSum(lst, len)

;  Arguments Passed:
;	1) list, address - rdi
;	1) length, value - rsi

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

; --------------------------------------------------------
;  Function to calculate the average of a list.
;  Note, must call the lstSum() fucntion.

; -----
;  Call:
;	ans = lstAve(lst, len)

;  Arguments Passed:
;	1) list, address - rdi
;	1) length, value - rsi

;  Returns:
;	average (in eax)


global	lstAve
lstAve:
	push rsi	; hold counter
	call lstSum	; compute sum
	cdq		
	pop rsi		; restore counter
	idiv rsi	; compute average
	ret

; --------------------------------------------------------
;  Function to calculate the linear regression
;  between two lists (of equal size).
;  Due to the data sizes, the summation for the dividend (top)
;  MUST be performed as a quad-word.

; -----
;  Call:
;	linearRegression(xList, yList, len, xAve, yAve, b0, b1)

;  Arguments Passed:
;	1) xList, address - rdi
;	2) yList, address - rsi
;	3) length, value - edx
;	4) xList average, value - ecx
;	5) yList average, value - r8d
;	6) b0, address - r9
;	7) b1, address - stack, rbp+16

;  Returns:
;	b0 and b1 via reference

global linearRegression
linearRegression:
push r12		; sum denom
push r13		; sum numer
mov r12, 0
mov r13, 0

				; align to index
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

mov rax, r13
cqo			; 128 bit division 
idiv r12

pop r12
pop r13			; restore registers that will not be used further to address stack properly

mov r10, qword[rsp+8]	; 
mov dword[r10], eax	; stored b1
break:

imul rcx		; b1 * xA

sub r8, rax
mov dword[r9], r8d
	
	ret

; ********************************************************************************

