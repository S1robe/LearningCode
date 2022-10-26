;  CS 218 - Assignment #11
;  Functions Template

; ***********************************************************************
;  Data declarations
;	Note, the error message strings should NOT be changed.
;	All other variables may changed or ignored...
;
; ------------------
; provide the address to file path name you wish to find a .bmp extension,
; if the string has it, after this macro returns, rdi will contain a 3 if the stirng provided ended with .bmp
%macro findDotBMP 1
findDotBMP:

	verifyEnd:
	cmp byte[%1], NULL
	je end

	mov rdi, 0
	cmp byte[%1], '.' 	;first in the sequence
	je checkB
	jmp cont

	checkB:
	inc %1				; move along
	inc rdi
	cmp byte[%1], 'b'	; next must be a b
	je checkM
	jmp cont

	checkM:
	inc %1				; move along
	inc rdi
	cmp byte[%1], 'm'	; next must be an m
	je checkP
	jmp cont

	checkP:
	inc %1
	inc rdi				; next must be p
	cmp byte[%1], 'p'
	je verifyEnd		; then we must end with a null otherwise we will reset because the file name didnt end with null so this isnt the file.

	cont:
	mov rdi, 0
	inc %1
	jmp findDotBMP
end:
%endmacro



section	.data

; -----
;  Define standard constants.

LF		equ	10			; line feed
NULL		equ	0			; end of string
SPACE		equ	0x20			; space

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1			; Unsuccessful operation

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

O_CREAT		equ	0x40
O_TRUNC		equ	0x200
O_APPEND	equ	0x400

O_RDONLY	equ	000000q			; file permission - read only
O_WRONLY	equ	000001q			; file permission - write only
O_RDWR		equ	000002q			; file permission - read and write

S_IRUSR		equ	00400q
S_IWUSR		equ	00200q
S_IXUSR		equ	00100q

; -----
;  Define program specific constants.

MIN_FILE_LEN	equ	5

; buffer size (part A) - DO NOT CHANGE THE NEXT LINE.
BUFF_SIZE	equ	750000

; -----
;  Variables for getImageFileName() function.

eof		db	FALSE

usageMsg	db	"Usage: ./makeThumb <inputFile.bmp> "
		db	"<outputFile.bmp>", LF, NULL
errIncomplete	db	"Error, incomplete command line arguments.", LF, NULL
errExtra	db	"Error, too many command line arguments.", LF, NULL
errReadName	db	"Error, invalid source file name.  Must be '.bmp' file.", LF, NULL
errWriteName	db	"Error, invalid output file name.  Must be '.bmp' file.", LF, NULL
errReadFile	db	"Error, unable to open input file.", LF, NULL
errWriteFile	db	"Error, unable to open output file.", LF, NULL

; -----
;  Variables for setImageInfo() function.

HEADER_SIZE	equ	138

errReadHdr	db	"Error, unable to read header from source image file."
		db	LF, NULL
errFileType	db	"Error, invalid file signature.", LF, NULL
errDepth	db	"Error, unsupported color depth.  Must be 24-bit color."
		db	LF, NULL
errCompType	db	"Error, only non-compressed images are supported."
		db	LF, NULL
errSize		db	"Error, bitmap block size inconsistent.", LF, NULL
errWriteHdr	db	"Error, unable to write header to output image file.", LF,
		db	"Program terminated.", LF, NULL

; -----
;  Variables for readRow() function.

buffMax		dq	BUFF_SIZE
curr		dq	BUFF_SIZE
wasEOF		db	FALSE
pixelCount	dq	0

errRead		db	"Error, reading from source image file.", LF,
		db	"Program terminated.", LF, NULL

; -----
;  Variables for writeRow() function.

errWrite	db	"Error, writting to output image file.", LF,
		db	"Program terminated.", LF, NULL

; ------------------------------------------------------------------------
;  Unitialized data

section	.bss

buffer		resb	BUFF_SIZE
header		resb	HEADER_SIZE

; ############################################################################

section	.text

; ***************************************************************
;  Routine to get image file names (from command line)
;	Verify files by atemptting to open the files (to make
;	sure they are valid and available).

;  Command Line format:
;	./makeThumb <inputFileName> <outputFileName>

; -----
;  Arguments:
;	- argc (value)						rdi
;	- argv table (address)				rsi
;	- read file descriptor (address)	rdx
;	- write file descriptor (address)   rcx
;  Returns:
;	read file descriptor (via reference)
;	write file descriptor (via reference)
;	TRUE or FALSE


;	YOUR CODE GOES HERE
global getImageFileName
getImageFileName:

mov r8, errExtra
cmp rdi, 3
jge fail

mov r8, errUsage
cmp rdi, 1
je fail

mov r8, errIncomplete
cmp rdi, 2
je fail

add rsi, 8		; skip the ./stuff

