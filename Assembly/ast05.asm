; Section: 2
; Assignment: 3
; Description: A program that finds the volume and surface area for each of the rectangular solid in a set of rectangular solids. Once the values are computed, the program finds the minimum, maximum, estimated median, sum, and average for the volumes and surface areas.




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
; -----
;  Provided Data

lengths		dd	 1355,  1037,  1123,  1024,  1453
		dd	 1115,  1135,  1123,  1123,  1123
		dd	 1254,  1454,  1152,  1164,  1542
		dd	-1353,  1457,  1182, -1142,  1354
		dd	 1364,  1134,  1154,  1344,  1142
		dd	 1173, -1543, -1151,  1352, -1434
		dd	 1134,  2134,  1156,  1134,  1142
		dd	 1267,  1104,  1134,  1246,  1123
		dd	 1134, -1161,  1176,  1157, -1142
		dd	-1153,  1193,  1184,  1142

widths		dw	  367,   316,   542,   240,   677
		dw	  635,   426,   820,   146,  -333
		dw	  317,  -115,   226,   140,   565
		dw	  871,   614,   218,   313,   422	
		dw	 -119,   215,  -525,  -712,   441
		dw	 -622,  -731,  -729,   615,   724
		dw	  217,  -224,   580,   147,   324
		dw	  425,   816,   262,  -718,   192
		dw	 -432,   235,   764,  -615,   310
		dw	  765,   954,  -967,   515

heights		db	   42,    21,    56,    27,    35
		db	  -27,    82,    65,    55,    35
		db	  -25,   -19,   -34,   -15,    67
		db	   15,    61,    35,    56,    53
  		db	  -32,    35,    64,    15,   -10
		db	   65,    54,   -27,    15,    56
		db	   92,   -25,    25,    12,    25
		db	  -17,    98,   -77,    75,    34
		db	   23,    83,   -73,    50,    15
		db	   35,    25,    18,    13

count		dd	49

vMin		dd	0
vEstMed		dd	0
vMax		dd	0
vSum		dd	0
vAve		dd	0

saMin		dd	0
saEstMed	dd	0
saMax		dd	0
saSum		dd	0
saAve		dd	0


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;  Uninitialized data
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

section	.bss

volumes		resd	49
surfaceAreas	resd	49

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;  Linker Start
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

section	.text
global _start
_start:

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;  Code Start
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;Manually calculating first loop to set min maxes

; Volume: H * W * L
	movsx 	eax, byte[heights]		; grab height	
	movsx	ecx, word[widths]		; grab width
	imul	eax, ecx
	imul	eax, dword[lengths]		; multiply by length
	
	mov	dword[vMin], eax		; first vol is min & max
	mov	dword[vMax], eax
	

	mov	dword[volumes+0], eax		; Store volume signed

	add	eax, dword[vSum]		; Sum
	mov	dword[vSum], eax
	
; Surface Area: 2(WL + HL + HW)
		
	movsx	eax, word[widths]		; extend width
	imul	eax, dword[lengths]		; W*L
	
	movsx	ecx, byte[heights];		; extend height
	imul	ecx, dword[lengths]		; H*L
	add	eax, ecx			; added to running sum
	
	movsx	ecx, byte[heights]  		; Extend height
	movsx	edx, word[widths]		; extend width
	imul	ecx, edx			; H*W
	add	eax, ecx			; + LW+LH
	imul	eax, 2				; ()*2
	
	mov	dword[saMin], eax		; first SA is min and max
	mov	dword[saMax], eax
	
	mov	dword[surfaceAreas+0], eax	; Stored
	
	add	eax, dword[saSum]		; Sum
	mov	dword[saSum], eax


; SET LOOP COUNT, using this across the loops, starting @ 1 because did first loop above to set min/maxes
	mov	rbx, 1
	
