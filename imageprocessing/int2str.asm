# Student ID = 260964596
###############################int2str######################
.data
.align 2
int2strBuffer: .space 4
.text
.globl int2str
###############################int2str######################

int2str:addi $sp,$sp,-36
	sw $ra,0($sp)
	sw $t9, 4($sp)
	sw $t0, 8($sp)
	sw $t6, 12($sp)
	sw $t4, 16($sp)
	sw $t7, 20($sp)
	sw $t3, 24($sp)
	sw $a0, 28($sp)
	sw $t5, 32($sp)
	
	beq $a0, 0, zero
	j note
	
zero:	la $t1, int2strBuffer
	li $t2, '0'
	sb $t2, 0($t1)
	li $t2, ' '
	sb $t2, 1($t1)
	j int2str.return 
	

note:	move $t0, $a0 #store int to be converted
	la $t7, int2strBuffer
	addi $t2, $t0, 0 #copy of int
	addi $v1, $0, 0 #counter
	addi $t8, $0, 10
	
	
i2s: 	beq $t2, 0, cont
	addi $v1, $v1, 1 #increment counter
	div $t2, $t8 #divide int by 10
	mfhi $t4 #move remainder to t4
	addi $t6, $t4, 48 #48 + *int % 10
	mflo $t2 #move quotient to t2
	sb $t6, 0($t7)
	addi $t7, $t7, 1
	j i2s
	
cont: 	addi $v1, $v1, 1 
	addi $t9, $0, 32
	sb $t9, 0($t7)
	
	
rev:	la  $t1, int2strBuffer
	la  $t0, int2strBuffer
	
	
loop1:	lb $t3, 0($t1)
	addi $t1, $t1, 1
	bne $t3, ' ', loop1
	
	addi $t1, $t1, -1
	
	
loop2:	ble $t1, $t0, int2str.return 	# string reversal, byte by byte
	addi $t1, $t1, -1
	lb $t3, 0($t1)
	lb $t4, 0($t0)
	sb $t4, 0($t1)
	sb $t3, 0($t0)
	addi $t0, $t0, 1
	j  loop2
	
	

		
int2str.return:

	lw $ra,0($sp)
	lw $t9, 4($sp)
	lw $t0, 8($sp)
	lw $t6, 12($sp)
	lw $t4, 16($sp)
	lw $t7, 20($sp)
	lw $t3, 24($sp)
	lw $a0, 28($sp)
	lw $t5, 32($sp)
	la $v0, int2strBuffer
	addi $v1, $v1, 0
	addi $sp,$sp,36	# and release stack
	jr $ra
	
	
	
	
		
	# $a0 <- integer to convert
	##############return#########
	# $v0 <- space terminated string 
	# $v1 <- length or number string + 1(for space)
	###############################
	# Add code here


