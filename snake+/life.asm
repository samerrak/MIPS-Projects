# TODO: modify the info below
# Student ID: 123456789
# Name: Your Name
# TODO END
########### COMP 273, Winter 2022, Assignment 4, Question 2 - Game of Life ###########

.data
# You should use following two labels for opening input/output files
# DO NOT change following 2 lines for your submission!
inputFileName:	.asciiz	"life-sample-input.txt"
outputFileName:	.asciiz "life-output.txt"
buffer: .space 1 


.text
main:	la $a0, inputFileName
	move $s5,$a0				# save file name to s5
	li $a1,0				# open for reading					# $a0 is input:filename
	jal file_open				# open file 
	move $s6,$v0				# temp copy of file descriptor
	move $a0,$s6				# $a0 = file descriptor
	addi $t7, $t7, 1
	
	
loop:	move $a0,$s6				# $a0 = file descriptor
	la $a1,	buffer			# $a1 = buffer address
	li $a2,1			# $a2 = Bytes to read
	jal read_file
	lb $s0,buffer			# load address of read buffer into s0
	beq $t9, 'm', close		#reached end of file (added my own indicator)
	beq $s0, '\n', height		#if its a new line add to height
	
	addi $s1, $s1, 1 #total number of bytes
	j loop
	
height:	addi $s2, $s2, 1 #height value
	j loop

	
close:	move $a0,$s6				# pass file descriptor		
	jal file_close				# close it for now, will read it next time 
	

array:	move $a0, $s1
	jal malloc
	la $s3, 0($v0)
	
read:	la $a0, inputFileName
	move $s5,$a0				# save file name to s5
	li $a1,0				# open for reading					# $a0 is input:filename
	jal file_open				# open file 
	move $s6,$v0				# temp copy of file descriptor
	move $a0,$s6				# $a0 = file descriptor
	move $t7, $s1				#this will read into
	la $t6, 0($s3)
	move $t9, $0
	
loop2:	move $a0,$s6				# $a0 = file descriptor
	la $a1,	buffer		# $a1 = buffer address
	li $a2,1			# $a2 = Bytes to read
	jal read_file
	lb $s0,buffer			# load address of read buffer into s0
	beq $t9, 'm', close2		#reached end of file (added my own indicator)
	beq $s0, '\n', loop2		#if its a new line add to height
	
	sb $s0, 0($t6)			#sb at array
	addi $t6, $t6, 1		#move pointer
	j loop2
	


close2:	move $a0,$s6				# pass file descriptor		
	jal file_close		
	
	move $a0, $s1
	jal malloc
	la $s4, 0($v0)
	
	div $s7, $s1, $s2 #stores width
	move $t0, $s1 #t0 stores byte counter
	move $t1, $s2 #t1 stores height
	la $t2, 0($s3) #la of array containing numbers
	la $t3, 0($s4) #la of array containing nothing
	move $t4, $0 #outer loop
	move $t5, $0 #inner loop
	move $t8, $0 #J
	
	
	la $t2, 0($s3) #la of array containing numbers
	add $t4, $t4, $s7
	addi $t4, $t4, 1
	add $t3, $t3, 1
	la $a3, 0($t2)
	la $a2, 0($t3)
	la $t9, 0($s4)
	
	
init:	li $a1, '0'
	sb $a1, 0($t9)
	addi $t9, $t9, 1
	bgt $t8, $s7, intr
	addi $t8, $t8, 1
	j init

intr:	jal readInt
	move $v1, $v0
	addi $sp,$sp,-4
	sw $v1, 0($sp)


	
bigw:	beq $v1, 0, close4
	
	
	
while:	bgt $t4, $s1, close3 #counter of bytes

	la $t2, 0($a3) #la of array containing numbers
	la $t3, 0($a2) #array of storing 
	add $t2, $t2, $t4 #offset of array containing number a[i][j]
	add $t3, $t3, $t4 #offset of array containing number a[i][j]
	lb $t6, 0($t2)#load byte of byte
	addi $t5, $0, -1
	move $t7, $0 #number of alive neighbors
	
i:	bgt $t5, 1, endi #i<=1 
	addi $t8, $0, -1
	add $t2, $t2, $t5 #offset horizontal
jaxis:	bgt $t8, 1, endj #j<=1
	mul $a0, $t8, $s7
	add $t2, $t2, $a0 #offset vertical
	lb $t9, 0($t2)
	
	beq $t9, '0', zero
	beq $t9, $0, zero
	li $t9, 1
	j hero
	