push rsi					; hold my argV
mov rsi, qword[rsi]			; give me the first string address
mov rdi, 0					; zero for counter
mov r8, errWriteName		; assume bad
findDotBMP rsi				; validating first file name
cmp rdi, 3
jne fail					; if this is not 3 (valid), fail :D

mov rsi, qword[rsp]				; give me argV
mov rsi, qword[rsi]				; give me back the address of the string

mov r8, errReadFile			; assume cant read
mov rax, SYS_open			; opening file
mov rdi, rsi				; put string in rdi
mov rsi, S_IRUSR			; open the file with read permissions
syscall
cmp rax, 0					; do fail things because negative
jl fail
mov qword[rdx], rax			; move file descriptor representation into provided address

pop rsi						; give me back ArgV
add rsi, 8					; advance to second arg

mov rsi, qword[rsi]			; dont need my file names anymore i have file refs
push rsi					; store 2nd file name
mov rdi, 0
mov r8, errReadName
findDotBMP rsi				; Check the second arguement
cmp rdi, 3
jne fail

pop rsi						; restore 2nd String name
mov r8, errWriteFile
mov rax, SYS_creat			; attempt create/open 2nd file
mov rdi, rsi
mov rsi, S_IWUSR
syscall
cmp rax, 0					; do fail things because negative
jl fail
mov qword[rcx], rax	; move file descriptor representation into provided address

; done here !
mov rax, TRUE
ret


fail:
	;do fail things
	mov rdi, r8
	call printString
	mov rax, FALSE
ret



; ***************************************************************
;  Read, verify, and set header information

;  HLL Call:
;	bool = setImageInfo(readFileDesc, writeFileDesc,
;		&picWidth, &picHeight, thumbWidth, thumbHeight)

;  If correct, also modifies header information and writes modified
;  header information to output file (i.e., thumbnail file).

; -----
;  2 -> BM				(+0)
;  4 file size				(+2)
;  4 skip				(+6)
;  4 header size			(+10)
;  4 skip				(+14)
;  4 width				(+18)
;  4 height				(+22)
;  2 skip				(+26)
;  2 depth (16/24/32)			(+28)
;  4 compression method code		(+30)
;  4 bytes of pixel data		(+34)
;  skip remaing header entries

; -----
;   Arguments:
;	- read file descriptor (value)	rdi
;	- write file descriptor (value) rsi
;	- old image width (address)		rdx
;	- old image height (address)	rcx
;	- new image width (value)		r8
;	- new image height (value)		r9

;  Returns:
;	file size (via reference)
;	old image width (via reference)
;	old image height (via reference)
;	TRUE or FALSE


;	YOUR CODE GOES HERE
global setImageInfo
setImageInfo:
push rdi	; hold address of my read file descriptor
cmp byte[rdi], 'B'
jne fail
inc rdi
cmp byte[rdi], 'M'
jne fail

inc rdi		; align to look at the next 4 bytes
; first 2 bytes good
mov r10d, dword[rdi]	; gimme next 4 bytes for file size

;handle file size  checks

add rdi, 8				; skip the 4 bytes i just read and the reserved 4 bytes I cant read

mov r10d, dword[rdi]	; gimme header size, should be 54 meaning 54 bytes

;handle header size

add rdi, 4				; skip the 4 bytes i just read
add r11d, dword[rdi]	; get offset of the image data start
add rdi, 4				; move to image width

mov eax, dword[rdi]		; get image width
mov dword[rdx], eax		; store old image width
add rdi, 4				; move to image height

mov r10d, dword[rdi]	; get image height
mov dword[rcx], r10d	; store old image height
mul r10d				; W * H


ret



; ***************************************************************
;  Return a row from read buffer
;	This routine performs all buffer management

; ----
;  HLL Call:
;	bool = readRow(readFileDesc, picWidth, rowBuffer[]);

;   Arguments:
;	- read file descriptor (value)
;	- image width (value)
;	- row buffer (address)
;  Returns:
;	TRUE or FALSE

; -----
;  This routine returns TRUE when row has been returned
;	and returns FALSE if there is no more data to
;	return (i.e., all data has been read) or if there
;	is an error on read (which would not normally occur).

;  The read buffer itself and some misc. variables are used
;  ONLY by this routine and as such are not passed.


;	YOUR CODE GOES HERE



; ***************************************************************
;  Write image row to output file.
;	Writes exactly (width*3) bytes to file.
;	No requirement to buffer here.

; -----
;  HLL Call:
;	bool = writeRow(writeFileDesc, picWidth, rowBuffer);

;  Arguments are:
;	- write file descriptor (value)
;	- image width (value)
;	- row buffer (address)

;  Returns:
;	N/A

; -----
;  This routine returns TRUE when row has been written
;	and returns FALSE only if there is an
;	error on write (which would not normally occur).

;  The read buffer itself and some misc. variables are used
;  ONLY by this routine and as such are not passed.


;	YOUR CODE GOES HERE



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

