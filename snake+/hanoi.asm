# Student ID: Samer Abdulkarim
# Name: Samer Abdulkarim
# TODO END
########### COMP 273, Winter 2022, Assignment 4, Question 1 - Tower of Hanoi ###########
# TODO:
#       Use a recursive algorithm described to print the solution steps. Make sure you follow the output format.
#       You can design any functions you need (e.g., the recurisve procedure described in the handout) and put them in the next TODO block.
#       There are some helper functions for IO at the end of this file, which might be helpful for you.



.data
# TODO: add any variables here you if you need
to:	.asciiz " to "
moves:	.asciiz ": move disk "
from:	.asciiz " from "
step:	.asciiz "Step "
ouput:	.space 24
.text


main:	jal readInt #read Integer from I/O
	add $a0, $v0, $zero #store int in 
	li $a1, 'A'
	li $a2, 'C'
	li $a3, 'B'
	jal hanoi
	li $v0, 10	# exit the program
	syscall

	
	

	

hanoi:	addi $sp, $sp, -20
	sw $ra, 16($sp) #save the subroutine return address for recursion
	sw $a0, 12($sp) #save n passed to hanoi onto stack
	sw $a1, 8($sp)	#save the source A
	sw $a2, 4($sp)	#save the target C
	sw $a3, 0($sp)	#save the auxiliary 
	

	move $t0, $a0 #storing n
	bne $a0, 1, cont #checking if it equals1
	
	jal print
	lw $ra, 16($sp) #save the subroutine return address for recursion
	addi $sp, $sp, 20
	jr $ra
	
cont:	addi $a0, $a0, -1
	la $t2, 0($a1) #source
	la $t3, 0($a2) #target
	la $t4, 0($a3) #aux

	la $a2, 0($t4)
	la $a3, 0($t3)
	
	jal hanoi
	
	lw $ra, 16($sp) #save the subroutine return address for recursion
	lw $a0, 12($sp) #save n passed to hanoi onto stack
	lw $a1, 8($sp)	#save the source A
	lw $a2, 4($sp)	#save the target C
	lw $a3, 0($sp)	#save the auxiliary 
	
	sw $ra, 16($sp) #save the subroutine return address for recursion
	sw $a0, 12($sp) #save n passed to hanoi onto stack
	sw $a1, 8($sp)	#save the source A
	sw $a2, 4($sp)	#save the target C
	sw $a3, 0($sp)	#save the auxiliary 
	
	jal print

	lw $ra, 16($sp) #save the subroutine return address for recursion
	lw $a0, 12($sp) #save n passed to hanoi onto stack
	lw $a1, 8($sp)	#save the source A
	lw $a2, 4($sp)	#save the target C
	lw $a3, 0($sp)	#save the auxiliary 
	
	
	addi $a0, $a0, -1
	la $t2, 0($a1) #source
	la $t3, 0($a2) #target
	la $t4, 0($a3) #aux
	
	la $a1, 0($t4)
	la $a3, 0($t2)
	
	jal hanoi
	
	lw $ra, 16($sp) #save the subroutine return address for recursion
	lw $a0, 12($sp) #save n passed to hanoi onto stack
	lw $a1, 8($sp)	#save the source A
	lw $a2, 4($sp)	#save the target C
	lw $a3, 0($sp)	#save the auxiliary 
	
	addi $sp, $sp, 20
	
	
	jr $ra
	
	
	


# TODO: your functions here





print:	la $t0, 0($a0)
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	
	addi $t1, $t1, 1 #step counter
	la $a0, step
	jal printStr
	
	move $a0, $t1
	jal printInt
	
	la $a0, moves
	jal printStr
	lw $a0, 0($sp)

	
	move $a0, $t0
	jal printInt
	
	la $a0, from
	jal printStr
	
	la $a0, 0($a1)
	jal printChar
	
	la $a0, to
	jal printStr
	
	la $a0, 0($a2)
	jal printChar
	
	la $a0, '\n'
	jal printChar
	
	lw $a0, 0($sp)
	lw $ra, 4($sp)

	
	addi $sp, $sp, 8
	jr $ra
	


readInt:
	li $v0, 5
	syscall
	jr $ra
	
# print an integer
# printInt(int n)
printInt:
	li $v0, 1
	syscall
	jr $ra

# print a character
# printChar(char c)
printChar:
	li $v0, 11
	syscall
	jr $ra
	
# print a null-ended string
# printStr(char *s)
printStr:
	li $v0, 4
	syscall
	jr $ra
