# TODO: modify the info below
# Student ID: 123456789
# Name: Your Name
# TODO END
########### COMP 273, Winter 2022, Assignment 4, Question 3 - Snake ###########

# Constant definition. You can use them like using an immediate.
# color definition:
.eqv BLACK	0x00000000
.eqv RED	0x00ff0000
.eqv GREEN	0x0000ff00
.eqv BLUE	0x000000ff
.eqv YELLOW	0x00ffff00
.eqv BROWN	0x00994c00
.eqv GRAY	0x00f0f0f0
.eqv WHITE	0x00ffffff

# tile definition
.eqv EMPTY	BLACK
.eqv SNAKE	WHITE
.eqv FOOD	YELLOW
.eqv RED_PILL	RED
.eqv BLUE_PILL	BLUE
.eqv WALL	BROWN

# Direction definition
.eqv DIR_RIGHT	0
.eqv DIR_DOWN	1
.eqv DIR_LEFT	2
.eqv DIR_UP  3

# game state definition
.eqv STATE_NORMAL	0
.eqv STATE_PAUSE	1
.eqv STATE_RESTART	2
.eqv STATE_EXIT		3

# some constants for buffer
.eqv WIDTH	64
.eqv HEIGHT	32
.eqv DISPLAY_BUFFER_SIZE	0x2000
.eqv SNAKE_BUFFER_SIZE		0x2000

# initial postion of the snake
.eqv INIT_HEAD_X	32
.eqv INIT_HEAD_Y	16
.eqv INIT_TAIL_X	31
.eqv INIT_TAIL_Y	16

# initial length of the snake
.eqv INIT_LENGTH	2

# maximum number of pills
.eqv MAX_NUM_PILLS	10

# TODO: add any constants here you if you need


# TODO END


.data
displayBuffer:	.space	DISPLAY_BUFFER_SIZE	# 64x32 display buffer. Each pixel takes 4 bytes.
snakeSegment:	.space	SNAKE_BUFFER_SIZE	# Array to store the offsets of the snake segments in the display buffer.
						# E.g., head_offset, 2nd_segment_offset, ..., tail_offset
						# Each offset takes 4 bytes.
snakeLength:	.word	INIT_LENGTH		# length of the snake
headX:		.word	INIT_HEAD_X		# head position x
headY:		.word	INIT_HEAD_Y		# head position y
numPills:	.word	0	# number of pills (red and blue)
direction:	.word	0	# moving direction of the snake head:
				#	0: right
				#	1: down
				#	2: left
				#	3: up
state:		.word	0	# game state:
				#	0: normal
				#	1: pause
				#	2: retstart
				#	3: exit
score:		.word	0	# score in the game. increase by 1 everying time eating a regular food
msgScore:	.asciiz "Score: "
.align 2
timeInterval:	.word   100
wallBuff:	.space 2200
wallFile:	.asciiz "map.txt"
incSpeed:	.float 0.833333
decSpeed:	.float 1.25

# TODO: add any variables here you if you need



# TODO END


.text
main:
	jal initGame
gameLoop:
	li $v0, 32
	lw $a0, timeInterval
	syscall
	
	


# TODO: objective 1, Handle Keyboard Input using MMIO 

	lui $t0, 0xffff 	# $t0 = 0xffff0000
	lw $t1, 0($t0) 		# $t1 = value(0xffff0000)
	andi $t1,$t1,0x0001	# Is Device ready?
	beq $t1,$zero,end	# No: Check again..
	lw $v0, 4($t0) 		# Yes : read data from 0xffff0004
	la $t3, direction	#address of direction bufer
	la $t5, state
	
cond1:	beq $v0, 'w', next1
	j cond2
next1:	beq $t9, 's', s
	
cond2:	beq $v0, 's', next2
	j cond3
next2:	beq $t9, 'w', w
	
cond3:	beq $v0, 'a', next3
	j cond4
next3:	beq $t9, 'd', d
	
cond4:	beq $v0, 'd', next4
	j nt
next4:	beq $t9, 'a', a
	
	
nt:	move $t2, $v0		#stores value in $t2
	move $t9, $v0
	beq $t2, 'w', w
	beq $t2, 'a', a
	beq $t2, 's', s
	beq $t2, 'd', d
	beq $t2, 'p', p
	beq $t2, 'q', q
	beq $t2, 'r', r
	
w:	li $t4, 3
	sw $t4, 0($t3)
	j gameLoop
	
a:	li $t4, 2
	sw $t4, 0($t3)
	j gameLoop
	
s:	li $t4, 1
	sw $t4, 0($t3)
	j gameLoop
	
