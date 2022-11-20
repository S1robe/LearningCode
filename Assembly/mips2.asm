###########################################################################
#  Assignment: MIPS #2
#  Description: calculate the volume of each three dimensional hexagonal prism1 in a series of hexagonal prisms.


###########################################################
#  data segment

.data

apothems:	.word	  110,   114,   113,   137,   154
		.word	  131,   113,   120,   161,   136
		.word	  114,   153,   144,   119,   142
		.word	  127,   141,   153,   162,   110
		.word	  119,   128,   114,   110,   115
		.word	  115,   111,   122,   133,   170
		.word	  115,   123,   115,   163,   126
		.word	  124,   133,   110,   161,   115
		.word	  114,   134,   113,   171,   181
		.word	  138,   173,   129,   117,   193
		.word	  125,   124,   113,   117,   123
		.word	  134,   134,   156,   164,   142
		.word	  206,   212,   112,   131,   246
		.word	  150,   154,   178,   188,   192
		.word	  182,   195,   117,   112,   127
		.word	  117,   167,   179,   188,   194
		.word	  134,   152,   174,   186,   197
		.word	  104,   116,   112,   136,   153
		.word	  132,   151,   136,   187,   190
		.word	  120,   111,   123,   132,   145

bases:		.word	  233,   214,   273,   231,   215
		.word	  264,   273,   274,   223,   256
		.word	  157,   187,   199,   111,   123
		.word	  124,   125,   126,   175,   194
		.word	  149,   126,   162,   131,   127
		.word	  177,   199,   197,   175,   114
		.word	  244,   252,   231,   242,   256
		.word	  164,   141,   142,   173,   166
		.word	  104,   146,   123,   156,   163
		.word	  121,   118,   177,   143,   178
		.word	  112,   111,   110,   135,   110
		.word	  127,   144,   210,   172,   124
		.word	  125,   116,   162,   128,   192
		.word	  215,   224,   236,   275,   246
		.word	  213,   223,   253,   267,   235
		.word	  204,   229,   264,   267,   234
		.word	  216,   213,   264,   253,   265
		.word	  226,   212,   257,   267,   234
		.word	  217,   214,   217,   225,   253
		.word	  223,   273,   215,   206,   213

heights:	.word	  117,   114,   115,   172,   124
		.word	  125,   116,   162,   138,   192
		.word	  111,   183,   133,   130,   127
		.word	  111,   115,   158,   113,   115
		.word	  117,   126,   116,   117,   227
		.word	  177,   199,   177,   175,   114
		.word	  194,   124,   112,   143,   176
		.word	  134,   126,   132,   156,   163
		.word	  124,   119,   122,   183,   110
		.word	  191,   192,   129,   129,   122
		.word	  135,   226,   162,   137,   127
		.word	  127,   159,   177,   175,   144
		.word	  179,   153,   136,   140,   235
		.word	  112,   154,   128,   113,   132
		.word	  161,   192,   151,   213,   126
		.word	  169,   114,   122,   115,   131
		.word	  194,   124,   114,   143,   176
		.word	  134,   126,   122,   156,   163
		.word	  149,   144,   114,   134,   167
		.word	  143,   129,   161,   165,   136

hexVolumes:	.space	400

len:		.word	100

volMin:		.word	0
volEMid:	.word	0
volMax:		.word	0
volSum:		.word	0
volAve:		.word	0

LN_CNTR	= 4


# -----

hdr:	.ascii	"MIPS Assignment #2 \n"
	.ascii	"  Hexagonal Volumes Program:\n"
	.ascii	"  Also finds minimum, middle value, maximum, \n"
	.asciiz	"  sum, and average for the volumes.\n\n"

a1_st:	.asciiz	"\nHexagon Volumes Minimum = "
a2_st:	.asciiz	"\nHexagon Volumes Est Med  = "
a3_st:	.asciiz	"\nHexagon Volumes Maximum = "
a4_st:	.asciiz	"\nHexagon Volumes Sum     = "
a5_st:	.asciiz	"\nHexagon Volumes Average = "

newLn:	.asciiz	"\n"
blnks:	.asciiz	"  "

###########################################################
#  text/code segment

# --------------------
#  Compute volumes:
#  Then find middle, max, sum, and average for volumes.

.text
.globl main
.ent main
main:

# -----
#  Display header.

	la	$a0, hdr
	li	$v0, 4
	syscall				# print header

# -------------------------------------------------------


#	YOUR CODE GOES HERE

li $t1, 0         # index for array access

