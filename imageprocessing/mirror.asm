# Student ID = 260964596
########################## mirror #######################
.data
.text
.globl mirror_horizontally
########################## mirror #######################
mirror_horizontally:
#$s0 -> image struct
#$s1 -> width
#s2 -> height
#s3 -> array address
#s4 -> j counter
#s5 -> i counter
#t4 -> height counter
#t5 -> initial byte
#t6 -> final byte

load:	addi $sp,$sp,-8

	la $a0, ($s0) #la to $s0

	lw $s1, 0($a0) #load width
	move $t0, $s1
	
	addi $a0, $a0, 4 
	lw $s2, 0($a0) #load height
	addi $a0, $a0, 8
	
	lw $s3, 0($a0) #load array address
	lw $t1, 0($a0)
	
	 
	move $s4,$zero		# initialize outer loop index "j"
	
outer:	move $s5,$zero		# initialize  inner loop index "i"

	
	mul $t2, $s5, $s1 #beginning of row (width * i)
	
	mul $t3, $s5, $s1 # end of row (width * i)
	add $t3, $t3, $s1 # (width * i) + width
	
	add $t2, $t2, $s3 #initial width offset 
	add $t3, $t3, $s3 #final width offset
	addi $t3, $t3, -1 
	
	
rev:	beq $s4, $s2, mirror_horizontally.return 


	
	sw $t2, 0($sp)
	sw $t3, 4($sp)
	


	
loop: 	lb $t5, 0($t2) #initial byte
	lb $t6, 0($t3) #final byte
	sb $t5, 0($t3) #reverse initial
	sb $t6, 0($t2) #reverse last
	addi $t2, $t2, 1 #advance pointer
	addi $t3, $t3, -1 #advance pointer
	sub $t9, $t3, $t2
	ble $t9, 1, cont
	#beq $t3, $t2, cont
	j loop
	
cont: 	lw $t2, 0($sp)
	lw $t3, 4($sp)
	addi $s4, $s4, 1 #i++
	add $t2, $t2, $s1 #initial width offset 
	add $t3, $t3, $s1 #final width offset 
	move $t9, $0
	j rev
	
mirror_horizontally.return:
	addi $sp,$sp, 8
	la $s3, 0($v0)
	jr $ra

# $a0 -> image struct
	###############return################
	# $v0 -> image struct s.t. mirrored image horizontally. 
	
	
	#Add your codes here