mainLoop:
	; Calculate & Apply offset 
	
		mov	rax, rbx		; b -> a for loop counter (in memory size)
		mov	r11b, 1			; store 1 byte offset for bytes
		mul	r11b			; multiply by memory offset
		mov	r10, heights		; move array 
		add	r10, rax		; apply offset
		
		mov	rax, rbx	
		mov	r11b, 2			; 2 byte offset for words	
		mul	r11b	
		mov	r9, widths	
		add	r9, rax
		
		mov	rax, rbx		
		mov	r11b, 4			; 4 byte offset for dwords
		mul	r11b	
		mov	r8, lengths		
		add	r8, rax		
		
		mov	r11, volumes
		add	r11, rax		; apply 4 byte offset for volumes array
		
		mov	r12, surfaceAreas
		add	r12, rax		; apply 4 byte offset for SA array
		
						
	
	; Volume
		movsx 	eax, byte[r10]		; grab height	
		movsx	ecx, word[r9]		; grab width
		imul	eax, ecx
		imul	eax, dword[r8]		; multiply by length
		
	; Min
		mov	ecx, dword[vMin]	; currMinV
		cmp	eax, ecx 		; is currElem < currMinV 
		jl	doMinV
		
	; Max
		mov	ecx, dword[vMax]	; currMaxV
		cmp	eax, ecx 		; is currElem > currMaxV 
		jg	doMaxV
	
doneCmpV:
		
		mov	dword[r11], eax 	; Stored
		
		
		add	eax, dword[vSum]	; Sum
		mov	dword[vSum], eax
	
	; Surface Area
		movsx	eax, word[r9]	; width
		imul	eax, dword[r8]	; W*L
		
		movsx	ecx, byte[r10]	; height
		imul	ecx, dword[r8]	; H*L
		add	eax, ecx	; WL+HL
		
		movsx	ecx, byte[r10]  ; height
		movsx	edx, word[r9]	; width
		imul	ecx, edx	; H*W
		add	eax, ecx	; + LW+LH
		imul	eax, 2		; prev*2

	; Min
		mov	ecx, dword[saMin]	; currMinSA
		cmp	eax, ecx		; is currElem < currMinSA
		jl	doMinSA
			
	; Max
		mov	ecx, dword[saMax]	; currMaxSA
		cmp	eax, ecx		; is currElem > currMaxSA
		jg	doMaxSA
		
doneCmpSA:
		mov	dword[r12], eax		; Stored

		add	eax, dword[saSum]	;Sum
		mov	dword[saSum], eax


inc bl
cmp bl, 49
jne mainLoop

;V & SA Median 
	; Memory offset 
		mov	rax, 0 			; clear upper bits
		mov	eax, dword[count]
		sub	rax, 1			; length - 1 
		mov 	rbx, 4
		mul	rbx			; apply 4 byte offset
		
; vEstMedian
	mov	ebx, dword[volumes]		; First V
	add	ebx, dword[volumes+rax] 	; Last	V
	
	;Adjust memory offset to middle
		mov	ecx, 2
		div	ecx			; length-1/2 for middle
	
	add	ebx, dword[volumes+rax] 	; middle
	mov	eax, ebx			; sum -> eax
	mov	ebx, 3		
	div	ebx				; sum/3 = estMed
	
	mov	dword[vEstMed], eax		; Stored
	
	; Compute memory offset 
		mov	rax, 0 			; clear upper bits
		mov	eax, dword[count]
		sub	rax, 1			; length - 1 
		mov 	rbx, 4
		mul	rbx			; apply 4 byte offset

; saEstMedian
	mov	ebx, dword[surfaceAreas]	; First S
	add	ebx, dword[surfaceAreas+rax] 	; Last  S
	
	;Adjust memory offset to middle
		mov	ecx, 2
		div	ecx			; length-1/2 for middle
		
	add	ebx, dword[surfaceAreas+rax] 	; middle
	mov	eax, ebx			; sum -> eax
	mov	ebx, 3		
	div	ebx				; sum/3 = estMed
	
	mov	dword[saEstMed], eax		; Stored

;V & SA Average

	mov 	eax, dword[vSum]	; VSum
	cdq	
	idiv	dword[count]		; Vsum/length = avg
	mov	dword[vAve], eax	; take integer part

	mov 	eax, dword[saSum]	
	cdq
	idiv	dword[count]
	mov	dword[saAve], eax
	

jmp last


doMinV:	
	mov	dword[vMin], eax	; currElem < currMinV 
	jmp	doneCmpV

doMaxV:
	mov	dword[vMax], eax 	; currElem > currMinV 
	jmp	doneCmpV

doMinSA:
	mov	dword[saMin], eax 	; currElem < currMinSA 
	jmp	doneCmpSA

doMaxSA:
	mov	dword[saMax], eax	; currElem < currMaxSA
	jmp	doneCmpSA


last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rbx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall

	






ven