d:	li $t4, 0
	sw $t4, 0($t3)
	j gameLoop

p:	addi $t6, $t6, 1
	beq $t6, 1, p1
	move $t6, $0
	li $t4, 0
	sw $t4, 0($t5)
	j gameLoop
	
p1:	li $t4, 1
	sw $t4, 0($t5)
	j gameLoop
	
r:	li $t4, 2
	sw $t4, 0($t5)
	j gameLoop
	
q:	li $t4, 3
	sw $t4, 0($t5)
	j end
	
	
	

	
	




# TODO END	
end:	lw $t0, state
	beq $t0, STATE_NORMAL, main.normal
	beq $t0, STATE_PAUSE, main.pause
	beq $t0, STATE_RESTART, main.restart
	j main.exit
main.normal:
	jal updateDisplay	
	j gameLoop
main.pause:
	j gameLoop
main.restart:
	jal initGame
	j gameLoop	
main.exit:
	la $a0, msgScore
	li $v0, 4
	syscall
	lw $a0, score
	li $v0, 1
	syscall
	li $v0, 10
	syscall
	
	
# void initGame()
initGame:
	sub $sp, $sp, 4
	sw $ra, ($sp)
	
	la $a0, displayBuffer
	li $a1, DISPLAY_BUFFER_SIZE
	jal clearBuffer
	
	jal initMap
	
	# initialize variables
	li $t0, INIT_LENGTH
	sw $t0, snakeLength
	li $t0, INIT_HEAD_X
	sw $t0, headX
	li $t0, INIT_HEAD_Y
	sw $t0, headY
	li $t0, DIR_RIGHT
	sw $t0, direction
		
	li $a0, INIT_HEAD_X
	li $a1, INIT_HEAD_Y
	jal pos2offset
	li $t0, SNAKE
	sw $t0, displayBuffer($v0)	# draw head pixel
	sw $v0, snakeSegment		# head offset

	li $a0, INIT_TAIL_X
	li $a1, INIT_TAIL_Y
	jal pos2offset
	li $t0, SNAKE
	sw $t0, displayBuffer($v0)	# draw tail pixel
	sw $v0, snakeSegment+4		# tail offset
	
	sw $zero, numPills
	li $t0, STATE_NORMAL
	sw $t0, state
	sw $zero, score
	
	# set seed for corresponding pseudorandom number generator using system time
	li $v0, 30
	syscall
	move $a1, $a0
	li $a0, 0	# ID = zero
	li $v0, 40
	syscall	
	
	# spawn food
	jal spawnFood

	lw $ra, ($sp)
	add $sp, $sp, 4	
	jr $ra
	
	
# void updateDisplay()
updateDisplay:
	sub $sp, $sp, 8
	sw $ra, ($sp)
	sw $s0, 4($sp)
	
	lw $a0, headX
	lw $a1, headY
	lw $t0, direction
	beq $t0, DIR_RIGHT, updateDisplay.goRight
	beq $t0, DIR_DOWN, updateDisplay.goDown
	beq $t0, DIR_LEFT, updateDisplay.goLeft
	beq $t0, DIR_UP, updateDisplay.goUp
updateDisplay.goRight:
	add $a0, $a0, 1
	blt $a0, WIDTH, updateDisplay.headUpdateDone
	sub $a0, $a0, WIDTH	# wrap over if exceeds boundary
	j updateDisplay.headUpdateDone
updateDisplay.goDown:
	add $a1, $a1, 1
	blt $a1, HEIGHT, updateDisplay.headUpdateDone
	sub $a1, $a1, HEIGHT	# wrap over if exceeds boundary
	j updateDisplay.headUpdateDone
updateDisplay.goLeft:
	sub $a0, $a0, 1
	bge $a0, 0, updateDisplay.headUpdateDone
	add $a0, $a0, WIDTH	# wrap over if exceeds boundary
	j updateDisplay.headUpdateDone
updateDisplay.goUp:
	sub $a1, $a1, 1
	bge $a1, 0, updateDisplay.headUpdateDone
	add $a1, $a1, HEIGHT	# wrap over if exceeds boundary
	j updateDisplay.headUpdateDone
updateDisplay.headUpdateDone:
	sw $a0, headX
	sw $a1, headY
	jal pos2offset
	move $s0, $v0		# store the head offset because we need it later

	lw $t0, displayBuffer($s0) # what is in the next posion of head?
	beq $t0, EMPTY, updateDisplay.empty
	beq $t0, FOOD, updateDisplay.food
	beq $t0, RED_PILL, updateDisplay.redPill
	beq $t0, BLUE_PILL, updateDisplay.bluePill
	# else hit into bad thing
	li $t0, STATE_EXIT
	sw $t0, state
	j updateDisplay.ObjectDetectionDone
	
