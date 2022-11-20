; *****************************************************************
;  Assignment: 10
;  Description: This is a simple assembyl program to draw a fun circle within a circle animation. It takes command line
;					arguements in septenary representing the color of the wheel and the radius

; -----
;  Function: getParams
;	Gets, checks, converts, and returns command line arguments.

;  Function drawWheels()
;	Plots functions

; ---------------------------------------------------------

;	MACROS (if any) GO HERE
; Converts the number in %1 from sept to int into %2, does the checking for sept validity
%macro ASCIISept2Int 2
mov rax, 0
mov r9, 0
mov r8, 7
%%loop:
	mov r9b, byte[%1]
	sub r9b, 48
	cmp r9b, 0	; 0 allowed, but nopt below
	jl %%fail
	cmp r9b, 7	; 7 & greater not allowed
	jge %%fail

	mul r8d
	add rax, r9
	inc %1
	cmp byte[%1], 0	; strings are null terminated
	je %%done
	jmp %%loop

%%fail:
	pop r8
	pop rdx
	cmp %2, 1;
	je %%failValueSpd
	cmp %2, 2 ;clr
	je %%failValueClr

	;failValueSize
		mov rax, errSizValue
		jmp fail

	%%failValueSpd:
		mov rax, errSpdValue
		jmp fail

	%%failValueClr:
		mov rax, errClrValue
		jmp fail

%%done:
%endmacro

; ---------------------------------------------------------

section  .data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	1

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; code for read
SYS_write	equ	1			; code for write
SYS_open	equ	2			; code for file open
SYS_close	equ	3			; code for file close
SYS_fork	equ	57			; code for fork
SYS_exit	equ	60			; code for terminate
SYS_creat	equ	85			; code for file open/create
SYS_time	equ	201			; code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

; -----
;  OpenGL constants

GL_COLOR_BUFFER_BIT	equ	16384
GL_POINTS		equ	0
GL_POLYGON		equ	9
GL_PROJECTION		equ	5889

GLUT_RGB		equ	0
GLUT_SINGLE		equ	0

; -----
;  Define program specific constants.

SPD_MIN		equ	1
SPD_MAX		equ	50			; 101(7) = 50

CLR_MIN		equ	0
CLR_MAX		equ	0xFFFFFF		; 0xFFFFFF = 262 414 110(7)

SIZ_MIN		equ	100			; 202(7) = 100
SIZ_MAX		equ	2000			; 5555(7) = 2000

; -----
;  Local variables for getParams functions.

STR_LENGTH	equ	12

errUsage	db	"Usage: ./wheels -sp <septNumber> -cl <septNumber> "
		db	"-sz <septNumber>"
		db	LF, NULL
errBadCL	db	"Error, invalid or incomplete command line argument."
		db	LF, NULL

errSpdSpec	db	"Error, speed specifier incorrect."
		db	LF, NULL
errSpdValue	db	"Error, speed value must be between 1 and 101(7)."
		db	LF, NULL

errClrSpec	db	"Error, color specifier incorrect."
		db	LF, NULL
errClrValue	db	"Error, color value must be between 0 and 262414110(7)."
		db	LF, NULL

errSizSpec	db	"Error, size specifier incorrect."
		db	LF, NULL
errSizValue	db	"Error, size value must be between 202(7) and 5555(7)."
		db	LF, NULL

; -----
;  Local variables for drawWheels routine.

t		dq	0.0			; loop variable
s		dq	0.0
tStep		dq	0.001			; t step
sStep		dq	0.0
x		dq	0			; current x
y		dq	0			; current y
scale		dq	7500.0			; speed scale

fltZero		dq	0.0
fltOne		dq	1.0
fltTwo		dq	2.0
fltThree	dq	3.0


fltTwoPi	dq 	0.0		;
fltSixPi	dq	6.0		; used to be fltSix

