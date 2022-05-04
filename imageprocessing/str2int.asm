# Student ID = 260964596
###############################str2int######################
.data
.align 2
blank:		.asciiz "\n"
.text
.globl str2int
###############################str2int######################


str2int:
	addi $sp,$sp,-12	
	sw $ra,0($sp)
	sw $t7, 4($sp)
	sw $t8, 8($sp)
	
	la $t0, 0($a0)
	addi $v0, $zero, 0 
	add $v1,$zero,$zero #length
	addi $t4, $zero, 0

loop:	la $t1, 0($t0)
	lb $t2,0($t0)		# load the ascii value of a character into $t2
	beq $t2,32,str2int.return
	beq $t2,10,str2int.return
	beq $t2,$zero,str2int.return	# reached the NULL character so we are done
	
s2i:	mul $t4, $t4, 10 	#num*10	
	subi $t5, $t2, 48	#ASCII value - 48
	add $v0, $t5, $t4	#num*10 + (ASCII value - 48)
	add $t4, $v0, $0
	
length:	addi $v1,$v1,1		# increment count
	addi $t0,$t0,1		# advance pointer by 1
	j loop			# continue loop
 
 	  
	

	# $a0 -> address of string, i.e "32", terminated with 0, EOS
	###### returns ########
	# $v0 -> return converted integer value
	# $v1 -> length of integer
	###########################################################
	# Add code here
	
str2int.return:
  	lw $ra,0($sp)		# restore $ra
  	lw $t7, 4($sp)
	lw $t8, 8($sp)
	addi $sp,$sp,12	# and release stack
	jr $ra

       	
