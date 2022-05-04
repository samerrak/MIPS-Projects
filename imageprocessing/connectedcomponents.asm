# Student ID = 260964596
###############################connected components######################
.data
buffer: .space 220
.text
.globl connected_components
########################## connected components ##################
connected_components:
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
	
	la $s7, buffer
	la $a3, buffer

	
	
	

start:	addi $sp,$sp,-4
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
	
loop: 	beq $t2, $s6, equiv
	la $t1, 0($s5) #la of new array
	add $t1, $t1, $t2 #add offset for correct pos
	
	
check1:	lb $t3, 0($t0) #check if 0
	beq $t3, $0, next
	
check2:	addi $t5, $t1, -1 #check if both neighbors are 0
	lb $t6, 0($t5) #if it's non zero and does not have values associated with it's neighbors then we can use the new array
	sub $t5, $t1, $s1
	lb $t7, 0($t5)
	or $t8, $t6, $t7 #if both neighbors or is 0 then it passes this check
	bne $t8, $0, check3
	addi $t4, $t4, 1 #increase label and store new label in the correct position 
	move $t9, $t4
	sb $t9, 0($t1)
	j next
	
check3:	addi $t5, $t1, -1 #checks if one of the neighbors are 0s
	lb $t6, 0($t5) #if it's non zero and does not have values associated with it's neighbors then we can use the new array
	sub $t5, $t1, $s1
	lb $t7, 0($t5)
	beq $t6, $0, mini3
	beq $t7, $0, mini4
	j check4
	
mini3:	sb $t7, 0($t1)
	j next
mini4:	sb $t6, 0($t1)
	j next
	
check4:	addi $t5, $t1, -1 #checks if both are not 0s
	lb $t6, 0($t5) #if it's non zero and does not have values associated with it's neighbors then we can use the new array
	sub $t5, $t1, $s1
	lb $t7, 0($t5)
	beq $t6, $t7, mini0
	ble $t6, $t7, mini1
	ble $t7, $t6, mini2
	
mini0:	sb $t6, 0($t1)
	j next
	
mini1:	move $t8, $0
	move $t9, $0
	sb $t6, 0($t1)
	sb $t7, 0($a3)
	addi $a3, $a3, 1 
	sb $t6, 0($a3)
	addi $a3, $a3, 1
	li $t8, 11
	sb $t8, 0($a3)
	addi $a3, $a3, 1
	j next
	
mini2:	move $t8, $0
	move $t9, $0
	sb $t7, 0($t1)
	sb $t6, 0($a3)
	addi $a3, $a3, 1
	sb $t7, 0($a3) 
	addi $a3, $a3, 1
	li $t8, 11
	sb $t8, 0($a3)
	addi $a3, $a3, 1
	j next
	
next:	add $t0, $t0, 1
	addi $t2, $t2, 1 #increment counter
	j loop
	
equiv:	move $v1, $t4
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
	la $t0, 0($s5) #la of new array

	
while:	beq $t2, $s6, exit
	la $t3, buffer
	lb $t1, 0($t0) #load byte of array after Pass One
	move $t4, $t1 #x->y load x
	move $t5, $t1 # load y
	
arr:	bge $t6, 220, donezo
	lb $t7, 0($t3) #x->y load x
	lb $t8, 1($t3) # load y
	beq $t7, $0, adv
	beq $t8, $0, adv
	bne $t4, $t7, adv #check if x is not equal to $t1 otherwise no point
	blt $t5, $t8, adv #check that t1 is bigger else dont chajnge
	move $t5, $t8 #load byte into y and continue until end
	
adv:	addi $t3, $t3, 3 #add 3 to pointer of equiv array to account for delim
	add $t6, $t6, 3
	j arr
	

	
donezo:	sb $t5, 0($t0) #if it worked the value will be updated by t8, else nothing happens
	move $t6, $0 #reset inner counter
	addi $t2, $t2, 1 #i++
	addi $t0, $t0, 1
	j while


	
	



exit: 	
	addi $a0, $s6, 12
	jal malloc
	la $s6, 0($v0) #load new struct address
	la $t1, 0($s6)
	
	
	
	
	sw $s1, 0($t1) #store width in struct
	addi $t1, $t1, 4
	sw $s2, 0($t1) #store height in struct
	addi $t1, $t1, 4
	
	sw $v1, 0($t1) #store maxValue all in struct
	addi $t1, $t1, 4
	sw $s5, 0($t1) #store address of array
	
	
	







connected_components.return:
	lw $ra, 0($sp)
	addi $sp,$sp,4
	jr $ra