fltTwoPiOv3 dq	0.0		;used to be for 2pis
fltFourPi	dq	4.0		; used to be fltFour

flt2C2piSOv3 dq 0.0		; used to be tmp1
flt2S2piSOv3 dq 0.0		; used to be tmp2

pi		dq	3.14159265358

red			dd	0			; 0-255
green		dd	0			; 0-255
blue		dd	0			; 0-255

floatTmp1	dq 0.0		; used for intermediate
floatTmp2	dq 0.0		; used for

; ------------------------------------------------------------

section  .text

; -----
; Open GL routines.

extern	glutInit, glutInitDisplayMode, glutInitWindowSize, glutInitWindowPosition
extern	glutCreateWindow, glutMainLoop
extern	glutDisplayFunc, glutIdleFunc, glutReshapeFunc, glutKeyboardFunc
extern	glutSwapBuffers, gluPerspective, glutPostRedisplay
extern	glClearColor, glClearDepth, glDepthFunc, glEnable, glShadeModel
extern	glClear, glLoadIdentity, glMatrixMode, glViewport
extern	glTranslatef, glRotatef, glBegin, glEnd, glVertex3f, glColor3f
extern	glVertex2f, glVertex2i, glColor3ub, glOrtho, glFlush, glVertex2d

extern	cos, sin


; ******************************************************************
;  Function getParams()
;	Gets draw speed, draw color, and screen size
;	from the command line arguments.

;	Performs error checking, converts ASCII/septenary to integer.
;	Command line format (fixed order):
;	  "-sp <septNumber> -cl <septNumber> -sz <septyNumber>"
			; 0      1     2    3       4   5
;	ex: ./drawcirc -sp # -cl ######### -sz #
; -----
;  Arguments:
;	ARGC, double-word, value
;	ARGV, double-word, address
;	speed, double-word, address
;	color, double-word, address
;	size, double-word, address

; Returns:
;	speed, color, and size via reference (of all valid)
;	TRUE or FALSE

global getParams
getParams:
	; ARGC -> rdi, this is my count of paramets, there is always at least one
	; ARGV -> rsi, base address of pointer array
	; speed address -> rdx, not populated yet, but is 3rd arg
	; color address -> rcx, not populated yet, but is 5th arg
	; size address -> r8	not populated yet, is 7th arg

mov rax, errUsage
cmp rdi, 1
je fail

mov rax, errBadCL
cmp rdi, 7
jne fail