zero:	li $t9, 0

hero:	add $t7, $t7, $t9
	sub $t2, $t2, $a0
	addi $t8, $t8, 1
	j jaxis
	
endj:	sub $t2, $t2, $t5 #offset horizontal
	addi $t5, $t5, 1
	j i
	
endi:	beq $t6, '0', zero2
	li $t9, 1
	j neigh

zero2:	li $t9, 0
	
neigh:	sub $t7, $t7, $t9
	
	beq $t9, 1 , cond1
	j cond3
	
cond1:	bge $t7, 2, cond2
	li $a1, '0'
	sb $a1, -1($t3)
	j re
	
cond2:	ble $t7, 3, cond4 
	li $a1, '0'
	sb $a1, -1($t3)
	j re
	
cond3:	bne $t7, 3, cond4
	bne $t9, 0, cond4
	li $a1, '1'
	sb $a1, -1($t3)
	j re
	
cond4:	sb $t6, -1($t3)



re:	addi $t4, $t4, 1 
	j while
	
	

	
	
	
	
	
	
close3: move $t1, $0
	move $t2, $0
	move $t3, $0
	move $t4, $0
	move $t5, $0
	move $t6, $0
	move $t7, $0
	move $t8, $0
	move $t9, $0
	move $a0, $0
	move $a1, $0
	move $a2, $0
	move $a3, $0
	
	
	addi $v1, $v1, -1
	la $t2, 0($s4) #la of array containing numbers
	la $t3, 0($s3) #la of array containing nothing
	add $t4, $t4, $s7
	addi $t4, $t4, 1
	add $t3, $t3, 1
	la $a3, 0($t2)
	la $a2, 0($t3)
	j bigw

	

close4: lw $v1, 0($sp)
	addi $sp, $sp, 4
	li $v0, 2
	div $v1, $v0
	mfhi $v1
	
	la $a0, outputFileName
	li $a1,1	# write mode
	jal file_open
	move $s0,$v0	# $s0 = file descriptor
	move $t9, $0

	li $a3, '\n'
	la $t5, buffer
	sb $a3, 0($t5)
	beq $v1, $0, even #use $s3
	la $t1, 0($s4)
	j here
even:	la $t1, 0($s3)

here:	move $t3, $0
	add $a0, $s7, $s2
	jal malloc
	move $s5, $v0
	la $t2, 0($s5)
	
	add $a0, $s7, $s1
	move $a3, $a0
	
absi:	beq $a0, $t8, wr
	lb $t5, 0($t1)
	sb $t5, 0($t2)
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	addi $t3, $t3, 1
	addi $t8, $t8, 1
	bne $t3, $s7, absi
	li $t4, '\n'
	sb $t4, 0($t2)
	addi $t2, $t2, 1
	addi $t8, $t8, 1
	move $t3, $0
	j absi
	

	
wr:	move $a0,$s0		# a0 <- file descriptor(s3)
	la $a1, 0($s5)
	add $a2, $0, $a3
	jal file_write
	

endik:	li $v0,10		# syscall for close file
	syscall









        
                
                        
                                
                                        
                                                
                                                        
                                                                
                                                                        
                                                                                
                                                                                        
                                                                                                
                                                                                                        
                                                                                                                
                                                                                                                                
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

readInt:
	li $v0, 5
	syscall
	jr $ra

malloc:
	# $a0 -> number of bytes to allocate
	################## return ##################
	# $v0 -> allocated address.
  	li    	$v0, 9                 # system call code for sbrk
  	syscall                        # allocate memory
  	bnez  	$v0, malloc.return     # Did malloc fail?                   
	li 	$v0,4
	syscall
	li	$v0,-1
malloc.return:
	jr 	$ra

file_write:
	# $a0 -> file descriptor
	# $a1 -> address of output buffer
	# $a2 -> number of characters to write
	#################return#####################
	# $v0 -> number of characters written
	#####################################
	add $sp,$sp,-4
	sw $ra,0($sp)
	
	# a0 <- file descriptor
	# a1 <- address of output buffer
	# a2 <- characters to write
	li $v0, 15		# write to file
	syscall
		
file_write.return:
	lw $ra,0($sp)
	add $sp,$sp,4
	jr $ra	
		

