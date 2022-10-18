; *****************************************************************
;  Section: 2
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
;
; Converts the number in %1 from sept to int into %2, does the checking for sept validity
; %3 is a number representing what specifier we are handling, 1,sp; 2,clr; 3,sz
; simple since the numbers were given do not have the leading sign,
; spd : 1-50
; clr = 0-0xFF FF FF
; size = 100-2000
%macro ASCIISept2Int 3
mov rax, 0
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
	cmp %3, 1;
	je %%failValueSpd
	cmp %3, 2 ;clr
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
	mov %2, eax	; result is in rax
%endmacro

; Calc x1,y1
%macro calcX1Y1 0
	movsd xmm0, qword[t]
	call cos
	movsd qword[x], xmm0
	movsd xmm0, qword[t]
	call sin
	movsd qword[y], xmm0
%endMacro

; Calc x2,y2
%macro calcX2Y2 0
	movssd xmm2, qword[fltTwo]	;store 2
	movssd xmm3, qword[fltThree]  ;store 3

	movssd xmm0, qword[x]
	divssd xmm0, xmm3 	; cos/3, x and y are already calculated at this step
	movssd qword[x], xmm0

	movssd xmm0, qword[y]
	divssd xmm0, xmm3 	; sin/3, x and y are already calculated at this step
	movssd qword[y], xmm0

	movssd xmm0, qword[s]
	mulssd xmm0, qword[fltTwo]
	mulssd xmm0, qword[pi]

	movssd qword[flt2S2piSOv3], xmm0	; hold 2Pis
	call cos
	mulssd xmm0, qword[fltTwo]			; 2cos(pis)
	divssd xmm0, qword[fltThree]		; /3
	movssd qword[flt2C2piSOv3], xmm0	; stored 2cos(2pis)
	movssd xmm1, qword[x]
	addsd  xmm0, xmm1				    ; x = cos(t)/3 + 2cos(2pis)/3
	movssd qword[x], xmm0

	movssd xmm0, qword[flt2S2piSOv3]	; restore 2piS
	call sin
	mulssd xmm0, qword[fltTwo]			; 2sin(pis)
	divssd xmm0, qword[fltThree]		; /3
	movssd qword[flt2S2piSOv3], xmm0	; stored 2sin(2pis)
	movssd xmm1, qword[y]
	addsd  xmm0, xmm1				    ; y = sin(t)/3 + 2sin(2pis)/3
	movssd qword[y], xmm0
%endMacro

; Calc x3,y3
%macro calcX3Y3 0
	movssd xmm0, qword[flt2C2piSOv3] 	; load 2cos(2pis)/3
	movssd qword[x], xmm0
	movssd xmm0, qword[flt2S2piSOv3] 	; load 2sin(2pis)/3
	movssd qword[y], xmm0

	movssd xmm0, qword[fltFourPiS]
	mulssd xmm0, qword[s]				; construct 4pis
	movssd xmm1, xmm0
	call cos
	mulssd xmm0, qword[t]
	divsd xmm0, qword[fltSixPi]			; tcos(4pis)/6pi
	movssd xmm1, qword[x]
	addsd  xmm0, xmm1				    ; 2cos(2pis) + ^
	movssd qword[x], xmm0

	movssd xmm0, xmm1					; restore 4pis
	call sin
	mulssd xmm0, qword[t]
	divsd xmm0, qword[fltSixPi]			; tsin(4pis)/6pi
	movssd xmm1, qword[y]
	subsd  xmm1, xmm0				    ; 2sin(2pis) + ^
	movssd qword[y], xmm1
%endMacro

; Calc x4,x4
%macro calcX4Y4 0
	movssd xmm0, qword[flt2C2piSOv3] 	; load 2cos(2pis)/3
	movssd qword[x], xmm0
	movssd xmm0, qword[flt2S2piSOv3] 	; load 2sin(2pis)/3
	movssd qword[y], xmm0

	movssd xmm0, qword[fltFourPiS]
	addsd xmm0, qword[fltTwoPiOv3]		; 4pis+2pi/3

	movssd xmm1, xmm0
	call cos
	mulssd xmm0, qword[t]
	divsd xmm0, qword[fltSixPi]			; tcos(4pis)/6pi
	movssd xmm2, qword[x]
	addsd  xmm2, xmm0				    ; 2cos(2pis) + ^
	movssd qword[x], xmm2

	movssd xmm0, xmm1					; restore 4pis + 2pi/3
	call sin
	mulssd xmm0, qword[t]
	divsd xmm0, qword[fltSixPi]			; tsin(4pis)/6pi
	movssd xmm2, qword[y]
	subsd  xmm2, xmm0				    ; 2sin(2pis)/3 - ^
	movssd qword[y], xmm2
%endMacro