mov rdi, 1				; this will count argument pairs
chompInput:
	cmp rdi, 4			; if these are equal, then we are done, because there is no 4th pair of args.
	je dneChomp
	add rsi, 8
	mov r10, qword[rsi]
	; Start inline macro

	;%%chompSpec:
	cmp byte[r10], '-' 	; has to be present
	jne failBadSpec
	inc r10

	cmp byte[r10], 's'	; could be sp or sz
	je checkSpSz

	cmp rdi, 2			; if ~'s' & ~2nd pair -> fail b/c 1,3 start w/ s
	jne failBadSpec

	mov rax, errClrSpec		; assume not get the c
	cmp byte[r10], 'c'		;initiate color check
	jne fail
	inc r10

	cmp byte[r10], 'l'		; must get an l or fail
	jne fail

	jmp validate			; check for null termination, should be EOS

	checkSpSz:
		cmp rdi, 1			; if this is the 1st pair -> check for 'p' else 'z'
		jne checkZ

		;checkP:
		mov rax, errSpdSpec	; assume bad speed
		inc r10
		cmp byte[r10], 'p'	; is dere a 'p'
		jne fail

		jmp validate

		checkZ:
		cmp rdi, 3			; if this is not 3, we have permuted arguments
		jne failBadSpec

		mov rax, errSizSpec	; assume bad size
		inc r10
		cmp byte[r10], 'z'
		jne fail

		jmp validate

	failBadSpec:
		cmp rdi, 1	; we are supposed to handle -sp
		je failSP
		cmp rdi, 2   ; failing -cl
		je failCL

		;failSZ:
			mov rax, errSizSpec
			jmp fail

		failSP:
			mov rax, errSpdSpec
			jmp fail

		failCL:
			mov rax, errClrSpec
			jmp fail

	validate:
		inc r10
		cmp byte[r10], 0	; this should be a null if its not then its invalid
		jne failBadSpec

	add rsi, 8
	mov r10, qword[rsi]
	chompVal:
		cmp rdi, 1	; handling spd
		je chompSpd

		cmp rdi, 2   	; handling clr
		je chompClr

		;chompSiz
			push rdx
			push r8
			ASCIISept2Int r10, rdi
			pop r8
			pop rdx
			mov r11, rax
			mov rax, errSizValue
			cmp r11, SIZ_MAX
			jg fail
			cmp r11, SIZ_MIN
			jl fail
			mov dword[r8], r11d
			;mov dword[size], r11d

			inc rdi
			jmp chompInput

		chompSpd:
			push rdx
			push r8
			ASCIISept2Int r10, rdi
			pop r8
			pop rdx
			mov r11, rax
			mov rax, errSpdValue
			cmp r11, SPD_MAX
			jg fail
			cmp r11, SPD_MIN
			jl fail
			mov dword[rdx], r11d
			;mov dword[speed], r11d

			inc rdi
			jmp chompInput

		chompClr:
			push rdx
			push r8
			ASCIISept2Int r10, rdi
			pop r8
			pop rdx
			mov r11, rax
			mov rax, errClrValue
			cmp r11, CLR_MAX
			jg fail
			cmp r11, CLR_MIN
			jl fail
			mov dword[rcx], r11d
			;mov dword[color], r11d
			movzx r9, r11b
			mov dword[blue], r9d
			shr r11, 8
			movzx r9, r11b
			mov dword[green], r9d
			shr r11, 8
			movzx r9, r11b
			mov dword[red], r9d

			inc rdi
			jmp chompInput
; end inline macro
dneChomp:
	mov rax, TRUE
	ret


fail:
	mov rdi, rax
	call printString
	mov rax, FALSE

	ret


; ******************************************************************
;  Draw wheels function.
;	Plot the provided functions (see PDF).

; -----
;  Arguments:
;	none -> accesses global variables.
;	nothing -> is void

; -----
;  Gloabl variables Accessed:

common	speed		1:4			; draw speed, dword, integer value
common	color		1:4			; draw color, dword, integer value
common	size		1:4			; screen size, dword, integer value

global drawWheels
drawWheels:
	push	rbp

; do NOT push any additional registers.
; If needed, save regitser to quad variable...

; -----
; pre-Calc values of pi and store them
; 2pi, 4pi, 6pi, 2pi/3
movsd xmm0, qword[pi]
mulsd xmm0, qword[fltFourPi]; calc & store 4pi
movsd qword[fltFourPi], xmm0

movsd xmm0, qword[pi]
mulsd xmm0, qword[fltSixPi]; calc & store 6pi
movsd qword[fltSixPi], xmm0

movsd xmm0, qword[pi]
mulsd xmm0, qword[fltTwo]
movsd qword[fltTwoPi], xmm0	; stored 2pi

divsd xmm0, qword[fltThree]; calc & store 2pi/3
movsd qword[fltTwoPiOv3], xmm0

; -----
;  Set draw speed step
;	sStep = speed / scale

;	YOUR CODE GOES HERE
cvtsi2sd xmm0, dword[speed]
divsd xmm0, qword[scale]
movsd qword[sStep], xmm0

; -----
;  Prepare for drawing
	; glClear(GL_COLOR_BUFFER_BIT);
	mov	rdi, GL_COLOR_BUFFER_BIT
	call	glClear

	; glBegin();
	mov	rdi, GL_POINTS
	call	glBegin

