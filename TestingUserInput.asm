	.data
# win/lose text
win_text: .asciiz "Congratulations! You win\n"
lose_text: .asciiz "You lose\n"
inErr: .asciiz "Invalid input\n"
choices_prompt: .asciiz "Choices:\n"
prompt: .asciiz "Enter the number corresponding to the correct game: "
continue_prompt: .asciiz "Continue? (0 = yes, 1 = no)\n"
sep_str: .asciiz " - "
newline: .asciiz "\n"
stack: .word 0:99 # initialize a stack of 99 32 bit spaces to 0 value
stack_bot: # initialize stack_bot to the next available address (end of stack)

# Idea to put these strings behind labels came from this
# reddit post: https://www.reddit.com/r/learnprogramming/comments/75cbqu/mips_assembly_how_do_i_print_a_string_from_an/
ZeldaStr: .asciiz "Zelda\n"
MetroidStr: .asciiz "Metroid\n"
MarioStr: .asciiz "Mario\n"
DigDugStr: .asciiz "Dig Dug\n"
GalagaStr: .asciiz "Galaga\n"
DKStr: .asciiz "Donkey Kong Jr.\n"
KIStr: .asciiz "Kid Icarus\n"
CastleStr: .asciiz "Castlevania\n"
KirbyStr: .asciiz "Kirby's Adventure\n"
TecmoStr: .asciiz "Tecmo Bowl\n"

AnswerChoices: # 0-4 are actually represented in code, others are distractors
	.word ZeldaStr # 0
	.word MetroidStr # 1
	.word MarioStr # 2
	.word DigDugStr # 3
	.word GalagaStr # 4
	.word DKStr # 5
	.word KIStr # 6
	.word CastleStr # 7
	.word KirbyStr # 8
	.word TecmoStr # 9

maxGameIndex: .word 4 # upper limit index of games array
choiceGames: .word 9 # upper limit index of choices array

	.text
la $sp, stack_bot # init stack bottom
jal InitRand

# Start main
li $a0, 0 # answer
jal TestUser

Exit: li $v0, 10 # exit program call
	syscall
	
TestUser:
	# Prompts and checks user input against $a0 correct string
	# $a0 - correct answer index
	##########################################################
	move $t0, $a0 # Save $a0 so we don't overwrite in syscalls

### Print choices section
	# print choices prompt prompt
	li $v0, 4 # print str service
	la $a0, choices_prompt # load in prompt
	syscall # show user the prompt
	
	# Get the location to display the correct answer at
	# push t0 and ra on stack before getting random
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $ra, 4($sp)
	li $a0, 3 # upper limit of random to generate
	jal GetRandom
	lw $ra, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 8 # pop t0 an ra off stack
	move $t3, $v0 # t3 = index to display the correct choice at
	
	# Print choices list
	li $t1, 4 # set number of choices to get
	move $t2, $zero # set choice number to display
gcloop: # get and display choices loop
	# display this iteration's number
	li $v0, 1 # print int service
	move $a0, $t2 # copy t2 into a0 to display it
	syscall # print choice
	
	# print separator string
	la $a0, sep_str
	li $v0, 4 # print str service
	syscall # print separator string

	# check if we're at index chosen to display correct answer at
	beq $t2, $t3, prepCorrAns # jump to prepping to display correct answer

	# save t0, t1, t2, t3 and ra before getting new random
	addi $sp, $sp, -20
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $ra 16($sp)
	
	lw $a0, choiceGames # load in upper limit of random int to generate
	jal GetRandom # v0 has new random num
	
	# reload t0, t1, t2, t3 and ra
	lw $ra, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 12 # pop vars off stack
	j getChoice # if we're here we don't want to display correct answer this time around
	
prepCorrAns: move $v0, $t0 # move correct answer index into v0 so we can index into AnswerChoices like normal

getChoice: la $a0, AnswerChoices # load in array of choice variables
	sll $t4,$v0, 2 # calculate offset, t4 = index * 4 (bytes)
	add $a0, $a0, $t4 # choice str location = base + offset
	lw $a0, 0($a0) # load addr of string
displayChoice: li $v0, 4 # print str service
	syscall # print choice string
	
	subi $t1, $t1, 1 # decrement number of choices displayed
	addi $t2, $t2, 1 # increment choice 
	bnez $t1, gcloop # reloop if more choices to generate and display
	
	# Otherwise:
	# print user entry prompt
	li $v0, 4 # print str service
	la $a0, choices_prompt # load in prompt
	syscall # show user the prompt
	
### Get input and test against it
testloop: # get input integer from user
	li $v0, 5 # read int service
	syscall # read int from user into v0
	# Check if input is valid
	bgt $v0, 3, userInputErr # if user entered num too large
	bltz $v0, userInputErr # also handle error of entering neg num
	# Otherwise compare t0 with input, v0
	bne $t0, $v0, failInput # if the number in seq, $t3 doesn't match input $t2
	
	beq $t0, $v0, successInput # if user entered correct choice, display congratulatory message
				   
userInputErr: la $a0, inErr # load input error string
	li $v0, 4 # load print str service
	syscall # print error string
	
	j testloop # if user entered invalid choice, to back to top loop

### Display message based on if entry correct
successInput: # Clear screen for next round of numbers to test

	# store ra on stack
	addi $sp, $sp, -4 # allocate space for 4 addresses on stack
	sw $ra, 0($sp) # store $ra on stack
	
	jal ClearUserInput # clear input screen for next message iteration
	
	# restore temp vars and ra from stack
	lw $ra, 0($sp) # load $ra back
	addi $sp, $sp, 4 # increment stack pointer to top of valid area
	
	# display success message
	li $v0, 4 # print str service
	la $a0, win_text # load win text
	syscall # display congrats message
	j endTestUser # jump over failInput to exit procedure
	
failInput: li $v0, 4 # load print str service
	la $a0, lose_text # load lose text
	syscall # print lose text
endTestUser: jr $ra # return from procedure


InitRand:
	# Initializes 1 random number generator with
	# the bottom 32 bits of the current time in ms
	# no return value
	####################
	# Get seed value
	li $v0, 30 # load in system time service
	syscall # $a0 has bottom 32 bits of current time in ms
	move $a1, $a0 # set seed for rand num gen $a1, to bottom 32 bits of current time in ms
	li $a0, 0 # set the random number generator id = 0
	li $v0, 40 # load random number seed setting service
	syscall # set seed for random num gen id = 0 to value in $a1 = bot 32 bits of curr time in ms 
	jr $ra # return from procedure
	
GetRandom:
	# Returns in $v0 random number
	# $a0 = upper range limit of number to generate
	# $v0 = random number generated
	# Get random number
	####################
	li $v0, 42 # load rand # generator
	move $a1, $a0 # move upper limit into a1 before we overwrite a0
	li $a0, 0 # load in rand num generator id = 0
	syscall # generate number from 0 - 4 inclusive and put in $a0
	move $v0, $a0 # set $v0 to $a0
	
	jr $ra # return from procedure
	

ClearUserInput: # taken from Lab 6 part 2
	# prints 20 newlines to clear the user input window
	####################################################
	li $t0, 20 # load number of newline to clear input window
	la $a0, newline # load newline into memory to print
	li $v0, 4 # load print str service
clearinputloop: syscall # print newline
	subi $t0, $t0, 1 # decrement loop counter
	bgtz $t0, clearinputloop # reloop to print newline if haven't printed 20 yet
	# otherwise:
	jr $ra # return from procedure