li $t3, 3
la $t0, apothems  # address to be offsetd
lw $t8, ($t0)
mul $t3, $t3, $t8      # give me apothem
la $t0,  bases
lw $t8, ($t0)
mul $t3, $t3, $t8
la $t0, heights
lw $t8, ($t0)
mul $t3, $t3, $t8

la $t0, hexVolumes

sw $t3, ($t0)

move $t2, $t3     # t2 is sum
move $t6, $t3     # t6 is min
move $t7, $t3     # t7 is max



add $t1, $t1, 4
div $t4, $t1, 4
lw $t5, len
beq $t4, $t5, end

volumeLoop:
  li $t3, 3

  la $t0, apothems  # address to be offsetd
  add $t0, $t0, $t1 # apply offset
  lw $t8, ($t0)
  mul $t3, $t3, $t8      # give me apothem

  la $t0,  bases
  add $t0, $t0, $t1 # apply offset
  lw $t8, ($t0)
  mul $t3, $t3, $t8

  la $t0, heights
  add $t0, $t0, $t1 # apply offset
  lw $t8, ($t0)
  mul $t3, $t3, $t8
  
  la $t0, hexVolumes
  add $t0, $t0, $t1 # apply offset
  sw $t3, ($t0)

  add $t2, $t2, $t3 # add to sum

  bgt $t3, $t6, checkMax
  move $t6, $t3
  j advance

  checkMax:
  blt $t3, $t7, advance 
  move $t7, $t3

  advance:
  add $t1, $t1, 4   # next number
  div $t4, $t1, 4   # get current index
  bne $t4, $t5, volumeLoop

end:

sw $t6, volMin
sw $t7, volMax
sw $t2, volSum
lw $t0, len
div $t2, $t2, $t0
sw $t2, volAve

#need counter for # of # total
#need counter for # of numbers per line
la $s2, hexVolumes

lw $t1, ($s2)

sub $t0, $t0, 1
mul $t0, $t0, 4
add $s2, $s2, $t0 # add offset for last number
lw $t2, ($s2)
add $t1, $t1, $t2 # add last 

lw $t0, len
div $t0, $t0, 2   # cut offset in half for middle high
mul $t0, $t0, 4   # conver to offset

la $s2, hexVolumes
add $s2, $s2, $t0 # apply offset
lw $t2, ($s2)
add $t1, $t1, $t2 # middle high

sub $s2, $s2, 4
lw $t2, ($s2)
add $t1, $t1, $t2 # add middle low

div $t1, $t1, 4

sw $t1, volEMid

la $s2, hexVolumes
move $s1, $0
lw $s3, len
li $s4, LN_CNTR
printLoop:

  move $s0, $0      # num per line
  printLine:
    la $a0, blnks
    li $v0, 4
    syscall # print blanks

    lw $a0, ($s2) # give me value
    li $v0, 1
    syscall   # PRINT!!!!!!!!!!!

    add $s2, $s2, 4
    add $s1, $s1, 1   # increase counter for printed number
    add $s0, $s0, 1   # increase counter for number on this line !

    beq $s1, $s3, out

    bne $s0, $s4, printLine

    la $a0, newLn
    li $v0, 4
    syscall

  bne $s1, $s3, printLoop
out:

##########################################################
#  Display results.

	la	$a0, newLn		# print a newline
	li	$v0, 4
	syscall

#  Print min message followed by result.

	la	$a0, a1_st
	li	$v0, 4
	syscall				# print "min = "

	lw	$a0, volMin
	li	$v0, 1
	syscall				# print min

# -----
#  Print middle message followed by result.

	la	$a0, a2_st
	li	$v0, 4
	syscall				# print "med = "

	lw	$a0, volEMid
	li	$v0, 1
	syscall				# print mid

# -----
#  Print max message followed by result.

	la	$a0, a3_st
	li	$v0, 4
	syscall				# print "max = "

	lw	$a0, volMax
	li	$v0, 1
	syscall				# print max

# -----
#  Print sum message followed by result.

	la	$a0, a4_st
	li	$v0, 4
	syscall				# print "sum = "

	lw	$a0, volSum
	li	$v0, 1
	syscall				# print sum

# -----
#  Print average message followed by result.

	la	$a0, a5_st
	li	$v0, 4
	syscall				# print "ave = "

	lw	$a0, volAve
	li	$v0, 1
	syscall				# print average

# -----
#  Done, terminate program.

endit:
	la	$a0, newLn		# print a newline
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall				# all done!

.end main

