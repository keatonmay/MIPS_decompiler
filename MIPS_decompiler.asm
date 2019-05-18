### Final Project
### Author: Keaton May
###

.data

out_string:	.asciiz "What file contains your information?\n"	# Asks user to input file name
buffer:		.space 2000						# Buffer that will contain the contents of the file after file read
instruction:	.space 32						# holds each instruction read from buffer
file_name:	.space 2000						# Buffer that will contain file name given as input

# Print statements
nl:		.asciiz "\n"

# instruction names
f_add:		.asciiz "add "
f_addi:		.asciiz "addi "
f_addiu:	.asciiz "addiu "
f_addu:		.asciiz "addu "
f_and:		.asciiz "and "
f_andi:		.asciiz "andi "
f_beq:		.asciiz "beq "
f_bne:		.asciiz "bne "
f_j:		.asciiz "j "
f_jal:		.asciiz "jal "
f_jr:		.asciiz "jr "
f_lbu:		.asciiz "lbu "
f_lhu:		.asciiz "lhu "
f_lui:		.asciiz "lui "
f_lw:		.asciiz "lw "
f_nor:		.asciiz "nor "
f_or:		.asciiz "or "
f_ori:		.asciiz "ori "
f_slt:		.asciiz "slt "
f_slti:		.asciiz "slti "
f_sltiu:	.asciiz "sltiu "
f_sltu:		.asciiz "sltu "
f_sll:		.asciiz "slt "
f_srl:		.asciiz "srt "
f_sb:		.asciiz "sb "
f_sh:		.asciiz "sh "
f_sw:		.asciiz "sw "
f_sub:		.asciiz "sub "
f_subu:		.asciiz "subu "

#register

$_r:		.asciiz "$"
space:		.asciiz ", "
lp:		.asciiz "($"
rp:		.asciiz ")"

.text

Main:

# Load and print string asking for file name
	la $a0, out_string
	li $v0, 4
	syscall

# Take input of filename from user	
	li $v0, 8
	la $a0, file_name
	li $a1, 124
	syscall
	
# remove new line character from user input
	la $a0, file_name
	jal ReplaceNewLine

########################
# Open, read and close file
#
# contents of file are saved to buffer
########################

# Open file

	li $v0, 13
	la $a0, file_name
	li $a1, 0
	li $a2, 0
	syscall
	add $s0, $v0, $zero

# Read file and save contents to buffer

	li $v0, 14
	add $a0, $s0, $zero
	la $a1, buffer
	li, $a2, 2000
	syscall

	
# Close the file

	li $v0, 16
	move $a0, $s0
	syscall
	
# Main loop
	la $s0, buffer
	la $s1, instruction
main_loop:
	# Load a byte from buffer
	lb $t0, 0($s0)
	
	# Check to see if byte is null terminator
	beq, $t0, 0, main_loop_exit
	
	# load current address of buffer and instruction and parse 1 instruction at a time
	add $a0, $s0, $zero
	add $a1, $s1, $zero
	jal parse
	
	# keeps track of current address of buffer
	add $s0, $v0, $zero
	
	# convert the opcode from binary to decimal
	move $a0, $s1
	li $a1, 6
	jal conversion
	
	move $s2, $v0
	
	# test the opcode to see which type of instruction is being read in
	beq $s2, 0, r_type
	beq $s2, 16, r_type
	beq $s2, 2, j_type
	beq $s2, 3, j_type
	
	
	
#######################################################################################
######################################################################################
	
i_type:
	# convert rs to decimal
	addi $a0, $s1, 6
	li $a1, 5
	jal conversion
	
	add $s3, $v0, $zero
	
	
	# convert rt to decimal
	addi $a0, $s1, 11
	li $a1, 5
	jal conversion
	
	add $s4, $v0, $zero

	
	# convert immediate value to decimal
	addi $a0, $s1, 16
	li $a1, 16
	jal conversion_i
	
	add $s5, $v0, $zero

	#######################			 #####################
	####################### Print statements #####################	
	beq $s2, 8, i_addi
	beq $s2, 9, i_addiu
	beq $s2, 12, i_andi
	beq $s2, 4, i_beq
	beq $s2, 5, i_bne
	beq $s2, 36, i_lbu
	beq $s2, 37, i_lhu
	beq $s2, 15, i_lui
	beq $s2, 35, i_lw
	beq $s2, 13, i_ori
	beq $s2, 10, i_slti
	beq $s2, 11, i_sltiu
	beq $s2, 40, i_sb
	beq $s2, 41, i_sh
	beq $s2, 43, i_sw

i_addi:
	li $v0, 4
	la $a0, f_addi
	syscall
	j i_register_group_0
i_addiu:
	li $v0, 4
	la $a0, f_addiu
	syscall
	j i_register_group_0
i_andi:
	li $v0, 4
	la $a0, f_andi
	syscall
	j i_register_group_0
i_beq:
	li $v0, 4
	la $a0, f_beq
	syscall
	j i_register_group_0
i_bne:
	li $v0, 4
	la $a0, f_bne
	syscall
	j i_register_group_0
i_lbu:
	li $v0, 4
	la $a0, f_lbu
	syscall
	j i_register_group_1
i_lhu:
	li $v0, 4
	la $a0, f_lhu
	syscall
	j i_register_group_1
i_lui:
	li $v0, 4
	la $a0, f_lui
	syscall
	j i_register_group_1
i_lw:
	li $v0, 4
	la $a0, f_lw
	syscall
	j i_register_group_1
i_ori:
	li $v0, 4
	la $a0, f_ori
	syscall
	j i_register_group_0
i_slti:
	li $v0, 4
	la $a0, f_slti
	syscall
	j i_register_group_0
i_sltiu:
	li $v0, 4
	la $a0, f_sltiu
	syscall
	j i_register_group_0
i_sb:
	li $v0, 4
	la $a0, f_sb
	syscall
	j i_register_group_1
i_sh:
	li $v0, 4
	la $a0, f_sh
	syscall
	j i_register_group_1
i_sw:
	li $v0, 4
	la $a0, f_sw
	syscall
	j i_register_group_1
i_register_group_0:
	li $v0, 4
	la $a0, $_r
	syscall
	
	li $v0, 1
	move $a0, $s4
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 4
	la $a0, $_r
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall	
	
	j i_exit
	
i_register_group_1:
	li $v0, 4
	la $a0, $_r
	syscall
	
	li $v0, 1
	move $a0, $s4
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	
	li $v0, 4
	la $a0, lp
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 4
	la $a0, rp
	syscall

i_exit:

	
	# print new line for next instruction
	li $v0, 4
	la $a0, nl
	syscall
	
	j main_loop
	
#######################################################################################
######################################################################################	
	
	
r_type:

	# convert rs to decimal
	addi $a0, $s1, 6
	li $a1, 5
	jal conversion
	
	add $s3, $v0, $zero

	# convert rt to decimal
	addi $a0, $s1, 11
	li $a1, 5
	jal conversion
	
	add $s4, $v0, $zero
	
	# convert rd to decimal
	addi $a0, $s1, 16
	li $a1, 5
	jal conversion
	
	add $s5, $v0, $zero
	
	# convert shift to decimal
	addi $a0, $s1, 21
	li $a1, 5
	jal conversion
	
	add $s6, $v0, $zero
	
	# convert function to decimal and print
	addi $a0, $s1, 26
	li $a1, 6
	jal conversion
	
	add $s7, $v0, $zero
	
	#######################			 #####################
	####################### Print statements #####################
	
	beq $s7, 32, r_add
	beq $s7, 33, r_addu
	beq $s7, 36, r_and
	beq $s7, 8, r_jr
	beq $s7, 39, r_nor
	beq $s7, 37, r_or
	beq $s7, 42, r_slt
	beq $s7, 43, r_sltu
	beq $s7, 0, r_sll
	beq $s7, 2, r_srl
	beq $s7, 34, r_sub
	beq $s7, 35, r_subu

r_add:
	li $v0, 4
	la $a0, f_add
	syscall
	j r_register_group_0
r_addu:
	li $v0, 4
	la $a0, f_addu
	syscall
	j r_register_group_0
r_and:
	li $v0, 4
	la $a0, f_and
	syscall
	j r_register_group_0
r_jr:
	li $v0, 4
	la $a0, f_jr
	syscall
	j r_register_group_1
r_nor:
	li $v0, 4
	la $a0, f_nor
	syscall
	j r_register_group_0
r_or:
	li $v0, 4
	la $a0, f_or
	syscall
	j r_register_group_0
r_slt:
	li $v0, 4
	la $a0, f_slt
	syscall
	j r_register_group_0
r_sltu:
	li $v0, 4
	la $a0, f_sltu
	syscall
	j r_register_group_0
r_sll:
	li $v0, 4
	la $a0, f_sll
	syscall
	j r_register_group_2
r_srl:
	li $v0, 4
	la $a0, f_srl
	syscall
	j r_register_group_2
r_sub:
	li $v0, 4
	la $a0, f_sub
	syscall
	j r_register_group_0
r_subu:
	li $v0, 4
	la $a0, f_subu
	syscall

r_register_group_0:
	
	li $v0, 4
	la $a0, $_r
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 4
	la $a0, $_r
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 4
	la $a0, $_r
	syscall
	
	li $v0, 1
	move $a0, $s4
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	j exit_r

r_register_group_1:
	li $v0, 4
	la $a0, $_r
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	j exit_r

r_register_group_2:
	li $v0, 4
	la $a0, $_r
	syscall
	
	li $v0, 1
	move $a0, $s5
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 4
	la $a0, $_r
	syscall
	
	li $v0, 1
	move $a0, $s4
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 4
	la $a0, $_r
	syscall
	
	li $v0, 1
	move $a0, $s6
	syscall
	
	j exit_r
	
exit_r:
	li $v0, 4
	la $a0, nl
	syscall
	
	j main_loop
	
#######################################################################################
######################################################################################


j_type:
	# convert address to decimal
	addi $a0, $s1, 6
	li $a1, 26
	jal conversion
	
	add $s3, $v0, $zero
	
	beq $s2, 2, j_j
	beq $s2, 3, j_jal
	