; -----
;  Set draw color(r,g,b)
;	uses glColor3ub(r,g,b)

;	YOUR CODE GOES HERE
mov edi, dword[red]
mov esi, dword[green]
mov ecx, dword[blue]
call glColor3ub

; -----
;  main plot loop
;	iterate t from 0.0 to 2*pi by tStep
;	uses glVertex2d(x,y) for each formula


;	YOUR CODE GOES HERE

	movsd xmm0, qword[t]
drawingLoop:
	ucomisd xmm0, qword[fltTwoPi]
	ja end



calc1:
	movsd xmm0, qword[t]
	call cos
	movsd qword[x], xmm0
	movsd xmm0, qword[t]
	call sin
	movsd qword[y], xmm0

	movsd xmm0, qword[x]
	movsd xmm1, qword[y]
	call glVertex2d
	;end1:


calc2:
 	movsd xmm0, qword[x]
 	divsd xmm0, qword[fltThree] 	; cos/3, x and y are already calculated at this step
 	movsd qword[x], xmm0

 	movsd xmm0, qword[y]
 	divsd xmm0, qword[fltThree] 	; sin/3, x and y are already calculated at this step
 	movsd qword[y], xmm0

 	movsd xmm0, qword[s]
 	mulsd xmm0, qword[fltTwoPi]

 	movsd qword[flt2S2piSOv3], xmm0	; hold 2Pis
 	call cos
 	mulsd xmm0, qword[fltTwo]			; 2cos(pis)
 	divsd xmm0, qword[fltThree]		; /3
 	movsd qword[flt2C2piSOv3], xmm0	; stored 2cos(2pis)
 	movsd xmm1, qword[x]
 	addsd xmm0, xmm1				    ; x = cos(t)/3 + 2cos(2pis)/3
 	movsd qword[x], xmm0

 	movsd xmm0, qword[flt2S2piSOv3]	; restore 2piS
 	call sin
	mulsd xmm0, qword[fltTwo]			; 2sin(pis)
 	divsd xmm0, qword[fltThree]		; /3
 	movsd qword[flt2S2piSOv3], xmm0	; stored 2sin(2pis)
 	movsd xmm1, qword[y]
	addsd xmm0, xmm1				    ; y = sin(t)/3 + 2sin(2pis)/3
 	movsd qword[y], xmm0
 	;end2:


 	movsd xmm0, qword[x]
 	movsd xmm1, qword[y]
	call glVertex2d

calc3:
	movsd xmm0, qword[flt2C2piSOv3] 	; load 2cos(2pis)/3
 	movsd qword[x], xmm0
 	movsd xmm0, qword[flt2S2piSOv3] 	; load 2sin(2pis)/3
 	movsd qword[y], xmm0

 	movsd xmm0, qword[fltFourPi]
 	mulsd xmm0, qword[s]				; construct 4pis
 	movsd qword[floatTmp1], xmm0
 	call cos
 	mulsd xmm0, qword[t]
	divsd xmm0, qword[fltSixPi]			; tcos(4pis)/6pi
 	movsd xmm1, qword[x]
 	addsd  xmm0, xmm1				    ; 2cos(2pis) + ^
 	movsd qword[x], xmm0

 	movsd xmm0, qword[floatTmp1]		; restore 4pis
 	call sin
 	mulsd xmm0, qword[t]
 	divsd xmm0, qword[fltSixPi]			; tsin(4pis)/6pi
 	movsd xmm1, qword[y]
 	subsd  xmm1, xmm0				    ; 2sin(2pis) + ^
 	movsd qword[y], xmm1
 	;end3:

 	movsd xmm0, qword[x]
 	movsd xmm1, qword[y]
 	call glVertex2d

