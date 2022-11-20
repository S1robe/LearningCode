###########################################################################
#  Section: 2
#  Assignment: MIPS #1
#  Description: Program to calculate area of each hexagon in a series of hexagons. Also finds min, est mid, max, sum, and average for the hexagon areas.

################################################################################
#  data segment

.data

sideLens:
	.word	  15,   25,   33,   44,   58,   69,   72,   86,   99,  101
	.word	 369,  374,  377,  379,  382,  384,  386,  388,  392,  393
	.word	 501,  513,  524,  536,  540,  556,  575,  587,  590,  596
	.word	 634,  652,  674,  686,  697,  704,  716,  720,  736,  753
	.word	 107,  121,  137,  141,  157,  167,  177,  181,  191,  199
	.word	 102,  113,  122,  139,  144,  151,  161,  178,  186,  197
	.word	   1,    2,    3,    4,    5,    6,    7,    8,    9,   10
	.word	 202,  209,  215,  219,  223,  225,  231,  242,  244,  249
	.word	 203,  215,  221,  239,  248,  259,  262,  274,  280,  291
	.word	 251,  253,  266,  269,  271,  272,  280,  288,  291,  299
	.word	1469, 2474, 3477, 4479, 5482, 5484, 6486, 7788, 8492

apothemLens:
	.word	  32,   51,   76,   87,   90,  100,  111,  123,  132,  145
	.word	 634,  652,  674,  686,  697,  704,  716,  720,  736,  753
	.word	 782,  795,  807,  812,  827,  847,  867,  879,  888,  894
	.word	 102,  113,  122,  139,  144,  151,  161,  178,  186,  197
	.word	1782, 2795, 3807, 3812, 4827, 5847, 6867, 7879, 7888, 1894
	.word	 206,  212,  222,  231,  246,  250,  254,  278,  288,  292
	.word	 332,  351,  376,  387,  390,  400,  411,  423,  432,  445
	.word	  10,   12,   14,   15,   16,   22,   25,   26,   28,   29
	.word	 400,  404,  406,  407,  424,  425,  426,  429,  448,  492
	.word	 457,  487,  499,  501,  523,  524,  525,  526,  575,  594
	.word	1912, 2925, 3927, 4932, 5447, 5957, 6967, 7979, 7988

hexAreas:
	.space	436

len:	.word	109

haMin:	.word	0
haEMid:	.word	0
haMax:	.word	0
haSum:	.word	0
haAve:	.word	0

LN_CNTR	= 7

# -----

hdr:	.ascii	"MIPS Assignment #1 \n"
	.ascii	"Program to calculate area of each hexagon in a series "
	.ascii	"of hexagons. \n"
	.ascii	"Also finds min, est mid, max, sum, and average for the "
	.asciiz	"hexagon areas. \n\n"

new_ln:	.asciiz	"\n"
blnks:	.asciiz	"  "

a1_st:	.asciiz	"\nHexagon min = "
a2_st:	.asciiz	"\nHexagon emid = "
a3_st:	.asciiz	"\nHexagon max = "
a4_st:	.asciiz	"\nHexagon sum = "
a5_st:	.asciiz	"\nHexagon ave = "


###########################################################
#  text/code segment

.text
.globl main
.ent main
main:

# -----
#  Display header.

	la	$a0, hdr
	li	$v0, 4
	syscall				# print header

# --------------------------------------------------


#	YOUR CODE GOES HERE
la $t0, sideLens
la $t1, apothemLens # Load Addresses of the variables
la $t2, hexAreas    # Load address of the storage place
lw $t4, len         # Load length for indexing


lw $t3, ($t0)     # give me side length

lw $t8, ($t1)

mul $t3, $t3, $t8 # Side * APoth
mul $t3, $t3, 6   # prod/2 * 6
div $t3, $t3, 2   # Product/2
sw $t3, ($t2)     # store into array
move $t5, $t3     # hold for min
move  $t6, $t3    # hold for max
move $t7, $0      # load 0
add $t7, $t7, $t3 # add to sum

add $t0, $t0, 4
add $t1, $t1, 4   # advance mem addr
add $t2, $t2, 4

sub $t4, $t4, 1   # decrement
areaLoop:
  beq $t4, $0, end

  lw $t3, ($t0)     # give me side length

  lw $t8, ($t1)

  mul $t3, $t3, $t8 # Side * APoth
  div $t3, $t3, 2   # Product/2
  mul $t3, $t3, 6   # prod/2 * 6
  sw $t3, ($t2)     # store into array


# values are wrong?

  bgt $t3, $t5, checkMax
  move $t5, $t3           # update new min
  j addtoSum

  checkMax:
   blt $t3, $t6, addtoSum
   move $t6, $t3           # update new min

  addtoSum:
   add $t7, $t7, $t3

  add $t0, $t0, 4
  add $t1, $t1, 4   # advance mem addr
  add $t2, $t2, 4
  sub $t4, $t4, 1
  j areaLoop

end:

sw $t5, haMin
sw $t6, haMax
sw $t7, haSum


#need counter for # of # total
#need counter for # of numbers per line
la $s2, hexAreas
move $s1, $0
lw $s3, len
li $s4, LN_CNTR
printLoop:

    la $a0, new_ln
    li $v0, 4
    syscall
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

  
  bne $s1, $s3, printLoop 
out:


lw $t0, len     # load length again
div $t7, $t7, $t0
sw $t7, haAve   # Average

la $t1, hexAreas
lw $t2, ($t1)

sub $t0, $t0, 1
mul $t0, $t0, 4   # calc offset for last element (len - 1 )*4
add $t1, $t1, $t0 # hexArea base + offset

lw $t8, ($t1)
add $t2, $t2, $t8    # first + last

div $t0, $t0, 2   # offset /2 = middle
sub $t1, $t1, $t0 # apply new offset    # should be 54 when you check later

lw $t8, ($t1)
add $t2, $t2, $t8 # add middle element

div $t2, $t2, 3   # / 3

sw $t2, haEMid      # store estMed

##########################################################
#  Display results.

	la	$a0, new_ln		# print a newline
	li	$v0, 4
	syscall
	la	$a0, new_ln		# print a newline
	li	$v0, 4
	syscall

#  Print min message followed by result.

	la	$a0, a1_st
	li	$v0, 4
	syscall				# print "min = "

	lw	$a0, haMin
	li	$v0, 1
	syscall				# print min

# -----
#  Print middle message followed by result.

	la	$a0, a2_st
	li	$v0, 4
	syscall				# print "emid = "

	lw	$a0, haEMid
	li	$v0, 1
	syscall				# print emid

# -----
#  Print max message followed by result.

	la	$a0, a3_st
	li	$v0, 4
	syscall				# print "max = "

	lw	$a0, haMax
	li	$v0, 1
	syscall				# print max

# -----
#  Print sum message followed by result.

	la	$a0, a4_st
	li	$v0, 4
	syscall				# print "sum = "

	lw	$a0, haSum
	li	$v0, 1
	syscall				# print sum

# -----
#  Print average message followed by result.

	la	$a0, a5_st
	li	$v0, 4
	syscall				# print "ave = "

	lw	$a0, haAve
	li	$v0, 1
	syscall				# print average

# -----
#  Done, terminate program.

endit:
	la	$a0, new_ln		# print a newline
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall				# all done!

.end main

