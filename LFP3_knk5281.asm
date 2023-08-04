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
audioclue_times: .word 2 # 3 times to play audio clue

correct_ans_choices: .word 0:4 # we only allow 4 choices to be displayed so have 4 slots to hold in case only correct answer displayed
num_corr_choices: .word 0 # hold current number of correct answer choices
# to hold base address of heap
heapbase: .word 0x10040000 # address of base of heap connected to Bitmap Display
# stack vars
stack: .word 0:99 # initialize a stack of 99 32 bit spaces to 0 value
stack_bot: # initialize stack_bot to the next available address (end of stack)

### Audio Variables and tables
# Game Song Tones table
MasterTonesTable: # 0- array indices
	# every 4 notes there is an index which corresponds
	# to what will be input to the tone getting function (indexed from 1)
	# Only storing notes that are actually played in one of the songs at least once
	.word 42 # F#2/Gb2 - 1
	.word 43 # G2
	.word 52 # E3 
	.word 53 # F3 - 4
	.word 54 # F#3/Gb3
	.word 55 # G3
	.word 56 # G#3/Ab3
	.word 57 # A3 - 8
	.word 58 # A#3/Bb3
	.word 59 # B3
	.word 60 # C4
	.word 62 # D4 - 12
	.word 63 # D#4/Eb4
	.word 64 # E4
	.word 65 # F4
	.word 66 # F#4/Gb4 - 16
	.word 67 # G4
	.word 68 # G#4/Ab4
	.word 69 # A4
	.word 70 # A4#/B4b - 20
	.word 71 # B4
	.word 72 # C5
	.word 73 # C#5/Db5
	.word 74 # D5 - 24
	.word 76 # E5
	.word 79 # G5
	.word 81 # A5
	.word 83 # B5 - 28
	
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

Zelda: # hold addresses of data containing Zelda hint info: Song notes, num of notes, and address of procedure to draw visual hint
	.word ZeldaSong, ZeldaSongNotes, DrawHorizSymbol, ZeldaVisual
	
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

ZeldaVisual: .word ZeldaSymbol, ZeldaSymbolLen # holds addrs of symbol table and its length

MetroidSong: # Table to hold tones to play Metroid theme
	# Format: tone, ms to play
	.word 11, 1250
	.word 6, 400
	.word 9, 900
	.word 8, 100
	.word 9, 100
	.word 8, 100
	.word 4, 150

MetroidSongNotes: .word 7
	
MetroidSymbol: # info to draw the Metroid symbol
	# format: starting X, starting Y, Color, horiz line length
	# drawing Samus helmet from top down:
	.word 15, 8, 3, 2 # X = 15, Y = 8, color = red, 2 horiz line len
	# 2nd layer
	.word 13, 9, 3, 2 # X = 13, Y = 9, color = red, 3 horiz line len
	.word 15, 9, 6, 2 # X = 15, Y = 9, color = yellow, 2 horiz line len
	.word 17, 9, 3, 2 # X = 17, Y = 9, color = red, 3 horiz line len
	# 3rd layer
	.word 12, 10, 3, 1 # X = 12, Y = 10, color = red, 1 horiz line len
	.word 13, 10, 2, 1 # X = 13, Y = 10, color = green, 1 horiz line len
	.word 14, 10, 3, 4 # X = 14, Y = 10, color = red, 4 horiz line len
	.word 18, 10, 2, 1 # X = 18, Y = 10, color = green, 1 horiz line len
	.word 19, 10, 3, 1 # X = 19, Y = 10, color = red, 1 horiz line len
	# 4th layer
	.word 12, 11, 2, 1 # X = 12, Y = 11, color = green, 1 horiz line len
	.word 13, 11, 6, 1 # X = 13, Y = 11, color = yellow, 1 horiz line len
	.word 14, 11, 2, 1 # X = 14, Y = 11, color = green, 1 horiz line len
	.word 15, 11, 3, 2 # X = 15, Y = 11, color = red, 2 horiz line len
	.word 17, 11, 2, 1 # X = 17, Y = 11, color = green, 1 horiz line len
	.word 18, 11, 6, 1 # X = 18, Y = 11, color = yellow, 1 horiz line len
	.word 19, 11, 2, 1 # X = 19, Y = 11, color = green, 1 horiz line len
	# 5th layer
	.word 11, 12, 3, 1 # X = 11, Y = 12, color = red, 1 horiz line
	.word 12, 12, 2, 2 # X = 12, Y = 12, color = green, 2 horiz line
			   # getting tedious so only listing color and line len from now on
	.word 14, 12, 6, 1 # yellow, 1 len
	.word 15, 12, 2, 2 # green 2 len
	.word 17, 12, 6, 1 # yellow 1 len
	.word 18, 12, 2, 2 # green 2 len
	.word 20, 12, 3, 1 # red 1 len
	# 6th layer
	.word 11, 13, 3, 1 # red 1 len
	.word 12, 13, 2, 1 # green 1 len
	.word 13, 13, 0, 1 # black 1 len
	.word 14, 13, 2, 4 # green 4 len
	.word 18, 13, 0, 1 # black 1 len
	.word 19, 13, 2, 1 # green 1 len
	.word 20, 13, 3, 1 # red 1 len
	# 7th layer
	.word 11, 14, 3, 3 # red 3 len
	.word 14, 14, 0, 1 # black 1 len
	.word 15, 14, 2, 2 # green 2 len
	.word 17, 14, 0, 1 # black 1 len
	.word 18, 14, 3, 3 # red 3 len
	# 8th layer
	.word 12, 15, 0, 1 # black 1 len
	.word 13, 15, 3, 2 # red 2 len
	.word 15, 15, 0, 2 # black 2 len
	.word 17, 15, 3, 2 # red 2 len
	.word 19, 15, 0, 1 # black 1 len
	# 9th layer
	.word 13, 16, 2, 1 # green 1 len
	.word 14, 16, 3, 1, # red 1 len
	.word 15, 16, 0, 2 # black 2 len
	.word 17, 16, 3, 1 # red 1 len
	.word 18, 16, 2, 1 # green 1 len
	# 10th layer
	.word 14, 17, 2, 1 # green 1 len
	.word 15, 17, 3, 2 # red 2 len
	.word 17, 17, 2, 1 # green 1 len
	