updateDisplay.empty:	# nothing
	li $t0, SNAKE
	sw $t0, displayBuffer($s0)	# draw head pixel
	
	# erase old tail in display (set color to black)
	lw $t0, snakeLength
	sub $t0, $t0, 1
	sll $t0, $t0, 2
	lw $t1, snakeSegment($t0)	# load the tail offset
	li $t2, EMPTY
	sw $t2, displayBuffer($t1)
	
	j updateDisplay.ObjectDetectionDone
	
updateDisplay.food:	#regular food
	li $t0, SNAKE
	sw $t0, displayBuffer($s0)	# draw head pixel
	lw $t0, snakeLength
	add $t0, $t0, 1
	sw $t0, snakeLength	# increase snake length
	
	jal spawnFood
	lw $t0, score
	add $t0, $t0, 1
	sw $t0, score
	
	j updateDisplay.ObjectDetectionDone
	
updateDisplay.redPill:
	li $t0, SNAKE
	sw $t0, displayBuffer($s0)	# draw head pixel
	
	# erase old tail in display (set color to black)
	lw $t0, snakeLength
	sub $t0, $t0, 1
	sll $t0, $t0, 2
	lw $t1, snakeSegment($t0)	# load the tail offset
	li $t2, EMPTY
	sw $t2, displayBuffer($t1)
	
	lw $t0, numPills
	sub $t0, $t0, 1
	sw $t0, numPills
	
	# increase game speed
	lw $t0, timeInterval
	mtc1 $t0, $f0
	cvt.s.w $f0, $f0
	l.s $f1, incSpeed
	mul.s $f0, $f0, $f1
	cvt.w.s $f0, $f0
	mfc1 $t0, $f0
	sw $t0, timeInterval
	
	j updateDisplay.ObjectDetectionDone
	
updateDisplay.bluePill:
	li $t0, SNAKE
	sw $t0, displayBuffer($s0)	# draw head pixel
	
	# erase old tail in display (set color to black)
	lw $t0, snakeLength
	sub $t0, $t0, 1
	sll $t0, $t0, 2
	lw $t1, snakeSegment($t0)	# load the tail offset
	li $t2, EMPTY
	sw $t2, displayBuffer($t1)
	
	lw $t0, numPills
	sub $t0, $t0, 1
	sw $t0, numPills
	
	# decrease game speed
	lw $t0, timeInterval
	mtc1 $t0, $f0
	cvt.s.w $f0, $f0
	l.s $f1, decSpeed
	mul.s $f0, $f0, $f1
	cvt.w.s $f0, $f0
	mfc1 $t0, $f0
	sw $t0, timeInterval
	
	j updateDisplay.ObjectDetectionDone

updateDisplay.ObjectDetectionDone:
	
	
	# update snake segments
	# for i = length-1 to 1
	#	snakeSegment[i] = snakeSegment[i-1]
	# snakeSegment[0] = new head position (stored in $s0)
	lw $t0, snakeLength	# index i
updateDisplay.snakeUpdateLoop:
	sub $t0, $t0, 1
	blt $t0, 1, updateDisplay.snakeUpdateLoopDone
	sll $t1, $t0, 2		# convert index to offset
	sub $t2, $t1, 4		# offset of previous segment
	lw $t4, snakeSegment($t2)
	sw $t4, snakeSegment($t1) # snakeSegment[i] = snakeSegment[i-1]
	j updateDisplay.snakeUpdateLoop
updateDisplay.snakeUpdateLoopDone:
	sw $s0, snakeSegment	# update head offset in snakeSegment
	
	lw $ra, ($sp)
	lw $s0, 4($sp)
	add $sp, $sp, 8
	jr $ra
	

# int pos2offset(int x, int y)
# offset = (y * WIDTH + x) * 4
# Note that each pixel takes 4 bytes!
pos2offset:
	mul $v0, $a1, WIDTH
	add $v0, $v0, $a0
	sll $v0, $v0, 2
	jr $ra


# void spawnFood()
spawnFood:
	sub $sp, $sp, 4
	sw $ra, ($sp)
	
	# spawn regular food (yellow)
spawnFood.regular:
	li $a0, WIDTH	# range: 0 <= x < WIDTH
	jal randInt
	move $t0, $v0,	# position x
	li $a0, HEIGHT	# range: 0 <= y < HEIGHT
	jal randInt
	move $t1, $v0,	# position y
	move $a0, $t0
	move $a1, $t1
	jal pos2offset
	lw $t0, displayBuffer($v0)		# get "thing" on (x, y)
	bne $t0, EMPTY, spawnFood.regular	# find another place if it is not empty
	li $t0 FOOD
	sw $t0, displayBuffer($v0)	# put the food
	
