 # Student ID = 260964596
#########################Read Image#########################
	.data

buffer: .space 20
	.text
	
.globl read_image



#########################Read Image#########################

read_image:

#s0 holds the descriptor
#s1 holds the filetype
#s2 holds width
#s3 holds height
#s4 holds maxV
#s5 holds h*w
#s6 holds pointer to array
#s7 holds total character offset for header

open:	addi $sp,$sp,-20		# need to save $ra
	sw $ra,0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	sw $a3, 16($sp)
	
	la $t9, ($a0)
	li $v0, 13  #open file
	la $a1, 0   # file flag (read)
	syscall
	
	blt $v0, $zero, read_image.return
	move $s0, $v0 #file descriptor in s0
	
read:	li $v0, 14 #read to file
	move $a0, $s0 #move file descriptor to a0
	la $a1, buffer #store address of buffer that contains header, width, height
	la $a2, 20 #hardcode the maximum header information number
	syscall
	
	sb $0, 20($a1) #add null char at length of buffer
	
	
	blt $v0, $zero, read_image.return
	la $a0, buffer #pointer to buffer
	
  	
 close1:li $v0,16 #close file
	move $a0, $s0
	syscall
	
	la $a0, ($t9)
	li $v0, 13  #open file
	la $a1, 0   # file flag (read)
	syscall
	
	blt $v0, $zero, read_image.return
	move $s0, $v0 #file descriptor in s0
	
	
type: 	la $a0, buffer #initialize a0
	addi $a0,$a0, 1 #add length to offset pointer
	lb $s1, 0($a0)
	addi $a0,$a0, 2 #add length to offset pointer
	
	
width:	jal str2int #call str2int
	add $a0,$a0, $v1 #add offset + length
	addi $a0,$a0, 1
	move $s2,$v0 #store width
	
height: jal str2int #call str2int
	add $a0, $v1, $a0 #add offset + length
	addi $a0,$a0, 1
	move $s3,$v0 #store height
	
	
maxvalue: jal str2int #call str2int
	add $a0, $v1, $a0 #add offset + length
	move $s4,$v0 #store max val
	addi $a0,$a0, 1
	la $s7, buffer
	sub $s7, $a0, $s7 #get length of correct offset by subtracting 
			  #the original address of the buffer by the continously updated one
	
heightw: mul $s5, $s2, $s3 #multiply height by width to get array byte size

buff: 	mul $t0, $s5, 5
	add $a0, $t0, $s7
	jal malloc
	move $a3, $v0 #pointer to buffer
	move $a0, $t9 #pointer to buffer
	li $v0, 14 #read to file
	move $a0, $s0 #move file descriptor to a0
	la $a1, 0($a3) #store address of buffer that contains header, width, height
	la $a2, ($t0) #hardcode the maximum header information number
	syscall
	

array: 	move $a0, $s5 #char array size
	jal malloc
	move $s6,$v0 #s6 now contains the adress of the array
	move $t8, $s6 #store a copy of array address in t8
	
	la $a0, 0($a3) #gets adress to buffer
	add $a0, $a0, $s7 #add header offset
	
	add $t7, $0, $0
	beq $s1, 50, readP2 #check type
	

	
readP5: beq $s5, $t7, struct #if byte number is reached then exit
	lb $t4, 0($a0) #traverse the buffer and load the word
	sb $t4, 0($t8) #store the byte at the array
	addi $a0, $a0, 1 #advance buffer pointer
	addi $t8, $t8, 1 #advance array pointer
	addi $t7, $t7, 1 #advance counter
	j readP5

	
	
readP2: beq $s5, $t7, struct #if byte number is reached then exit
	jal str2int
	beq $v1, 0, cont #if its null, char, space then add to pointer and run again
	add $a0,$a0, $v1 #add array pointer + lengt sh to array counter
	blt $v0, 0, struct
	sb $v0, ($t8)
	addi $t8, $t8, 1 #add 1 to buffer pointer
	addi $t7, $t7, 1 #add 1 to counter
	j readP2
	
cont: 	addi $a0,$a0, 1
	j readP2
	
	
	
	
struct:	addi $a0, $s5, 12 #struct size
	jal malloc
	move $t0, $v0 #temporarily store the adress of the struct at t0
	move $t1, $v0 
	
write2s: sw $s2, 0($t0) #store width in struct
	addi $t0, $t0, 4
	sw $s3, 0($t0) #store height in struct
	addi $t0, $t0, 4
	sw $s4, 0($t0) #store maxValue all in struct
	addi $t0, $t0, 4
	sw $s6, 0($t0) #store address of array
	
 	
	
	
	
	
close:	li $v0,16 #close file
	move $a0, $s0
	syscall
	
	
read_image.return: 
	lw $ra,0($sp)		# restore $ra
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	
	addi $sp,$sp,20	# and release stack
	move $v0, $t1 #address of struct
	jr $ra

	