MetroidSymbolLen: .word 48 # number of elements in higher-order array of MetroidSymbol

MetroidVisual: .word MetroidSymbol, MetroidSymbolLen # addrs of symbol table and its length

Metroid: # hold addresses of data containing how to play Zelda song
	.word MetroidSong, MetroidSongNotes, DrawHorizSymbol, MetroidVisual

MarioSong: # Table to hold tones to play Metroid theme
	# Format: tone, ms to play
	.word 11, 500
	.word 6, 500
	.word 3, 500
	.word 8, 250 # fourth note
	.word 10, 250
	.word 9, 150
	.word 8, 250
	.word 6, 250 # eighth note
	.word 14, 250
	.word 17, 250
	.word 19, 250
	.word 15, 140 # twelth note
	.word 17, 140
	.word 14, 250
	.word 11, 150
	.word 12, 150 # sixteenth note
	.word 10, 250

MarioSongNotes: .word 17

MarioSymbol: # info to draw the Zelda symbol - 3 triangles stacked into a triangle shape
	# format: starting X, starting Y, Color, horiz line length
	# drawing Samus helmet from top down:
	.word 15, 8, 3, 5 # X = 15, Y = 8, color = red, 5 line len
	# 2nd layer
	.word 14, 9, 3, 9 # X = 14, Y = 9, color = red, 9 horiz line len
	# 3rd layer
	.word 14, 10, 8, 3 # X = 14, Y = 10, color = mario brown, 3 horiz line len
	.word 17, 10, 9, 2 # X = 17, Y = 10, color = mario skin, 2 horiz line len
	.word 19, 10, 8, 1 # X = 19, Y = 10, color = mario brown, 1 horiz line len
	.word 20, 10, 9, 1 # X = 20, Y = 10, color = mario skin, 1 horiz line len
	# 4th layer
	.word 13, 11, 8, 1 # X = 13, Y = 11, color = mario brown, 1 horiz line len
	.word 14, 11, 9, 1 # X = 14, Y = 11, color = mario skin, 1 horiz line len
	.word 15, 11, 8, 1 # X = 15, Y = 11, color = mario brown, 1 horiz line len
	.word 16, 11, 9, 3 # X = 16, Y = 11, color = mario skin, 3 horiz line len
	.word 19, 11, 8, 1 # X = 19, Y = 11, color = mario brown, 1 horiz line len
	.word 20, 11, 9, 3 # X = 20, Y = 11, color = mario skin, 3 horiz line len
	# 5th layer
	# getting tedious so only listing color and line len from now on
	.word 13, 12, 8, 1 # mario brown 1  len
	.word 14, 12, 9, 1 # mario skin, 1 len
	.word 15, 12, 8, 2 # mario brown, 2 len
	.word 17, 12, 9, 3 # mario skin, 3 len
	.word 20, 12, 8, 1 # mario brown, 1 len
	.word 21, 12, 9, 3 # mario skin, 3 len
	# 6th layer
	.word 13, 13, 8, 2 # mario brown 2 len
	.word 15, 13, 9, 4 # mario skin 4 len
	.word 19, 13, 8, 4 # mario brown 4 len
	# 7th layer
	.word 15, 14, 9, 7 # mario skin 7 len
	
MarioSymbolLen: .word 22 # number of elements in higher-order array of MarioSymbol

MarioVisual: .word MarioSymbol, MarioSymbolLen # holds addrs for symbol table and its length

Mario: # hold addresses of data containing how to play Mario song 
	.word MarioSong, MarioSongNotes, DrawHorizSymbol, MarioVisual

DigDugSong: # Table to hold tones to play Metroid theme
	# Format: tone, ms to play
	.word 16, 150
	.word 17, 150
	.word 17, 150
	.word 17, 150 # fourth note
	.word 5, 150
	.word 6, 150
	.word 6, 150
	.word 6, 150 # eighth note
	.word 1, 150
	.word 2, 150
	.word 2, 150
	.word 2, 300 # twelth note
	.word 26, 150
	.word 26, 150
	.word 26, 150
	.word 26, 300 # sixteenth note
	.word 25, 300
	.word 26, 150
	.word 25, 300
	.word 26, 150 # 20th note
	.word 27, 150
	.word 25, 150
	.word 25, 150
	.word 25, 300 # 24th note
	.word 24, 150
	.word 22, 300
	.word 23, 300
	.word 17, 300 # 28th note
	.word 23, 150
	.word 17, 300
	.word 23, 300
	.word 24, 150 # 32nd note
	.word 24, 150
	.word 24, 600

DigDugSongNotes: .word 34

DigDugSymbol: # info to draw the Zelda symbol - 3 triangles stacked into a triangle shape
	# format: starting X, starting Y, Color, horiz line length
	# drawing Samus helmet from top down:
	.word 13, 8, 3, 7 # X = 15, Y = 8, color = red, 7 line len
	# 2nd layer
	.word 12, 9, 3, 2 # X = 14, Y = 9, color = red, 2 horiz line len
	# getting tedious so only listing color and line len from now on
	.word 14, 9, 6, 8 # yellow 9 line len
	# 3rd layer
	.word 11, 10, 3, 2 # red 2 len
	.word 13, 10, 6, 2 # yellow 2 len
	.word 15, 10, 7, 6 # white 6 len
	.word 21, 10, 6, 2 # yellow 2 len
	# 4th layer
	.word 11, 11, 6, 3 # yellow 3 len
	.word 14, 11, 7, 3 # white 3 len
	.word 17, 11, 0, 1 # black 1 len
	.word 18, 11, 7, 2 # white 2 len
	.word 20, 11, 0, 1 # black 1 len
	.word 21, 11, 7, 1 # white 1 len
	.word 22, 11, 6, 1 # yellow 1 len
	# 5th layer
	.word 11, 12, 6, 3 # yellow 3 len
	.word 14, 12, 7, 3 # white 3 len
	.word 17, 12, 0, 1 # black 1 len
	.word 18, 12, 7, 2 # white 2 len
	.word 20, 12, 0, 1 # black 1 len
	.word 21, 12, 7, 1 # white 1 len
	.word 22, 12, 6, 1 # yellow 1 len
	# 6th layer
	.word 11, 13, 3, 2 # red 2 len
	.word 13, 13, 6, 2 # yellow 2 len
	.word 15, 13, 7, 4 # white 4 len
	.word 19, 13, 6, 1 # yellow 1 len
	.word 20, 13, 7, 2 # white 2 len
	.word 22, 13, 6, 1 # yellow 1 len
	# 7th layer
	.word 10, 14, 7, 1 # white 1 len
	.word 11, 14, 3, 3 # red 3 len
	.word 14, 14, 6, 9 # yellow 8 len
	# 8th layer
	.word 10, 15, 7, 1 # white 1 len
	.word 11, 15, 0, 1 # black 1 len
	.word 12, 15, 3, 3 # red 2 len
	.word 15, 15, 6, 3 # yellow 3 len
	.word 18, 15, 3, 2 # red 2 len
	.word 20, 15, 6, 2 # yellow 2 len
	.word 22, 15, 3, 1 # red 1 len
	# 9th layer
	.word 10, 16, 7, 3 # white 3 len
	.word 13, 16, 3, 9 # red 10 len
	# 10th layer
	.word 13, 17, 3, 1 # red 1 len
	.word 14, 17, 6, 1 # yellow 1 len
	.word 15, 17, 3, 4 # red 4 len
	.word 19, 17, 6, 1 # yellow 1 len
	.word 20, 17, 3, 1 # red 1 len
	# 11th layer
	.word 14, 18, 6, 1 # yellow 1 len
	.word 19, 18, 6, 1 # yellow 1 len
	# 12th layer
	.word 13, 19, 6, 4 # yellow 4 len
	.word 18, 19, 6, 4 # yellow 4 len
	
DigDugSymbolLen: .word 48 # number of elements in higher-order array of DigDugSymbol

DigDugVisual: .word DigDugSymbol, DigDugSymbolLen

DigDug: # hold addresses of data containing how to play Dig Dug song 
	.word DigDugSong, DigDugSongNotes, DrawHorizSymbol, DigDugVisual

GalagaSong: # Table to hold tones to play Metroid theme
	# Format: tone, ms to play
	.word 14, 300
	.word 11, 100
	.word 12, 300
	.word 15, 100 # fourth note
	.word 14, 300
	.word 11, 100
	.word 12, 300
	.word 19, 100 # eighth note
	.word 17, 300
	.word 11, 100
	.word 12, 300
	.word 15, 100 # twelth note
	.word 14, 300
	.word 11, 100 
	.word 12, 300
	.word 21, 100 # sixteenth note 
	.word 22, 300
	.word 20, 100 
	.word 18, 300 
	.word 17, 100 # 20th note
	.word 15, 300
	.word 13, 100 
	.word 13, 300 
	.word 12, 100 # 24th note 
	.word 13, 300 
	.word 15, 100
	.word 10, 300 
	.word 11, 100 # 28th note
	.word 19, 150
	.word 15, 150 
	.word 12, 150
	.word 17, 150 # 32nd note
	.word 14, 150
	.word 12, 150

GalagaSongNotes: .word 34

GalagaSymbol: # info to draw the Zelda symbol - 3 triangles stacked into a triangle shape
	# format: starting X, starting Y, Color, horiz line length
	# drawing Samus helmet from top down:
	# the format is already well established and its tedious to write
	# each format next to each line. Only the first line is commented fully
	# the rest display only line len and color
	# 1st layer
	.word 7, 19, 3, 2 # X = 7, Y = 19, color = red, 2 line len
	.word 7, 21, 7, 6 # white and 5 len
	# 2nd layer
	.word 8, 23, 7, 3 # white 3 len
	# 3rd layer
	.word 9, 5, 1, 1 # blue 2 len - part of laser
	.word 9, 22, 7, 3 # white 3 len
	# 4th layer
	.word 10, 4, 1, 1 # blue 2 len - part of laser
	.word 10, 5, 7, 1 # white 1 len -part of laser
	.word 10, 6, 3, 2 # red 3 len - part of laser
	.word 10, 17, 3, 2 # red 2 len
	.word 10, 19, 7, 1 # white 2 len
	.word 10, 20, 1, 1 # blue 1 len
	.word 10, 21, 7, 3 # white 3 len
	# 5th layer
	.word 11, 5, 1, 1 # blue 1 len - part of laser
	.word 11, 19, 1, 1 # blue 1 len
	.word 11, 20, 7, 4 # white 4 len
	.word 11, 24, 3, 2 # red 2 len
	# 6th layer
	.word 12, 18, 7, 5 # white 4 len
	.word 12, 23, 3, 3 # red 3 len
	# 7th layer
	.word 13, 14, 7, 6 # white 8 len
	.word 13, 20, 3, 2 # red 2 len
	.word 13, 22, 7, 3 # white 3 len
	# 8th layer
	.word 14, 11, 7, 8 # white 8 len
	.word 14, 19, 3, 2 # red 2 len
	.word 14, 21, 7, 6 # white 6 len
	# 9th layer
	.word 15, 14, 7, 6 # white 8 len
	.word 15, 20, 3, 2 # red 2 len
	.word 15, 22, 7, 3 # white 3 len
	# 10th layer
	.word 16, 18, 7, 5 # white 4 len
	.word 16, 23, 3, 3 # red 3 len
	# 11th layer
	.word 17, 19, 1, 1 # blue 1 len
	.word 17, 20, 7, 4 # white 4 len
	.word 17, 24, 3, 2 # red 2 len
	# 12th layer
	.word 18, 17, 3, 2 # red 2 len
	.word 18, 19, 7, 1 # white 2 len
	.word 18, 20, 1, 1 # blue 1 len
	.word 18, 21, 7, 3 # white 3 len
	# 13nd layer
	.word 19, 22, 7, 3 # white 3 len
	# 14rd layer
	.word 20, 23, 7, 3 # white 3 len
	# 15th layer
	.word 21, 19, 3, 2 # red 2 len
	.word 21, 21, 7, 6 # white and 5 len
	
GalagaSymbolLen: .word 40 # number of elements in higher-order array of GalagaSymbol

GalagaVisual: .word GalagaSymbol, GalagaSymbolLen

Galaga: # hold addresses of data containing how to play Galaga song 
	.word GalagaSong, GalagaSongNotes, DrawVertSymbol, GalagaVisual
	
## Graphics variables and tables
# Colors table
ColorTable: # 0-7 array indices
	.word 0x000000 # black
	.word 0x0000ff # blue
	.word 0x00ff00 # green
	.word 0xff0000 # red
	.word 0x00ffff # blue + green
	.word 0xff00ff # blue + red (purple)
	.word 0xffff00 # green + red (yellow)
	.word 0xffffff # white
	.word 0x996611 # 8 - mario brown - gotten from the web: https://www.color-hex.com/color-palette/3370
	.word 0xffd987 # 9 - mario skin - gotten from the web: https://www.schemecolor.com/super-mario.php

# Table for games information
Games: # 0-4 indices
	.word Zelda
	.word Metroid
	.word Mario
	.word DigDug
	.word Galaga
	
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
# Main program start
	jal Init # initialize starting state of basic vars
	# Generate random choice from valid games
triviaLoop: lw $a0, maxGameIndex # load 4 as upper index
	jal GetRandom # Get next game to show - v0 has index 0-4
	
	move $a0, $v0 # set a0 to index generated in v0
	# save a0 index of game onto stack
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	jal PromptGame # draw hint and play hint
	lw $a0, 0($sp) # reload a0 but dont pop
	# Prompt user with input choices - don't resave a0
	jal TestUser # test the user by displaying prompt in console
	
	# reload a0
	lw $a0, 0($sp)
	addi $sp, $sp, 4 # pop a0 off stack
	
	# prompt user to continue or not
continueLoop: la $a0, continue_prompt # load continue question prompt
	li $v0, 4 # print str service
	syscall # print prompt
	
 	li $v0, 5 # read in answer
 	syscall # read in user answer
 	# check for invalid input
	bgt $v0, 1, printErr # invalid answer
	bltz $v0, printErr # invalid answer
	j checkCont # otherwise check what answer they gave
printErr: li $v0, 4 # print service
	la $a0, inErr # load error message
	syscall # print error
	
	j continueLoop # re-loop to ask for input
	
	
	
checkCont: 
	# Clear user input regardless of continue answer
	# save v0 to stack before clearing display
	addi $sp, $sp, -4
	sw $v0, 0($sp)
	jal ClearUserInput
	lw $v0, 0($sp)
	addi $sp, $sp, 4 # pop v0 off stack
	beqz $v0, triviaLoop # if = 0 reloop the game
	# otherwise:
	# jump to Exit because user opted not to continue
	j Exit # 

Exit: li $v0, 10 # exit program call
	syscall


# Procedures start
#### Taken from Lab 7 Part 1
Init:	# Initializes the stack pointer
	# Sets display to all black
	#################
	# Initialize stack
	la $sp, stack_bot # initialize $sp stack pointer var to bottom of stack
	
	# Clear display (newlines entered)
	# Store $ra before initializing display
	addi $sp, $sp, -4 # make room for one word address to be displayed
	sw $ra 0($sp) # store $ra for this procedure
	# initialize display
	jal ClearDisplay
	lw $ra, 0($sp) # load back $ra for this function
	addi $sp, $sp, 4 # move stack pointer back to top of valid memory portion
	
	jr $ra # return from procedure
	
	
ClearDisplay:
	# Sets all pixels in bitmap to black.
	# Does this by drawing black in each 8 bit pixel
	# one row at a time with HorizLine procedure.
	#####################################
	# Initial setup of coords
	li $a0, 0 # X coord starting
	li $a1, 0 # Y coord starting
	li $a2, 0 # load black color index
	li $a3, 32 # set length of lines to draw

cleardisloop: # Save args, t0 and ra on stack
	addi $sp, $sp, -20 # make space for 6 words
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $ra, 16($sp)
	jal HorizLine # draw horizontal line
	# reload and pop args, t0, and ra off stack
	lw $ra, 16($sp)
	lw $a3, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 20 # pop vars off stack
	
	addi $a1, $a1, 1 # increment Y var
	bne $a1, $a3, cleardisloop # reloop if more rows to black out
	
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
	
Pause:
	# pauses program execution
	# $a0 = num ms to wait
	######################
	move $t0, $a0 # set $t0 to ms input to wait
	# Get time now
	li $v0, 30 # load in system time service
	syscall # Get initial time
	move $t1, $a0 # move bottom 32 bits of time into $t1 from $a0
ploop:	syscall # Get current time again
	sub $t2, $a0, $t1 # Subtract current time from initial time and store in $t2
	bltu $t2, $t0, ploop # if haven't reached timeout desired ($t0)
			     # get current time again until timeout reached
	jr $ra # return from procedure	

##### from Lab 7 Part 1 end

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
	
	
PromptGame:
	# Provides prompt clues for game quizzes on.
	# 1. Draws clue on bitmap
	# 2. Plays song 3 times
	# $a0 - index from 0-4 corresponding to 1 of 5 possible games to prompt with
	###############################
	# Get game info
	la $t0, Games # load Game array address
	sll $t1, $a0, 2 # offset = multiply random number returned by 4
	add $t0, $t0, $t1 # address of game to load = Game base addr + offset
	lw $t0, 0($t0) # load game info - array of addresses of arrays of info
	
	# Display visual prompt
	lw $t1, 8($t0) # load addr of drawing proc - 3rd word in array
	
	addi $sp, $sp, -8 # save a0, ra so we can write to args for procedure for drawing
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	
	lw $a0, 12($t0) # load visuals array addr
	# reverse load a1 and a0 because we will need to overwrite a0
	lw $a1, 4($a0) # load symbol table len addr
	lw $a1, 0($a1) # load symbol table len
	lw $a0, 0($a0) # load symbol table addr
	
	jalr $t1 # jump to address of procedure to draw symbol
	
	# reload a0, ra
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8 # pop off stack
	
	# Play audio prompt
	# a0 - index of game to prompt audio with
	addi $sp, $sp, -4 # save ra to stack
	sw $ra, 0($sp)
	# a0 still has index of game to select
	jal AudioClue # play audio clue 3 times
	
	jal ClearDisplay # clear display
	
	lw $ra, 0($sp) # reload ra
	addi $sp, $sp, 4 # pop ra from stack
	
	jr $ra # return from proc


DrawZeldaSymbol:
	# Draws the symbol to hint at Zelda which is the only one that uses DrawTriangle
	# a0 - symbol table for pixels addr
	# a1 - length of symbol table for pixels
	##################
	move $t0, $a0 # move symbol addr to t0 so we don't overwrite it
	move $t1, $a1 # move number of Zelda Symbol elements so we don't overwrite it later
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
	jal DrawTriangle
	
	# reload ra, t0 and t1 from stack
	lw $ra, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp,12 # pop t0 and t1 off stack
	
	addi $t0, $t0, 16 # go to next symbol in array - 4 words past current start spot
	subi $t1, $t1, 1 # decrement num symbols left to draw
	bnez $t1, zsymLoop # draw next symbol piece if not done
	
	jr $ra # return from proc


DrawTriangle:
	# Draws a triangle by successively drawing layers from the bottom.
	# $a0 = starting X coord
	# $a1 = starting Y coord
	# $a2 = color of triangle to draw
	# $a3 = triangle base length
	######################
	j drawTriLoop # jump to drawing first layer
	
dTriLayer: subi $a1, $a1, 1 # move Y start pixel up one
	addi $a0, $a0, 1 # move X start pixel to right by one
drawTriLoop: # Save args, t0, and ra to stack
	addi $sp, $sp, -24
	sw $t0, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	sw $a3, 16($sp)
	sw $ra, 20($sp)
	
	# line length set at top and decreased before reloop
	jal HorizLine # Draw bottom line
	
	# reload args and ra
	lw $ra, 20($sp)
	lw $a3, 16($sp)
	lw $a2, 12($sp)
	lw $a1, 8($sp)
	lw $a0, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 24 # pop off stack
	
	subi $a3, $a3, 2 # decrement length of next layer drawn
	bgtz $a3, dTriLayer # draw next triangle layer if haven't drawn tip of triangle
	
	jr $ra # return from function
	

DrawHorizSymbol:
	# Draws the symbol for hinting at a symbol drawn horizontally layered
	# a0 - symbol table for pixels addr
	# a1 - length of symbol table for pixels
	##################
	move $t0, $a0 # move symbol addr to t0 so we don't overwrite it
	move $t1, $a1 # move number of Zelda Symbol elements so we don't overwrite it later
msymLoop: # loop to ensure all 3 shapes are drawn
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
	bnez $t1, msymLoop # draw next symbol piece if not done
	
	jr $ra # return from proc
	
	
DrawVertSymbol:
	# Draws the symbol for hinting at a symbol drawn vertically layered
	# a0 - symbol table for pixels addr
	# a1 - length of symbol table for pixels
	##################
	move $t0, $a0 # move symbol addr to t0 so we don't overwrite it
	move $t1, $a1 # move number of Zelda Symbol elements so we don't overwrite it later
lsymLoop: # loop to ensure all 3 shapes are drawn
	# save ra, $t0 and $t1 to stack before we call DrawTriangle
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $ra, 8($sp)
	
	lw $a0, 0($t0) # load this Symbol X addr
	lw $a1, 4($t0) # load this symbol Y addr
	lw $a2, 8($t0) # load this symbol color index
	lw $a3, 12($t0) # load base length
	jal VertLine
	
	# reload ra, t0 and t1 from stack
	lw $ra, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp,12 # pop t0 and t1 off stack
	
	addi $t0, $t0, 16 # go to next symbol in array - 4 words past current start spot
	subi $t1, $t1, 1 # decrement num symbols left to draw
	bnez $t1, lsymLoop # draw next symbol piece if not done
	
	jr $ra # return from proc


## End visual procedures
## Audio procedures below
AudioClue:
	# Draws the clue image on bitmap.
	# Loops playing song for 3 iterations after.
	# a0 - index of game to prompt with
	#######################
	lw $t0, audioclue_times # loop counter
	
	# Load the specific game's information
	la $t1, Games # load start addr of games addr
	sll $a0, $a0, 2 # a0*4 = calculate offset to index into Games array
	add $a0, $t1, $a0 # base addr + offset = Game info index addr
	lw $a0, 0($a0) # load the address that points to the addresses of the two song info arrays
	# t1 is free for use now
	
	# Load in song playing args
	# Load a1 and a0 in reverse order because we need to overwrite a0 which holds base addresses of both
	# song info arrays
	lw $a1, 4($a0) # addr of num notes in song = second word addr in array of specific game info
	lw $a1, 0($a1) # load num notes in song
	lw $a0, 0($a0) # load song array start addr = first addr pointed to by address at Games index calculated before loop
	la $a2, MasterTonesTable # song tones table
	
answerloop:
	# Save args, ra, and loop counter to stack
	addi $sp, $sp, -20 # make space
	# save args
	sw $a0, 0($sp) # song notes array start addr
	sw $a1, 4($sp) # num notes in song
	sw $a2, 8($sp) # Master tones table start addr
	# save loop counter
	sw $t0, 12($sp)
	sw $ra, 16($sp)
	
	jal PlaySong
	
	# reload loop counter, ra, and args
	lw $ra, 16($sp)
	lw $t0, 12($sp)
	lw $a2, 8($sp)
	lw $a1, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 20 # move pointer
	
	subi $t0, $t0, 1 # decrement times song played
	beqz $t0, timesup # exit proc if done with allowed time to answer - skipping sleep on last loop
	# Else:
	
	# resave a0 on stack
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	
	# sleep between song plays for at least 2 second
	li $a0, 1000 # set time of tone to our sleep time
	li $v0, 32 # sleep service
	syscall # sleep for duration of tone
	
	# reload a0 from stack and move pointer to pop a0 off stack
	lw $a0, 0($sp)
	addi $sp, $sp, 4 # move pointer to pop a0 now
	
	j answerloop # go back to loop again

timesup: jr $ra # exit proc


PlaySong:
	# Plays a games song
	# $a0 - notes array base addr
	# $a1 - num notes in song
	# $a2 - song MIDI tones table base addr
	###############################
	# keep track of notes left to play in $a1
	
psloop: # have notes left to play
	# Get next tone to play
	
	# Save all args and ra to stack
	addi $sp, $sp, -16 # make room on stack for ra
	sw $a0, 0($sp) # save a0
	sw $a1, 4($sp) # save a1
	sw $a2, 8($sp) # save a2
	sw $ra, 12($sp) # store $ra
	
	move $a1, $a2 # a1 must = tones table base addr for PlayTone so set it here
	jal PlayTone # get tone - result in $v0
	
	lw $ra, 12($sp) # reload ra
	lw $a2, 8($sp) # reload a2
	lw $a1, 4($sp) # reload a1
	lw $a0, 0($sp) # reload a0
	addi $sp, $sp, 16 # move pointer to top of valid stack
	
	subi $a1, $a1, 1 # Decrement number of notes left bc we just played one
	beqz $a1, songdone # Check if we've played all notes - yes? exit proc
	addi $a0, $a0, 8 # Go to next note to play (skip 2 words ahead to get next "note pair")
	j psloop # re-loop to play next note

songdone: jr $ra # return bc done playing song


PlayTone:
	# Plays a Midi tone given a tone value to play.
	# Plays on Keyboard
	# $a0 - addr of note to play
	# $a1 - tone table base addr
	#####################################################
	addi $sp, $sp, -8 # make room on stack for ra
	sw $a0, 0($sp) # save a0 so we can use it later to get the duration to play note
	sw $ra, 4($sp) # store $ra. a0 and a1 passed through to GetTone
	lw $a0, 0($a0) # load in index number of tone to play
	# a1 is base addr of tones table to index into. We pass that through as is
	jal GetTone # get tone - result in $v0
	lw $ra, 4($sp) # reload ra
	lw $a0, 0($sp) # reload a0 so we can use it to get duration to play note
	addi $sp, $sp, 8 # move pointer to top of valid stack
	
	lw $a1, 4($a0) # set tone duration - load time tone should be played for which is word after addr of tone
			# Set tone duration because its based off a0 addr which will be overwritten with return
			# value of GetTone -v0 above
	move $a0, $v0 # set pitch - move returned pitch value ($v0) to arg needed for midi syscall ($a0)
	li $a2, 6 # set instrument - select shamisen instrument
	li $a3, 70 # set volume - 100 closely matches actual system volume set by computer user without being startling
	li $v0, 31 # load MIDI out service
	syscall # play MIDI tone
	
	# sleep to ensure notes don't overlap
	move $a0, $a1 # set time of tone to our sleep time
	li $v0, 32 # sleep service
	syscall # sleep for duration of tone
	
	jr $ra # Return from procedure


GetTone:
	# Returns tone value 0-127 for midi to play
	# $a0 - tone number to select from tone table
	# $a1 - tone table base address
	# $v0 - tone value for midi argument
	####################################
	subi $a0, $a0, 1 # We decrement tone index to account for zero based index array
	sll $a0, $a0, 2 # multiply tone number by 4 (size of word) = offset
	add $t0, $a1, $a0 # base + offset = addr of tone to load
	lw $v0, 0($t0) # load into $v0, tone code from addr calculated
	
	jr $ra # return from procedure
	
	
# Testing the user procedure
PrintChoices:
	# Prints choices for user to select from and saves
	# indices of correct choices.
	# a0 = correct answer index
	#############
	move $t0, $a0 # copy a0 correct choice into t0 so we don't copy over it in syscalls
	
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
	la $t5, correct_ans_choices # load base addr of correct answer choices array
	li $t6, 0 # t6 = number of correct choices = 0
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

	# save t0, t1, t2, t3, t5, t6 and ra before getting new random
	addi $sp, $sp, -28
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t5, 16($sp)
	sw $t6, 20($sp)
	sw $ra 24($sp)
	
	lw $a0, choiceGames # load in upper limit of random int to generate
	jal GetRandom # v0 has new random num
	
	# reload t0, t1, t2, t3, t5, t6 and ra
	lw $ra, 24($sp)
	lw $t6, 20($sp)
	lw $t5, 16($sp)
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 28 # pop vars off stack
	# check if choice generated in v0 matches correct choice index t0
	beq $v0, $t0, prepCorrAns # jump to prepping to display correct answer
	# otherwise:
	j getChoice # if we're here we don't want to display correct answer this time around
	
prepCorrAns: move $v0, $t0 # move correct answer index into v0 so we can index into AnswerChoices like normal
	# if we're executing here, this choice index is correct
	sw $t2, 0($t5) # add the current t2 choice index displayed to the array of correct answers
	addi $t5, $t5, 4 # point to next availalbe storage slot
	addi $t6, $t6, 1 # increment # of choices that are correct
getChoice: la $a0, AnswerChoices # load in array of choice variables
	sll $t4,$v0, 2 # calculate offset, t4 = index * 4 (bytes)
	add $a0, $a0, $t4 # choice str location = base + offset
	lw $a0, 0($a0) # load addr of string
displayChoice: li $v0, 4 # print str service
	syscall # print choice string
	
	subi $t1, $t1, 1 # decrement number of choices displayed
	addi $t2, $t2, 1 # increment choice 
	bnez $t1, gcloop # reloop if more choices to generate and display
	# otherwise:
	sw $t6, num_corr_choices # store total number of correct answer choices
	
	jr $ra # return from procedure


TestUser:
	# Prompts and checks user input against $a0 correct string
	# $a0 - correct answer index
	#########################################################
	# save ra and t0 to stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	# passing through a0
	jal PrintChoices
	lw $ra, 0($sp)
	addi $sp, $sp, 4 # pop t0 and ra from stack
	
	# print user entry prompt
	li $v0, 4 # print str service
	la $a0, prompt # load in prompt
	syscall # show user the prompt
	
### Get input and test against it
testloop: # get input integer from user
	li $v0, 5 # read int service
	syscall # read int from user into v0
	# Check if input is valid
	bgt $v0, 3, userInputErr # if user entered num too large
	bltz $v0, userInputErr # also handle error of entering neg num
	# Otherwise see if v0 entered is one of the correct choices
	la $t5, correct_ans_choices # load base addr of correct answer choices array
	lw $t4, num_corr_choices # t4 = choice index
	li $t6, 0 # current correct choice index
choiceCheckingLoop: # loop through correct choices array to see if we have a match
	sll $t3, $t6, 2 # t3 = offset = 4 * curr choice index
	add $t3, $t5, $t3 # t3 = base + offset = addr of curr correct choice testing against
	lw $t0, 0($t3) # load correct choice index into t0
	
	beq $t0, $v0, successInput # if user entered correct choice, display congratulatory message
	
	addi $t6, $t6, 1 # increment loop counter
	bne $t4, $t6, choiceCheckingLoop # keep checking if choices remain to be checked (num corr choices != curr choice index)
	# Otherwise, the user entered a wrong answer
	j failInput # if $t0 doesn't match input $v0
				   
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
endTestUser: 
	li $t0, 0 # set t0 = 0
	sw $t0, num_corr_choices # reset number of correct choices
	jr $ra # return from procedure