; Calc x5,y5
%macro calcX5Y5 0
	movssd xmm0, qword[flt2C2piSOv3] 	; load 2cos(2pis)/3
	movssd qword[x], xmm0
	movssd xmm0, qword[flt2S2piSOv3] 	; load 2sin(2pis)/3
	movssd qword[y], xmm0

	movssd xmm0, qword[fltFourPiS]
	subsd xmm0, qword[fltTwoPiOv3]		; 4pis-2pi/3

	movssd xmm1, xmm0
	call cos
	mulssd xmm0, qword[t]
	divsd xmm0, qword[fltSixPi]			; tcos(4pis)/6pi
	movssd xmm2, qword[x]
	addsd  xmm2, xmm0				    ; 2cos(2pis) + ^
	movssd qword[x], xmm2

	movssd xmm0, xmm1					; restore 4pis - 2pi/3
	call sin
	mulssd xmm0, qword[t]
	divsd xmm0, qword[fltSixPi]			; tsin(4pis)/6pi
	movssd xmm2, qword[y]
	subsd  xmm2, xmm0				    ; 2sin(2pis)/3 - ^
	movssd qword[y], xmm2
%endMacro


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


fltTwoPiOv3 dq	0.0		;used to be for 2pis
fltFourPiS	dq	4.0		; used to be fltFour
fltSixPi	dq	6.0		; used to be fltSix

flt2C2piSOv3 dq 0.0		; used to be tmp1
flt2S2piSOv3 dq 0.0		; used to be tmp2

pi		dq	3.14159265358

red			dd	0			; 0-255
green		dd	0			; 0-255
blue		dd	0			; 0-255


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
	; speed address -> rcx, not populated yet, but is 3rd arg
	; color address -> rdx, not populated yet, but is 5th arg
	; size address -> r8	not populated yet, is 7th arg

mov rax, errUsage
cmp rdi, 1
je fail

mov rax, errBadCL
cmp rdi, 7
jne fail
	
lea r9, [rsi + (rdi)*8]	; give r9 the final address so we can use rsi as a an index
add rsi, 8				; skip first address, its the name of the program, unecessary 
mov rdi, 1				; this will count argument pairs
chompInput:
	cmp rsi, r9			; if these are equal, then we are done because r9 is outside the arg array
	je dneChomp
	mov r10, rsi
	add r10, 8
	push r9
	; Start inline macro

	;%%chompSpec:
	cmp byte[rsi], '-' 	; has to be present
	jne failNoTac
	inc rsi

	cmp byte[rsi], 's'	; could be sp or sz
	je checkSpSz

	cmp byte[rsi], 'c'
	jne fail
	inc rsi

	cmp byte[rsi], 'l'
	jne fail

	; valid -cl
	mov rax, errClrSpec
	cmp rdi, 2
	jne fail		; -cl is in the wrong place
	jmp validate

	checkSpSz:
		inc rsi
		cmp byte[rsi], 'p'
		jne checkZ

		; valid -sp
		mov rax, errSpdSpec
		cmp rdi, 1
		jne fail		; -sp is in the wrong place
		jmp validate

		checkZ:
		cmp byte[rsi], 'z'
		jne fail

		; valid -sz
		mov rax, errSizSpec
		cmp rdi, 3
		jne fail		; -sz is in the wrong place
		jmp validate

	failNoTac:
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
		inc rsi
		cmp byte[rsi], 0	; this should be a null if its not then its invalid
		jne failNoTac

	chompVal:
		cmp rdi, 1	; handling spd
		je chompSpd

		cmp rdi, 2   	; handling clr
		je chompClr

		;chompSiz
			mov rax, errSizValue
			ASCIISept2Int r10, r11d, rdi
			cmp r11d, SIZ_MAX
			jg fail
			cmp r11d, SIZ_MIN
			jl fail
			pop r9
			mov dword[size], r11d
			jmp chompInput

		chompSpd:
			ASCIISept2Int r10, r11d, rdi
			cmp r11d, SPD_MAX
			jg fail
			cmp r11d, SPD_MIN
			jl fail
			pop r9
			mov dword[speed], r11d
			jmp chompInput

		chompClr:
			ASCIISept2Int r10, r11d, rdi
			cmp r11d, CLR_MAX
			jg fail
			cmp r11d, CLR_MIN
			jl fail
			pop r9
			mov dword[color], r11d
			jmp chompInput
; end inline macro
dneChomp:
	
	
	
	
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
mulssd qword[fltFourPiS], xmm0 ; calc & store 4pi
mulssd qword[fltSixPiS], xmm0 ; calc & store 6pi
mulssd xmm0, qword[fltTwo]
divssd xmm0, qword[fltThree]; calc & store 2pi/3
movssd qword[fltTwoPiOv3], xmm0
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



; -----
;  main plot loop
;	iterate t from 0.0 to 2*pi by tStep
;	uses glVertex2d(x,y) for each formula


;	YOUR CODE GOES HERE

drawingLoop:

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

	movsd	xmm0, qword [fltZero]
	movsd	qword [sStep], xmm0
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

