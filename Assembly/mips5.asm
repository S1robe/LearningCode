###########################################################################
#  Assignment: MIPS #5
#  Description:  This program takes user input in the form of 4 integers representing the first point (x, y) and the second point (x', y'), if the end point is to the left or above the start point it is rejected and msut be reentered. A later function recursively computes the number of paths to get to from the start point to the end. This was a spiritual journey, may all who take the path reach the end intended for them.


###########################################################################
#  data segment

.data

# -----
#  Constants

TRUE = 1
FALSE = 0
COORD_MAX = 100

# -----
#  Variables for main

hdr:		.ascii	"\n**********************************************\n"
		.ascii	"\nMIPS Assignment #5\n"
		.asciiz	"Count Grid Paths Program\n"

startRow:	.word	0
startCol:	.word	0
endRow:		.word	0
endCol:		.word	0

totalCount:	.word	0

endMsg:		.ascii	"\nYou have reached recursive nirvana.\n"
		.asciiz	"Program Terminated.\n"

# -----
#  Local variables for prtResults() function.

cntMsg1:	.asciiz	"\nFrom a start coordinate of ("
cntMsgComma:	.asciiz	","
cntMsg2:	.asciiz	"), to an end coordinate of ("
cntMsg3:	.asciiz	"), \nthere are "
cntMsg4:	.asciiz	" ways traverse the grid.\n"

# -----
#  Local variables for readCoords() function.

strtRowPmt:	.asciiz	"  Enter Start Coordinates ROW: "
strtColPmt:	.asciiz	"  Enter Start Coordinates COL: "

endRowPmt:	.asciiz	"  Enter End Coordinates ROW: "
endColPmt:	.asciiz	"  Enter End Coordinates COL: "

err0:		.ascii	"\nError, invalid coordinate value.\n"
		.asciiz	"Please re-enter.\n"

err1:		.ascii	"\nError, end coordinates must be > then "
		.ascii	"the start coordinates. \n"
		.asciiz	"Please re-enter.\n"

spc:		.asciiz	"   "

# -----
#  Local variables for prtNewline function.

newLine:	.asciiz	"\n"


###########################################################################
#  text/code segment

.text
.globl main
.ent main
main:

# -----
#  Display program header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----
#  Function to read and return initial coordinates.

	la	$a0, startRow
	la	$a1, startCol
	la	$a2, endRow
	la	$a3, endCol
	jal	readCoords

# -----
#  countPaths - determine the number of possible
#		paths through a two-dimensional grid.
#	returns integer answer.

#  HLL Call:
#	totalCount = countPaths(startRow, startCol, endRow, endCol)

	lw	$a0, startRow
	lw	$a1, startCol
	lw	$a2, endRow
	lw	$a3, endCol
	jal	countPaths
	sw	$v0, totalCount

# ----
#  Display results (formatted).

	lw	$a0, startRow
	lw	$a1, startCol
	lw	$a2, endRow
	lw	$a3, endCol
	subu	$sp, $sp, 4
	lw	$t0, totalCount
	sw	$t0, ($sp)
	jal	prtResults
	addu	$sp, $sp, 4

# -----
#  Done, show message and terminate program.

	li	$v0, 4
	la	$a0, endMsg
	syscall

	li	$v0, 10
	syscall					# all done...
.end main

# =========================================================================
#  Very simple function to print a new line.
#	Note, this routine is optional.

.globl	prtNewline
.ent	prtNewline
prtNewline:
	la	$a0, newLine
	li	$v0, 4
	syscall

	jr	$ra
.end	prtNewline

# =========================================================================
#  Function to print final results (formatted).

# -----
#    Arguments:
#	startRow, value
#	startCol, value
#	endRow, value
#	endCol, value
#	totalCount, value
#    Returns:

.globl	prtResults
.ent	prtResults
prtResults:
subu $sp, $sp, 4
sw $a0, ($sp)

li $v0, 4
la $a0, newLine
syscall

li $v0, 4
la $a0, cntMsg1
syscall

li $v0, 1
lw $a0, ($sp) # print start row
syscall

add $sp, $sp, 4 # deallcate no more need

li $v0, 4
la $a0, cntMsgComma
syscall # comma


li $v0, 1
move $a0, $a1 # print start col
syscall

li $v0, 4
la $a0, cntMsg2 # to end messge
syscall

li $v0, 1
move $a0, $a2 # end row
syscall

li $v0, 4
la $a0, cntMsgComma # comma
syscall

li $v0, 1
move $a0, $a3 # end col
syscall

li $v0, 4
la $a0, cntMsg3
syscall

li $v0, 1
lw $a0, ($sp) # value
syscall

li $v0, 4
la $a0, cntMsg4
syscall

  jr	$ra
.end	prtResults

# =========================================================================
#  Prompt for and read start and end coordinates.
#  Also, must ensure that:
#	each value is between 0 and COORD_MAX ( 100 )
#	start coordinates are < end coordinates

