# Student ID = 1234567
####################################write Image#####################
.data
head:		.space 20
blank:			.asciiz "\n"
.text
.globl write_image


####################################write Image#####################

#s0 holds the descriptor
#s1 holds the filetype and then after we dont need it the buffer
#s2 holds pointer to struct
#s3 holds array
#s4 holds width
#s5 holds height
#s6 holds maxVal
#s7 h*w
#t5 holds total character offset for header	
# $a0 -> image struct
# $a1 -> output filename
# $a2 -> type (0 -> P5, 1->P2)

write_image:

type: 	addi $sp,$sp,-16
	sw $ra, 0($sp)
	sw $t0, 4($sp)

	
	beq $a2, 0, P5 #check type and store accordingly
	li $s1, '2'
	j after
	
P5: 	li $s1, '5'

after:	la $s2, 0($a0) #store struct address in s2
	la $t9, 0($a0) #store struct address in t9 as well
	
header: la $s3, head
	la $t0, head #address to head

	
	li $t1, 'P'
	sb $t1, 0($t0)
	addi $t0, $t0, 1 #offset two spaces
	sb $s1, 0($t0) #store header in buffer
	addi $t0, $t0, 1 #offset two spaces
	
	li $t1, '\n'
	sb $t1, 0($t0)
	
	addi $t0, $t0, 1 #offset 1
	
width:	lw $a0, 0($t9) #load word from struct
	lw $t8, 0($t9)
	sw $t8, 8($sp)
	add $s7, $a0, 0 #store h*w in s7
	addi $t9, $t9, 4 #offset struct pointer by 4
	jal int2str #call subroutine
	la $s4, 0($v0) #load address of converted int to s4
	la $t3, 0($v0)
	add $t5, $v1, 3
	
	
storew:	lb $t4, 0($t3) #load bytes and store it in buffer
	beq $t4, $0, height
	sb $t4, 0($t0)
	addi $t0, $t0, 1
	addi $t3, $t3, 1
	j storew
	
	
	
height:	lw $a0, 0($t9) #load height do exact same thing as width
	mul $s7, $s7, $a0 #height * width
	addi $t9, $t9, 4
	jal int2str
	la $s5, 0($v0) #load address of converted height to s4
	la $t3, 0($v0)
	add $t5, $v1, $t5
	
	
storeh:	lb $t4, 0($t3) #store it in header buffer
	beq $t4, $0, maxval
	sb $t4, 0($t0)
	addi $t0, $t0, 1
	addi $t3, $t3, 1
	j storeh
	
	
maxval: li $t1, '\n' #same thing as width and height
	sb $t1, -1($t0) #new change from -1
contm:	addi $t0, $t0, 1 #offset 1
	lw $a0, 0($t9)
	addi $t9, $t9, 4
	jal int2str
	la $s6, 0($v0)
	la $t3, 0($v0)
	
	
storem:	lb $t4, 0($t3)
	beq $t4, 32, next
	sb $t4, -1($t0) #new
	addi $t0, $t0, 1
	addi $t3, $t3, 1
	j storem
	
	
next:	li $t1, '\n'
	sb $t1, -1($t0)
	add $t5, $v1, $t5
	#li $v0, 4	# print the string out
  	#la $a0, head #load the address into $a0
  	#syscall  
  	
  	
array:	lw $s3, 0($t9) #load address of array unto s3
	
	la $a3, 0($s3)
	
	
	
		
open:	li $v0, 13  #open file
	la $a0, 0($a1) #set filename
	la $a1, 1   # file flag (read)=1
	syscall
	blt $v0, $zero, write_image.return
	move $s0,$v0 #move descriptor to s0
	
	li $v0, 15 #write file syscode
	move $a0, $s0 #restore descriptor
	la $a1,head #write header file
	la $a2, ($t5)
	syscall
	
	beq $s1, 50, multi
	li $v0, 15 #write file syscode
	move $a0, $s0 #restore descriptor
	la $a1, blank #array
	li  $a2, 1 #height * width
	#syscall
	
multi:	mul $s7, $s7, 5 #new change
	mflo $t5
	
	
	beq $s1, 53, write5 #if type is 5 just write the array otherwise convert the integers to ascii
	

	move $t7, $0
	move $t4, $0
	div $s7, $s7, 5 #new change
	
cont2:	beq $t7, $s7, close2 #if equal to h*w then exit this subroutine
	lb $a0, 0($a3) #load byte of integer array is pointing at to arg0
	addi $a3, $a3, 1 #advance pointer of array by 1
	jal int2str #convert to string
	
loop3: 	lb $t0, 0($v0)
	sb $t0, 0($a1) #store the converted string
	
	sw $v0, 12($sp)
	
	li $v0, 15 #write file syscode
	move $a0, $s0 #restore descriptor
	la $a1, 0($a1) 
	li  $a2, 1 
	syscall
	
	lw $v0, 12($sp)

	
	addi $v0, $v0, 1 #new change
	
	beq $t0, ' ', conti
	j loop3

	
conti:	addi $t7, $t7, 1 #add to the offset to the counter of bytes
	addi $t4, $t4, 1 #add 1 to the width to check if a new line is needed
	lw $t8, 8($sp)
	beq $t4, $t8, newn
	j cont2
	
newn: 	
	li $t1, '\n'
	sb $t1, 0($t9)
	li $v0, 15 #write file syscode
	move $a0, $s0 #restore descriptor
	la $a1, 0($t9) 
	li  $a2, 1 
	syscall
	
	#li $t1, '\n' #same thing as width and height
	#sb $t1, 0($t9)

	move $t4, $0
	j cont2

close2:	j write_image.return
	
	


write5:	li $v0, 15 #write file syscode
	move $a0, $s0 #restore descriptor
	la $a1, 0($s3) #array
	move $a2, $s7 #height * width
	syscall
	


	
write_image.return:
	li $v0,16 #close file
	move $a0, $s0
	syscall
	lw $ra, 0($sp)
	addi $sp,$sp,16
	jr $ra
	
	
	
load:	addi $sp,$sp,8
	sw $ra,0($sp)
	sw $t0, 4($sp)
	
	beq $t8, 1, newl
	li $t0, ' '
	j return
	
newl:	li $t0, '\n'

return: lw $ra,0($sp)
	lw $t0, 4($sp)
	addi $sp,$sp, 8
	jr $ra
