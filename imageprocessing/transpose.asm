# Student ID = 260964596
##########################image transpose##################
.data
.text
.globl transpose
##########################image transpose##################
transpose:

load:	addi $sp,$sp,-8

	sw $ra, 0($sp)

	la $s0, ($a0) #la to $s0
	lw $s1, 0($a0) #load width
	addi $a0, $a0, 4
	lw $s2, 0($a0) #load height
	addi $a0, $a0, 4
	lw $s3, 0($a0) #load max value
	addi $a0, $a0, 4
	
	lw $s4, 0($a0) #load array address
	la $t0, 0($s4) 	
	
	mul $a0, $s1, $s2
	jal malloc
	la $s5, 0($v0) #load new array address
	la $t1, 0($s5) 	
	
	mul $s7, $s1, $s2
	move $t9, $0
	
	
	
	
outer:	beq $t9, $s7, transpose.return #t2 outer counter
	
	move $t3, $0 #initialize inner counter
	sw $t0, 4($sp) #store array address in stack
	
inner: 	beq $t3, $s2, done #t3 inner counter
	lb $t4, 0($t0) #load byte from array
	sb $t4, 0($t1) #store byte in new array
	addi $t9, $t9, 1
	beq $t9, $s7, transpose.return
	add $t0, $t0, $s1 #increment the original array pointer by width to start at the next line
	addi $t1, $t1, 1 #increment new array pointer by 1
	addi $t3, $t3, 1 #inc inner counter
	j inner
	
done:	lw $t0, 4($sp)
	addi $t0, $t0, 1
	addi $t2, $t2, 1
	j outer
	
	

	

	
	
transpose.return:
	mul $a0, $s1, $s2
	addi $a0, $a0, 12
	jal malloc
	la $s6, 0($v0) #load new struct address
	la $t1, 0($s6) 	
	
	sw $s2, 0($t1) #store width in struct
	addi $t1, $t1, 4
	sw $s1, 0($t1) #store height in struct
	addi $t1, $t1, 4
	sw $s3, 0($t1) #store maxValue all in struct
	addi $t1, $t1, 4
	sw $s5, 0($t1) #store address of array
	
	move $t0, $0
	move $t1, $0
	move $t2, $0
	move $t3, $0
	move $t4, $0
	move $t5, $0
	move $t6, $0
	move $t7, $0
	move $t8, $0
	move $t9, $0
	move $s0, $0
	move $s1, $0
	
	lw $ra, 0($sp)
	addi $sp,$sp,8
	la $v0, 0($s6)
	jr $ra
	
		# $a0 -> image struct
	###############return################
	# $v0 -> image struct s.t. contents containing the transpose image.
	# Note that you need to rewrite width, height and max_value information
	
	
	# Adds your codes here 