# TODO: objective 2, Spawn Pills
# see spawnFood.regular for example
#lw $t0, numPills
#sub $t0, $t0, 1
	li $a0, 100	# generate a random number from 0-99 for blue pill
	jal randInt
	move $t3, $v0,	# blue pill chance
	li $a0, 100	# generate a random number from 0-99 for red pill
	jal randInt
	move $t4, $v0,	# red pill chance
	
red:	bge $t3, 20, blue #if > 20 then go to blue

	li $a0, WIDTH	# range: 0 <= x < WIDTH
	jal randInt
	move $t0, $v0,	# position x
	li $a0, HEIGHT	# range: 0 <= y < HEIGHT
	jal randInt
	move $t1, $v0,	# position y
	move $a0, $t0
	move $a1, $t1
	jal pos2offset
	lw $t0, displayBuffer($v0)		# get "thing" on (x, y)
	bne $t0, EMPTY, red	# find another place if it is not empty
	li $t0, RED_PILL
	sw $t0, displayBuffer($v0)

blue:	bge $t4, 15, returnr #if > 15 then go to end

	li $a0, WIDTH	# range: 0 <= x < WIDTH
	jal randInt
	move $t0, $v0,	# position x
	li $a0, HEIGHT	# range: 0 <= y < HEIGHT
	jal randInt
	move $t1, $v0,	# position y
	move $a0, $t0
	move $a1, $t1
	jal pos2offset
	lw $t0, displayBuffer($v0)		# get "thing" on (x, y)
	bne $t0, EMPTY, blue	# find another place if it is not empty
	li $t0, BLUE_PILL
	sw $t0, displayBuffer($v0)


# TODO END
	
returnr:lw $ra, ($sp)
	add $sp, $sp, 4 
	jr $ra


# void clearBuffer(char* buffer, int size)
clearBuffer:
	li $t0, 0
clearBuffer.loop:
	bge $t0, $a1, clearBuffer.return
	add $t1, $a0, $t0
	sb $zero, ($t1)
	add $t0, $t0, 1
	j clearBuffer.loop
clearBuffer.return:
	jr $ra


# int randInt(int max)
# generate an random integer n where 0 <= n < max
randInt:
	move $a1, $a0
	li $a0, 0
	li $v0, 42
	syscall
	move $v0, $a0
	jr $ra
	
# void initMap()
initMap:
# TODO: objective 3, Add Walls
# load the map file you create and add wall to displayBuffer
	
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	
	
	la $a0, wallFile
	move $s5,$a0				# save file name to s5
	li $a1,0				# open for reading					# $a0 is input:filename
	jal file_open				# open file 
	move $s6,$v0				# temp copy of file descriptor
	move $a0,$s6				# $a0 = file descriptor
	addi $t7, $t7, 1
	
	
loop:	
	move $a0,$s6				# $a0 = file descriptor
	la $a1, wallBuff			# $a1 = buffer address
	li $a2,1			# $a2 = Bytes to read
	jal read_file
	lb $s0, wallBuff			# load address of read buffer into s0
	beq $s0, '1', wall
	beq $s0, '\n', loop
	beq $t9, 'm', close		#reached end of file (added my own indicator)
	li $t0, EMPTY
	sw $t0, displayBuffer($s3)
	addi $s3, $s3, 4
	j loop
	
wall:	li $t0, WALL
	sw $t0, displayBuffer($s3)
	addi $s3, $s3, 4
	j loop


close:	move $a0,$s6				# pass file descriptor		
	jal file_close				# close it for now, will read it next time


# TODO END
endinL:	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

# TODO END

	
# TODO: add any helper functions here you if you need

file_open: 
	li $v0, 13		# Syscall for opening file
	li $a2, 0		# ignore mode
	syscall
	bgt $v0,$zero,file_open.return # check if opening was sucessfull
	
file_open.return:	
	jr $ra	
	
read_file:	
	move $t2,$a2
	addi $a2,$zero,1		# read 1 byte at a time
read_file.loop:	
	li $v0,14		# syscall for read from file
	syscall
	beq $v0,0,read_file.returnend  # if eof 
	
read_file.return:
	jr $ra
read_file.returnend:
	li $t9, 'm' #load t9 with m 
	jr $ra

	
file_close:

	li $v0,16		# syscall for close file
	syscall
	jr $ra




# TODO END
