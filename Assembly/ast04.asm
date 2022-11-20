; Assignment: 3
; Description: A simple assembly language program to find the minimum, estimated median value, maximum, sum, and integer average of a list of numbers. Additionally, the program finds the sum, count, and integer average for the odd numbers. The program also finds the sum, count, and integer average for the numbers that are evenly divisible by 9.

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;  Constants
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

section .data

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;  Variables (Pre-Defined)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

lst		dd	4224, 1116, 1542, 1240, 1677
		dd	1635, 2420, 1820, 1246, 1333
		dd	2315, 1215, 2726, 1140, 2565
		dd	2871, 1614, 2418, 2513, 1422
		dd	1119, 1215, 1525, 1712, 1441
		dd	3622, 1731, 1729, 1615, 2724
		dd	1217, 1224, 1580, 1147, 2324
		dd	1425, 1816, 1262, 2718, 1192
		dd	1435, 1235, 2764, 1615, 1310
		dd	1765, 1954, 1967, 1515, 1556
		dd	1342, 7321, 1556, 2727, 1227
		dd	1927, 1382, 1465, 3955, 1435
		dd	1225, 2419, 2534, 1345, 2467
		dd	1615, 1959, 1335, 2856, 2553
		dd	1035, 1833, 1464, 1915, 1810
		dd	1465, 1554, 1267, 1615, 1656
		dd	2192, 1825, 1925, 2312, 1725
		dd	2517, 1498, 1677, 1475, 2034
		dd	1223, 1883, 1173, 1350, 2415
		dd	1335, 1125, 1118, 1713, 3025
length		dd	100

lstMin		dd	0
estMed		dd	0
lstMax		dd	0
lstSum		dd	0
lstAve		dd	0

oddCnt		dd	0
oddSum		dd	0
oddAve		dd	0

nineCnt		dd	0
nineSum		dd	0
nineAve		dd	0

section .bss
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;  Linker Start
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

section	.text
global _start
_start:

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;  Code Start
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


; SET MIN VAR
	mov	eax,  dword[lst]
	mov	dword[lstMin], eax

; SET MAX VAR
	mov	eax,  dword [lst]
	mov	dword[lstMax], eax

; SET LOOP COUNT, skipping first because we took first elem already.
	mov	bl, 0

minMaxSumLoop:
	; Calculate Array offset
		movzx	rax, bl			; copy bl to al
		mov	r9b, 4			; store 4 for multiplication
		mul	r9b			; perform multiplication result in ah:al,
		mov	r8, rax			; move & convert to 64 bit form for memory

	; Get Memory Address for current element
		add	r8, lst			; apply offset

	; List Sum
		mov	eax, dword [lstSum]
		add	eax, dword [r8]
		mov	dword[lstSum], eax

	; Odd Sum
		mov	edx, 0			; clear hi to divide
		mov	eax, dword [r8]		; pull current to eax
		mov	r9d, 2
		div	r9d			; divide by 2
		cmp	edx, 0			; IF odd, then edx != 0
		jne	sumOdd

_9Sum:

	; Nine Sum
		mov	ax, word [r8]		; pull current elem lo
		mov	dx, word [r8+2]		; pull curr elem hi
		mov	r9w, 9
		div	r9w			; divide by 9
		cmp	dx, 0			; IF divisible by 9, then edx == 0
		je	sumNine

doCmp:
		mov	ecx, dword[r8]		; pull currElem

	; Min
		mov	edx, dword[lstMin]	; pull currMin
		cmp	ecx, edx		; is currElem < currMin ? rFlag = (1 : 0)
		jb	doMin			; skip next instruction if above is false

	; Max, only done if min is not found, b/c if elem is new min, it cannot be new max
		mov	edx, dword[lstMax]	; pull currMax
		cmp	ecx, edx		; currElem > currMax ? rFlag = (1 : 0)
		ja	doMax			; skip next instruction if above is false

doneCmp:

inc bl
cmp bl, 100
jne minMaxSumLoop

; COMPUTE LIST MEDIAN

	; compute middle memory address
		mov	eax, dword[length]	; pull length
		mov	r9, 2
		mul	r9			; multiply by 2, same as *4 then /2,
						; converting to memory
		mov	rbx, rax		; store for later

	;Find Median (Estimated) estMed = (lst[0]+lst[(len-1)] + lst[len/2] + lst[(len/2)-1])/4

		; Compute (length - 1) then convert to memory format
			mov	eax, dword[length]	; pull length
			sub	rax, 1			; sub 1
			mov	r9, 4
			mul	r9			; convert to memory length for dwords
			mov	rdx, rax		; store for later

		mov	eax, dword[lst] 		; pull first element

		add	eax, dword[lst+rdx]		; last
		add	eax, dword[lst+rbx] 		; middle right element
		add	eax, dword[lst+rbx-4]		; middle left element
		mov	edx, 0				; clear upper bits
		mov	r9d, 4
		div	r9d				; Divide sum by 4

		mov	dword[estMed], eax		; estimated median in eax

	; COMPUTE LIST AVERAGE
		mov	edx, 0				; clear upper
		mov	eax, dword[lstSum]		; pull sum
		div	dword[length]			; divide by # elements
		mov	dword[lstAve], eax		; result in eax

	; COMPUTE ODD AVERAGE
		mov	edx, 0				; clear upper
		mov	eax, dword[oddSum]		; pull sum of odd #
		div	dword[oddCnt]			; divide by counted odd #
		mov	dword[oddAve], eax		; result in eax

	; COMPUTE NINE AVERAGE
		mov	edx, 0				; clear upper
		mov	eax, dword[nineSum]		; pull sum of nine-divis #
		div	dword[nineCnt]			; divide by count
		mov	dword[nineAve], eax		; result in eax

jmp last

;SUM ODD VALUES
sumOdd:
	inc	dword[oddCnt]		; increment counted odds

	mov	eax, dword[oddSum]	; pull current odd sum
	add	eax, dword[r8]		; add current element value
	mov	dword[oddSum], eax	; store sum
	jmp	_9Sum			; return

;SUM NINE DIVISIBLE VALUES
sumNine:
	inc	dword[nineCnt]		; increment counted nine-divis #

	mov	eax, dword[nineSum]	; pull current nine-sum
	add	eax, dword[r8]		; add current element value
	mov	dword[nineSum], eax	; store sum
	jmp	doCmp			; return

; MIN
doMin:
	mov	dword[lstMin], ecx	; ecx held my current element, overwrite with current
	jmp	doneCmp

; MAX
doMax:
	mov	dword[lstMax], ecx	; ecx held my current elem, overwrite with current
	jmp	doneCmp

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rbx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall









