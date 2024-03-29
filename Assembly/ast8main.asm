;  CS 218 - Assignment 8
; --------------------------------------------------------------------
;  Assembly language functions.

;  The function, shellSort(), sorts the numbers into descending
;  order (large to small).  Uses the shell sort algorithm (from asst #7).

;  The function, basicStats(), finds the minimum, median, maximum,
;  sum, and average for a list of numbers.  Note, for an odd number of items,
;  the median value is defined as the middle value.  For an even number of
;  values, it is the integer average of the two middle values.
;  This function must call the lstSum() and lstAvergae() functions to
;  get the corresponding values.

;  The function, linearRegression(), computes the linear
;  regression for the two data sets based on the provided formulas.
;  Summation and division performed as integer values.
;  Due to the data sizes, the summation for the dividend (top)
;  must be performed as a quad-word.

; ----------

section	.data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation

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

LF		equ	10
NULL		equ	0
ESC		equ	27

; -----
;  Data Sets for Assignment #8.

xList_1		dd	  1630,   3510,   2110,  -7410,   4660
		dd	 -1310,   4780,   1250,   5370,   2220
		dd	  2890,   3440,  -3120
yList_1		dd	412130, 531110, 613213, -92140, 741160
		dd	431190, 542118, 731150, 631170, 951120
		dd	-12110, 831100, 921200
len_1		dd	13
xMin_1		dd	0
xMed_1		dd	0
xMax_1		dd	0
xSum_1		dd	0
xAve_1		dd	0
yMin_1		dd	0
yMed_1		dd	0
yMax_1		dd	0
ySum_1		dd	0
yAve_1		dd	0
b0_1		dd	0
b1_1		dd	0


xList_2		dd	 12327,  10255,   5417,  12315,   1361
		dd	  1000,   1220,   1122,   3124,   9026
		dd	  1129,  12213,  -3455,   1535,   5437
		dd	  -739,  10341,   1543,   1345,  10349
		dd	  2153,   2319, -12123,  13217,   1459
		dd	 11416,    415,   1551,   6567, -10669
		dd	 -1328,  13430,  13432,   2333,      1
		dd	   338,   4340,  -4542,   7644,   6746
		dd	  1321,   3425,  14251,  14113,  14519
		dd	  4257,  14999,   1453,    165,   5679
yList_2		dd	112327, 510255, 315417, 612315, 511361
		dd	211683, 343114, 755111, -44128,  -3112
		dd	311326, -22117, -77127, 749127, 855184
		dd	-13974, 342102, 934125, -26126, 751129
		dd	121188, 242315, 313101, -15108,  -3115
		dd	-11126, 239117, 641105, 899110, 765114
		dd	545124, 642143, -36134, 976112, 646103
		dd	631572, -46176, 755456,  -4165, 535156
		dd	764453, 733140, 855191, 454168, -33162
		dd	561646, 832147, -27167, 679177, 645144
len_2		dd	50
xMin_2		dd	0
xMed_2		dd	0
xMax_2		dd	0
xSum_2		dd	0
xAve_2		dd	0
yMin_2		dd	0
yMed_2		dd	0
yMax_2		dd	0
ySum_2		dd	0
yAve_2		dd	0
b0_2		dd	0
b1_2		dd	0


xList_3		dd	  9244,   4434,   7243,   9261,   5436
		dd	  4441,  -2233,  -6234,   6223,  -6263
		dd	  1218,   7443,   8612,   1210,   5310
		dd	 -4224,   2243,   6234,   6212,  -6203
		dd	  7253,  -3340,  -5291,   5468,   3362
		dd	  1347,    227,   4399,   1297,  -1229
		dd	  1383,   3450,   5201,   5228,   3315
		dd	  1683,   3114,  -5111,   4128,   3112
		dd	 -1326,   2117,   7127,   9127,   5184
		dd	  3974,    102,   4125,   6126,  -1129
		dd	  1188,  -3105,    101,   5108,   3115
		dd	  1126,   9117,  -1105,   9110,    114
		dd	   124,   2143,   6134,   6112,   6103
		dd	  1572,   6176,    156,   4165,  -5156
		dd	 -1453,  -3140,  -5191,   4168,   3162
		dd	  1646,   2147,   7167,   9177,  -5144
		dd	  1855,   5132,   7185,   2149,    134
		dd	  1764,    172,  -4175,   6162,   8172
		dd	 -1683,    150,   5131,   5178,  -7185
		dd	  1466,  -2167,   7177,   9177,   5164
yList_3		dd	 11000,   1220,   1122,   3124, 999026
		dd	121129,  12213,  -3455, 311535,   5437
		dd	  -739,  10341,  11543,  10345,  10349
		dd	212153,   2319, -12123,  13217,  13459
		dd	311416,    415,  10551, 426567, -10669
		dd	 -1328,  13430, 213432,   2333,      1
		dd	   338, 314340,  -4542,   7644,   6746
		dd	311321,   3425,  14251,  14113,  14519
		dd	  4257,  14999, 311453,  42165,   5679
		dd	542327, 210255,  15417,  12315,  11361
		dd	341683,   3114,   5111,  -4128,  -3112
		dd	 -1326,  -2117,  -7127,  49127, 315184
		dd	534188,   3105,    101,  -5108,  -3115
		dd	 -1126,   9117,   1105, 119110,    114
		dd	857124,   2143,  -6134,   6112,   6103
		dd	  1572,  -6176,    156,  -4165, 315156
		dd	851453,  13140,   5191,   4168,  -3162
		dd	 71646, 312147,  -7167, 119177,   5144
		dd	 -1855,  -5132,   7185,    149,    134
		dd	521764,   1172,   4175,   6162,  -8172
len_3		dd	100
xMin_3		dd	0
xMed_3		dd	0
xMax_3		dd	0
xSum_3		dd	0
xAve_3		dd	0
yMin_3		dd	0
yMed_3		dd	0
yMax_3		dd	0
ySum_3		dd	0
yAve_3		dd	0
b0_3		dd	0
b1_3		dd	0


; --------------------------------------------------------

extern	shellSort, basicStats, linearRegression

section	.text
global	_start
_start:

; **************************************************
;  Call functions for data set 1.

;  call shellSort(xList_1, len_1)
	mov	rdi, xList_1
	mov	esi, dword [len_1]
	call	shellSort

;  call shellSort(yList_1, len_1)
	mov	rdi, yList_1
	mov	esi, dword [len_1]
	call	shellSort

;  call basicStats(xList_1, len_1, xMin_1, xMed_1, xMax_1, xSum_1, xAve_1)
	mov	rdi, xList_1
	mov	esi, dword [len_1]
	mov	rdx, xMin_1
	mov	rcx, xMed_1
	mov	r8, xMax_1
	mov	r9, xSum_1
	mov	rax, xAve_1
	push	rax
	call	basicStats
	add	rsp, 8

;  call basicStats(yList_1, len_1, yMin_1, yMed_1, yMax_1, ySum_1, yAve_1)
	mov	rdi, yList_1
	mov	esi, dword [len_1]
	mov	rdx, yMin_1
	mov	rcx, yMed_1
	mov	r8, yMax_1
	mov	r9, ySum_1
	mov	rax, yAve_1
	push	rax
	call	basicStats
	add	rsp, 8

;  linearRegression(xList_1, yList_1, len_1, xAve_1, yAve_1, b0_1, b1_1)
	mov	rdi, xList_1
	mov	rsi, yList_1
	mov	edx, dword [len_1]
	mov	ecx, dword [xAve_1]
	mov	r8d, dword [yAve_1]
	mov	r9, b0_1
	mov	rax, b1_1
	push	rax
	call	linearRegression
	add	rsp, 8

; **************************************************
;  Call functions for data set 2.

;  call shellSort(xList_2, len_2)
	mov	rdi, xList_2
	mov	esi, dword [len_2]
	call	shellSort

;  call shellSort(yList_2, len_2)
	mov	rdi, yList_2
	mov	esi, dword [len_2]
	call	shellSort

;  call basicStats(xList_2, len_2, xMin_2, xMed_2, xMax_2, xSum_2, xAve_2)
	mov	rdi, xList_2
	mov	esi, dword [len_2]
	mov	rdx, xMin_2
	mov	rcx, xMed_2
	mov	r8, xMax_2
	mov	r9, xSum_2
	mov	rax, xAve_2
	push	rax
	call	basicStats
	add	rsp, 8

;  call basicStats(yList_2, len_2, yMin_2, yMed_2, yMax_2, ySum_2, yAve_2)
	mov	rdi, yList_2
	mov	esi, dword [len_2]
	mov	rdx, yMin_2
	mov	rcx, yMed_2
	mov	r8, yMax_2
	mov	r9, ySum_2
	mov	rax, yAve_2
	push	rax
	call	basicStats
	add	rsp, 8

;  linearRegression(xList_2, yList_2, len_2, xAve_2, yAve_2, b0_2, b1_2)
	mov	rdi, xList_2
	mov	rsi, yList_2
	mov	edx, dword [len_2]
	mov	ecx, dword [xAve_2]
	mov	r8d, dword [yAve_2]
	mov	r9, b0_2
	mov	rax, b1_2
	push	rax
	call	linearRegression
	add	rsp, 8

; **************************************************
;  Call functions for data set 3.

;  call shellSort(xList_3, len_3)
	mov	rdi, xList_3
	mov	esi, dword [len_3]
	call	shellSort
	add	rsp, 16

;  call shellSort(yList_3, len_3)
	mov	rdi, yList_3
	mov	esi, dword [len_3]
	call	shellSort

;  call basicStats(xList_3, len_3, xMin_3, xMed_3, xMax_3, xSum_3, xAve_3)
	mov	rdi, xList_3
	mov	esi, dword [len_3]
	mov	rdx, xMin_3
	mov	rcx, xMed_3
	mov	r8, xMax_3
	mov	r9, xSum_3
	mov	rax, xAve_3
	push	rax
	call	basicStats
	add	rsp, 8

;  call basicStats(yList_3, len_3, yMin_3, yMed_3, yMax_3, ySum_3, yAve_3)
	mov	rdi, yList_3
	mov	esi, dword [len_3]
	mov	rdx, yMin_3
	mov	rcx, yMed_3
	mov	r8, yMax_3
	mov	r9, ySum_3
	mov	rax, yAve_3
	push	rax
	call	basicStats
	add	rsp, 8

;  linearRegression(xList_3, yList_3, len_3, xAve_3, yAve_3, b0_3, b1_3)
	mov	rdi, xList_3
	mov	rsi, yList_3
	mov	edx, dword [len_3]
	mov	ecx, dword [xAve_3]
	mov	r8d, dword [yAve_3]
	mov	r9, b0_3
	mov	rax, b1_3
	push	rax
	call	linearRegression
	add	rsp, 8

; ******************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall

