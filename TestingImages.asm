	.data
# to hold base address of heap
heapbase: .word 0x10040000 # address of base of heap connected to Bitmap Display
# stack vars
stack: .word 0:99 # initialize a stack of 99 32 bit spaces to 0 value
stack_bot: # initialize stack_bot to the next available address (end of stack)


ZeldaSong: # Table to hold tones to play Zelda theme
	# Format: tone, ms to play
	.word 9, 1500
	.word 4, 250
	.word 4, 250
	.word 9, 250
	.word 7, 150
	.word 6, 150
	.word 7, 1500
	.word 9, 1500
	.word 5, 250
	.word 5, 250
	.word 9, 250
	.word 8, 150
	.word 6, 150
	.word 8, 1500

ZeldaSongNotes: .word 14

ZeldaSymbol: # info to draw the Zelda symbol - 3 triangles stacked into a triangle shape
	# format: starting X, starting Y, Color, base length
	# bot left triangle:
	.word 7, 20, 6, 9 # bot left triangle: X = 4, Y = 30, color = yellow, 9 pixel base
	.word 8, 19, 6, 7 # length is 2 less than layer below it and move one unit right
	.word 9, 18, 6, 5 # yellow 5 len
	.word 10, 17, 6, 3 # yellow 3 len
	.word 11, 16, 6, 1 # yellow 1 len
	# bot right triangle
	.word 16, 20, 6, 9 # yellow 9 len
	.word 17, 19, 6, 7 # yellow 7 len
	.word 18, 18, 6, 5 # yellow 5 len
	.word 19, 17, 6, 3 # yellow 3 len
	.word 20, 16, 6, 1 # yellow 1 len
	# top triangle
	.word 12, 15, 6, 9 # yellow len 9
	.word 13, 14, 6, 7 # yellow len 7
	.word 14, 13, 6, 5 # yellow 5 len
	.word 15, 12, 6, 3 # yellow 3 len
	.word 16, 11, 6, 1 # yellow 1 len
	
ZeldaSymbolLen: .word 15 # number of elements in higher-order array of ZeldaSymbol

Zelda: # hold addresses of data containing how to play Zelda song
	.word ZeldaSong, ZeldaSongNotes, DrawZeldaSymbol

ColorTable: # 0-7 array indices
	.word 0x000000 # 0 - black
	.word 0x0000ff # 1 - blue
	.word 0x00ff00 # 2 - green
	.word 0xff0000 # 3 - red
	.word 0x00ffff # 4 - blue + green
	.word 0xff00ff # 5 - blue + red (purple)
	.word 0xffff00 # 6 - green + red (yellow)
	.word 0xffffff # 7 - white
	.word 0x996611 # 8 - mario brown - gotten from the web: https://www.color-hex.com/color-palette/3370
	.word 0xffd987 # 9 - mario skin - gotten from the web: https://www.schemecolor.com/super-mario.php

	.text	
# Program start
la $t0, Zelda # load game to hint at
lw $t1, 8($t0) # load address of procedure to run for drawing the symbol
jalr $t1 # jump to address of procedure to draw symbol

Exit: li $v0, 10 # exit program call
	syscall


DrawZeldaSymbol:
	# Draws the symbol to hint at Zelda
	##################
	la $t0, ZeldaSymbol # load symbol info
	lw $t1, ZeldaSymbolLen # load number of Zelda Symbol elements
zsymLoop: # loop to ensure all 3 shapes are drawn
	# save ra, $t0 and $t1 to stack before we call DrawTriangle
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $ra, 8($sp)
	
	lw $a0, 0($t0) # load this Symbol X addr
	lw $a1, 4($t0) # load this symbol Y addr
	lw $a2, 8($t0) # load this symbol color index
	lw $a3, 12($t0) # load base length
	jal HorizLine
	
	# reload ra, t0 and t1 from stack
	lw $ra, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp,12 # pop t0 and t1 off stack
	
	addi $t0, $t0, 16 # go to next symbol in array - 4 words past current start spot
	subi $t1, $t1, 1 # decrement num symbols left to draw
	bnez $t1, zsymLoop # draw next symbol piece if not done
	
	jr $ra # return from proc
	

HorizLine:
	# Draws a horizontal line
	# $a0 - x coord (0-32)
	# $a1 - y coord (0-32)
	# $a2 - color num (0-7)
	# $a3 - length of line (1-32)
	#############################
horizloop: # Save stack
	addi $sp, $sp, -20 # get space for ra and a regs
	sw $a0, 0($sp) # store $a0
	sw $a1, 4($sp) # store $a1
	sw $a2, 8($sp) # store $a2
	sw $a3, 12($sp) # store $a3
	sw $ra, 16($sp) # store ra
	
	jal DrawDot # repeatedly call DrawDot
	
	# Restore saved stack regs
	lw $ra, 16($sp) # restore ra
	lw $a3, 12($sp) # restore $a3
	lw $a2, 8($sp) # restore $a2
	lw $a1, 4($sp) # restore $a1
	lw $a0, 0($sp) # restore $a0
	addi $sp, $sp, 20 # move pointer to open space for ra and a regs
	
	addi $a0, $a0, 1 # increment X coord, $a0, by 1
	subi $a3, $a3, 1 # decrement lines left, $a3
	bgtz $a3, horizloop # restart loop if $a3 > 0
	
	jr $ra # return from procedure


VertLine:
	# Draws a vertical line
	# $a0 - x coord (0-31)
	# $a1 - y coord (0-31)
	# $a2 - color num (0-7)
	# $a3 - length of line (1-32)
	#############################
vertloop: # Save stack
	addi $sp, $sp, -20 # get space for ra and a regs
	sw $a0, 0($sp) # store $a0
	sw $a1, 4($sp) # store $a1
	sw $a2, 8($sp) # store $a2
	sw $a3, 12($sp) # store $a3
	sw $ra, 16($sp) # store ra
	jal DrawDot # repeatedly call DrawDot
	# Restore saved stack regs
	lw $ra, 16($sp) # restore ra
	lw $a3, 12($sp) # restore $a3
	lw $a2, 8($sp) # restore $a2
	lw $a1, 4($sp) # restore $a1
	lw $a0, 0($sp) # restore $a0
	addi $sp, $sp, 20 # move pointer to open space for ra and a regs
	addi $a1, $a1, 1 # decrement Y coord, $a0, by 1
	subi $a3, $a3, 1 # decrement lines left, $a3
	bgtz $a3, vertloop # restart loop if $a3 > 0
	
	jr $ra # return from procedure

	
DrawDot:
	# Draws a dot on the Bitmap
	# $a0 - x coord (0-32)
	# $a1 - y coord (0-32)
	# $a2 - color number (0-7)
	##########################
	# Calc addr to draw dot at - store in $t0
	addi $sp, $sp, -16 # get space for 4 addr to store
	sw $a0, 0($sp) # save $a0
	sw $a1, 4($sp) # save $a1
	sw $a2, 8($sp) # save $a2
	sw $ra, 12($sp) # save ra
	
	jal CalcAddr # calc addr to draw dot at - saves in $v0
	move $t0, $v0 # save addr to draw dot at in $t0
	
	lw $ra, 12($sp) # load back ra
	# load back args
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 16 # move pointer to first valid space
	
	# Get color value - store in $t1
	addi $sp, $sp, -20 # get space for ra and $t0 addr to draw dot at
	sw $t0, 0($sp) # save $t0
	# save args
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	# save ra 
	sw $ra, 16($sp) # save ra of this proc
	
	move $a0, $a2 # load in color to fetch value of to $a0
	jal GetColor
	move $t1, $v0 # save color value fetched in t1
	
	lw $ra, 16($sp) # load ra
	# load ars
	lw $a2, 12($sp)
	lw $a1, 8($sp)
	lw $a0, 4($sp)
	lw $t0, 0($sp) # load addr to draw dot at
	addi $sp, $sp, 20 # move pointer to first valid stack memory place
	
	# Store color value at correct memory location
	sw $t1, 0($t0) # store color in $t1 inside $t0 (addr in Bitmap)

	# Return
	jr $ra # return from procedure		

	
GetColor:
	# Returns color value in hex corresponding to color to display
	# $a0 - accepts color number between 0-7 corresponding to color in ColorTable
	# $v0 - actual number to write to display (in hex)
	##################################################
	la $t0, ColorTable # load base
	sll $a0, $a0, 2 # offset = index input x4
	add $a0, $t0, $a0 # get addr of color = base + offset
	lw $v0, 0($a0) # get color from ColorTable ($a0) and set return value $v0
	jr $ra # return from procedure
	

CalcAddr:
	# Converts X,Y coordinates to address corresponding to
	# point on Bitmap Display
	# $a0 - X coord (0-32)
	# $a1 - Y coord (0-32)
	# $v0 - addr corresponding to X,Y
	#################################
	lw $t0, heapbase # load in base address of heap connected to Bitmap Display
	move $v0, $t0 # copy base addr into $v0 return var
	# move to correct column
	sll $a0, $a0, 2 # multiply X addr by 4 to move one word (size of addr) for each X value
	add $v0, $v0, $a0 # add X addr to base to shift to right required amount
	# move to correct row and column in Bitmap display
	sll $a1, $a1, 5 # multiply Y addr by 32 to move to next row in Bitmap
	sll $a1, $a1, 2 # multiply Y addr by 4 to move to correct column in Bitmap
	add $v0, $v0, $a1 # add Y addr calculated, to return val 
	jr $ra # return from procedure