j_j:
	li $v0, 4
	la $a0, f_j
	syscall
	j j_exit

j_jal:
	li $v0, 4
	la $a0, f_jal
	syscall
	j j_exit
	
j_exit:	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 4
	la $a0, nl
	syscall
	
	j main_loop
	
main_loop_exit:
	
# End program
	li $v0, 10
	syscall
	
######################################
# SUBROUTINES
#####################################

#######################################
# 2's complement conversion
#
# This process converts a binary string to decimal word
# $a0 - address of string
# $a1 - length of string
# $s0 - cumulative sum
# $s1 - this amount is shifted left and added to $s0 to convert the binary value to decimal
######################################

conversion_i:
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	addi $s0, $zero, 0
	addi $s1, $zero, 1
	addi $a1, $a1, -1
	add $a0, $a0, $a1
	
	lb $t0, -15($a0)
	beq $t0, 49, negative
	addi $a1, $a1, -1
positive:
	beq $a1, -1, conversion_i_exit
	lb $t0, ($a0)
	beq $t0, 49, true_p
	
	sll $s1, $s1, 1
	addi $a0, $a0, -1
	addi $a1, $a1, -1
	j positive
true_p:
	add $s0, $s0, $s1
	sll $s1, $s1, 1
	addi $a0, $a0, -1
	addi $a1, $a1, -1
	j positive
negative:
	beq $a1, -1, conversion_i_exit
	lb $t0, ($a0)
	beq $t0, 48, true_n
	
	sll $s1, $s1, 1
	addi $a0, $a0, -1
	addi $a1, $a1, -1
	j negative
	
true_n:
	add $s0, $s0, $s1
	sll $s1, $s1, 1
	addi $a0, $a0, -1
	addi $a1, $a1, -1
	j negative
	
conversion_i_exit:
	move $v0, $s0

	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	jr $ra
conversion_i_exit_n:
	mul $s0, $s0, -1
	addi $s0, $s0, -1
	
	move $v0, $s0
	
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
######################################
# Binary conversion
#
# This process converts a binary string to decimal word
# $a0 - address of string
# $a1 - length of string
# $t0 - counts number of loops
# $s0 - cumulative sum
# $s1 - this amount is shifted left and added to $s0 to convert the binary value to decimal
#
# This routing multiplies $s1 by 2 via sll and adds the value to $s0 if the bit is a 1. The counter is implemented to add 1 if the first bit is 1 instead of a multiple of 2.
#######################################

conversion:
	addi $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	addi $s0, $zero, 0
	addi $s1, $zero, 2
	addi $t0, $zero, 1
	addi $a1, $a1, -1
	add $a0, $a0, $a1
conversion_loop:
	# load a byte and see if it matches the ascii value for 1. Shift $s1 if the counter is not 1.
	lb $t1, ($a0)
	beq $a1, -1, conversion_exit
	beq $t1, 49, true
	addi $a0, $a0, -1
	addi $a1, $a1, -1
	
	bne $t0, 1, shift
	addi $t0, $t0, 1
	j conversion_loop
shift:
	# this case multiplies $s1 by 2 when the read byte is a 0 but the counter is >1
	sll $s1, $s1, 1
	addi $t0, $t0, 1
	j conversion_loop
true:
	# this case occurs if the bit read is a 1 and the counter is not 1.
	beq $t0, 1, first_bit
	add $s0, $s0, $s1
	sll $s1, $s1, 1
	
	addi $a0, $a0, -1
	addi $a1, $a1, -1
	addi $t0, $t0, 1
	j conversion_loop
first_bit:
	# this case occurs if the bit read is a 1 and the counter is 1. adds 1 to account for 2 to the power 0 in decimal conversion.
	addi $s0, $s0, 1
	addi $a0, $a0, -1
	addi $a1, $a1, -1
	addi $t0, $t0, 1
	j conversion_loop
conversion_exit:
	# move sum to $v0 and return to main loop
	move $v0, $s0
	
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	

######################################################
# ReplaceNewLine
#
# This process removes the \n char that is added to file_name when user presses enter
######################################################

ReplaceNewLine:
	addi $sp, $sp, -8
	sw $s3, 0($sp)
	sw $s4, 4($sp)
	
L1:
	lb $s3, 0($a0)
	beq $s3, '\n', replace
	beq $s3, '\0', exit_replace
	add $a0, $a0, 1
	j L1
replace:
	sb $s4, 0($a0)
exit_replace:	
	lw $s4, 4($sp)
	lw $s3, 0($sp)
	addi $sp, $sp, 8
	jr $ra
########################################
# parse
#
# This process splits the string read from the text file
#######################################

parse:
	addi $sp, $sp, -4
	sw $s0, 0($sp)
parse_loop:
	lb $s0, 0($a0) 
	beq $s0, 10, exit_parse
	beq $s0, '\0', exit_parse
	sb $s0, 0($a1)
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j parse_loop
exit_parse: 
	addi $a0, $a0, 1
	addi $v0, $a0, 0
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	jr $ra
