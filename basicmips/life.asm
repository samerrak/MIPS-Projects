# TODO: modify the info below
# Student ID: 123456789
# Name: Your Name
# TODO END
########### COMP 273, Winter 2022, Assignment 4, Question 2 - Game of Life ###########

.data
# You should use following two labels for opening input/output files
# DO NOT change following 2 lines for your submission!
inputFileName:	.asciiz	"life-input.txt"
outputFileName:	.asciiz "life-output.txt"
# TODO: add any variables here you if you need



# TODO END

.text
main:
	# read the integer n from the standard input
	jal readInt
	# now $v0 contains the number of generations n you should simulate
	
# TODO: your code in main process here



# TODO END
	
	li $v0, 10	# exit the program
	syscall


# TODO: your helper functions here




# TODO END

########### Helper functions for IO ###########

# read an integer
# int readInt()
readInt:
	li $v0, 5
	syscall
	jr $ra