# -----
#    Arguments:
#	startRow, address a0
#	startCol, address a1
#	endRow, address  a2
#	endCol, address a3
#    Returns:
#	startRow, startCol, endRow, endCol via reference

# calc # of bytes required for buffer, allocate off stack, read X bytes into the buffer

.globl	readCoords
.ent	readCoords
readCoords:
subu $sp, $sp, 20
sw $s0, ($sp)
sw $s1, 4($sp)
sw $s7, 8($sp)
sw $ra, 12($sp)
sw $s4, 16($sp)

move $s0, $a0
move $s1, $a1

jal getstartRow # bind next line as reset point ($s7)
getstartRow: 
 add $ra, $ra, 12
 move $s7, $ra # store the currnet cursor position for repeated questions
 move $s4, $ra # held for later
 li $v0, 4
 la $a0, strtRowPmt
 syscall

 jal read
 sw $v0, ($s0)

jal getstartCol
getstartCol:
 add $ra, $ra, 8
 move $s7, $ra # store the currnet cursor position for repeated questions
 li $v0, 4
 la $a0, strtColPmt
 syscall

 jal read
 sw $v0, ($s1) # store value assuming its good
 lw $t0, ($s0) # get row request
 bne $v0, COORD_MAX, getendRow # if col's is 100, the row cannot be, and sicne rows are first, v.v is true
 bne $v0, $t0, getendRow # we know cols == 100, now if cols = rows, then # steps < 1

 j printError

getendRow:
jal jump1
jump1:
 add $ra, $ra, 8
 move $s7, $ra # store the currnet cursor position for repeated questions
 li $v0, 4
 la $a0, endRowPmt
 syscall

 jal read
 sw $v0, ($a2) # store the asked end row

jal getendCol
getendCol:
 add $ra, $ra, 8
 move $s7, $ra # store the currnet cursor position for repeated questions
 li $v0, 4
 la $a0, endColPmt
 syscall

 jal read
 sw $v0, ($a3) # store the asked end row

veriyEGS:
 move $s7, $s4
 lw $t0, ($s1) # grab the start cl
 la $a0, err1  # load the a0 error
 ble $v0, $t0, printError # error if start col > end col

 lw $t0, ($s0) # grab the a0
 lw $t1, ($a2) # grab end row
 la $a0, err1  # load the a0 error
 ble $t1, $t0, printError # error if start row > end row

# fix the stack
 lw $s0, ($sp)
 lw $s1, 4($sp)
 lw $s7, 8($sp)
 lw $ra, 12($sp)
 lw $s4, 16($sp)
 addu $sp, $sp, 20
	jr	$ra
.end	readCoords



read:
 li $v0, 5 # gimme number
 syscall
 la $a0, err0
 bgt $v0, COORD_MAX, printError
 bltz $v0, printError

jr $ra

printError: # $a0 shoudl be already set if they get here
 li $v0, 4
 syscall

 jr $s7  # return the last asked question.


#####################################################################
#  Function to recursivly determine the number of possible
#  paths through a two-dimensional grid.
#  Only allowed moves are one step to the right or one step down.

#  HLL Call:
#	totalCount = countPaths(startRow, startCol, endRow, endCol)

# -----
#  Arguments:
#	startRow, value
#	startCol, value
#	endRow, value
#	endCol, value

#  Returns:
#	$v0 - paths count

.globl	countPaths
.ent	countPaths
countPaths:
subu $sp, $sp, 16 # space for $ra and $v0
sw $ra, ($sp)
sw $s0, 4($sp)
sw $s2, 8($sp)

# Base 1: r > re or c > re
bgt $a0, $a2, return0 # if a0 (r) > re
bgt $a1, $a3, return0 # or a1 (c) > ce

# Base 2: r = re or c = ce 
beq $a0, $a2, return1 # if a0 (r) = re
beq $a1, $a3, return1 # and a1 (c) = ce


recurse:
move $s2, $a1      # hold c
add $a1, $a1, 1    # c++
jal countPaths     # countPaths(r, c+1, re, ce)
sw $v0, 12($sp)    # store answer

move $a1, $s2 # restore c

move $s0, $a0 # hold r
add $a0, $a0, 1    # r++
jal countPaths     # countPaths(r+1, c, re, ce)

move $a0, $s0      # restore r
lw $v1, 12($sp)    # pull preivous answer
add $v0, $v0, $v1  # combine
sw $v0, totalCount # store

lw $ra, ($sp)
lw $s0, 4($sp)
lw $s2, 8($sp)
add $sp, $sp, 16
jr $ra

return0:
li $v0, 0
lw $ra, ($sp)  # retore return pt
lw $s0, 4($sp)
lw $s2, 8($sp)
addu $sp, $sp, 16 # clean stack
jr $ra

return1:
li $v0, 1
lw $ra, ($sp)  # retore return pt
lw $s0, 4($sp)
lw $s2, 8($sp)
addu $sp, $sp, 16 # clean stack
jr $ra
#####################################################################
