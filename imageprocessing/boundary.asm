# Student ID = 260964596
###############################image boundary######################
.data
.text
.globl image_boundary
##########################image boundary##################
image_boundary:

start:	
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
	
	addi $sp,$sp,-4
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
	
	mul $s6, $s1, $s2 #s6 stores width * height
	move $a0, $s6
	jal malloc
	la $s5, 0($v0) #load new array address

	
	
	
loop: 	beq $t4, $s6, exit #if counter reaches total number of pixels exit
	addi $t4, $t4, 1 # counter
	la $t5, 0($s5) 	 
	

check1:	lb $t1, 0($t0) #load byte at old array
	beq $t1, 0, next #if zero skip it
	
check2: addi $t2, $t0, 1 #(x, y+1)
	lb $t3, 0($t2)
	beq $t3, $0, mark
	
check3: addi $t2, $t0, -1 #(x, y-1)
	lb $t3, 0($t2)
	beq $t3, $0, mark
	
check4:	add $t2, $t0, $s1 #(x + 1, y) by adding width we go the next line at same pos
	lb $t3, 0($t2)
	beq $t3, $0, mark
	
check5:	sub $t2, $t0, $s1 #(x - 1, y) by subtracting width we go the previous line at same pos
	lb $t3, 0($t2)
	beq $t3, $0, mark
	
	j next

mark:	add $t5, $t5, $t4 #add to the new array address the position of where the pixel that is a boundary is located
	li $a3, 1
	sb $a3, 0($t5)
	
next: 	addi $t0, $t0, 1 #update original address of array
	j loop


	

exit:	addi $a0, $s6, 12
	jal malloc
	la $s6, 0($v0) #load new struct address
	la $t1, 0($s6) 	
	

	sw $s1, 0($t1) #store width in struct
	addi $t1, $t1, 4
	sw $s2, 0($t1) #store height in struct
	addi $t1, $t1, 4
	
	li $s3, 1
	sw $s3, 0($t1) #store maxValue all in struct
	addi $t1, $t1, 4
	sw $s5, 0($t1) #store address of array
	
	
	

image_boundary.return:
	lw $ra, 0($sp)
	addi $sp,$sp,4
	jr $ra
