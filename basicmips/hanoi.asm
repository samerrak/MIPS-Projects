# TODO: modify the info below
# Student ID: 123456789
# Name: Your Name
# TODO END
########### COMP 273, Winter 2022, Assignment 4, Question 1 - Tower of Hanoi ###########

.data
# TODO: add any variables here you if you need



# TODO END

.text
main:
        # read the integer n from the standard input
	jal readInt
	# now $v0 contains the number of disk n
	
# TODO:
#       Use a recursive algorithm described to print the solution steps. Make sure you follow the output format.
#       You can design any functions you need (e.g., the recurisve procedure described in the handout) and put them in the next TODO block.
#       There are some helper functions for IO at the end of this file, which might be helpful for you.



# TODO END
	
	li $v0, 10	# exit the program
	syscall


# TODO: your functions here




# TODO END


########### Helper functions for IO ###########

# read an integer
# int readInt()
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