calc4:
 	movsd xmm0, qword[flt2C2piSOv3] 	; load 2cos(2pis)/3
 	movsd qword[x], xmm0
 	movsd xmm0, qword[flt2S2piSOv3] 	; load 2sin(2pis)/3
 	movsd qword[y], xmm0

 	movsd xmm0, qword[fltFourPi]
 	mulsd xmm0, qword[s]
 	addsd xmm0, qword[fltTwoPiOv3]		; 4pis+2pi/3

 	movsd qword[floatTmp1], xmm0
 	call cos
 	mulsd xmm0, qword[t]
 	divsd xmm0, qword[fltSixPi]			; tcos(4pis)/6pi
 	movsd xmm1, qword[x]
 	addsd  xmm1, xmm0				    ; 2cos(2pis) + ^
 	movsd qword[x], xmm1

 	movsd xmm0, qword[floatTmp1]		; restore 4pis + 2pi/3
 	call sin
 	mulsd xmm0, qword[t]
 	divsd xmm0, qword[fltSixPi]			; tsin(4pis)/6pi
 	movsd xmm1, qword[y]
 	subsd  xmm1, xmm0				    ; 2sin(2pis)/3 - ^
 	movsd qword[y], xmm1
 	;end4:

 	movsd xmm0, qword[x]
 	movsd xmm1, qword[y]
 	call glVertex2d
;
calc5:
 	movsd xmm0, qword[flt2C2piSOv3] 	; load 2cos(2pis)/3
 	movsd qword[x], xmm0
 	movsd xmm0, qword[flt2S2piSOv3] 	; load 2sin(2pis)/3
 	movsd qword[y], xmm0

 	movsd xmm0, qword[fltFourPi]
 	mulsd xmm0, qword[s]
 	subsd xmm0, qword[fltTwoPiOv3]		; 4pis-2pi/3

 	movsd qword[floatTmp1], xmm0
 	call cos
 	mulsd xmm0, qword[t]
 	divsd xmm0, qword[fltSixPi]			; tcos(4pis)/6pi
 	movsd xmm1, qword[x]
 	addsd xmm1, xmm0				    ; 2cos(2pis) + ^
 	movsd qword[x], xmm1
 	movsd xmm0, qword[floatTmp1]		; restore 4pis - 2pi/3
 	call sin
 	mulsd xmm0, qword[t]
 	divsd xmm0, qword[fltSixPi]			; tsin(4pis)/6pi
 	movsd xmm1, qword[y]
 	subsd xmm1, xmm0				    ; 2sin(2pis)/3 - ^
 	movsd qword[y], xmm1
 	;end5

 	movsd xmm0, qword[x]
 	movsd xmm1, qword[y]
 	call glVertex2d

	movsd xmm0, qword[t]
	addsd xmm0, qword[tStep]
	movsd qword[t], xmm0
	jmp drawingLoop
end:

; -----
;  Display image

	call	glEnd
	call	glFlush

; -----
;  Update s, s += sStep;
;  if (s > 1.0)
;	s = 0.0;

	movsd	xmm0, qword [s]			; s+= sStep
	addsd	xmm0, qword [sStep]
	movsd	qword [s], xmm0

	movsd	xmm0, qword [s]
	movsd	xmm1, qword [fltOne]
	ucomisd	xmm0, xmm1			; if (s > 1.0)
	jbe	resetDone

	movsd xmm0, qword [fltZero]
	movsd qword [sStep], xmm0
	movsd qword[t], xmm0

	movsd qword[fltTwoPi], xmm0	; reset
	movsd qword[fltTwoPiOv3], xmm0 ;reset
	movsd qword[flt2C2piSOv3], xmm0
	movsd qword[flt2S2piSOv3], xmm0

	movsd xmm0, qword[fltTwo]
	addsd xmm0, qword[fltTwo]
	movsd qword[fltFourPi], xmm0
	addsd xmm0, qword[fltTwo]
	movsd qword[fltSixPi], xmm0

resetDone:

	call	glutPostRedisplay

; -----
	pop	rbp
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
