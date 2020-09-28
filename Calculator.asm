.data
	First_Input:		.word 0
	Second_Input:		.word 0
	Result:			.word 0
	Operator:		.word 0
	Remainder:		.word 0

	First_Prompt:		.asciiz "Enter first value:\n"
	Second_Prompt:		.asciiz "Enter second value:\n"
	Operator_Prompt:	.asciiz "Enter Operator:\n"
	Invalid_Prompt:		.asciiz	"Invalid Operator Entered, please try again. \n"
	DivByZero_Prompt:	.asciiz "Cannot divide by 0, please try again. \n"
	DivByNeg_Prompt:	.asciiz "Negative numbers are invalid, please try again. \n"
	Remainder_Prompt:	.asciiz "The Remainder is: "
.text
Main:
	# GET INPUT
	la		$a0, First_Prompt		# Load pointer First_Prompt into $a0
	la		$a1, First_Input		# Load pointer First_Input into $a1
	jal 	GetInput				# Jump to procedure printInputStr1
	
	# GET OPERATOR
	la	$a0, Operator_Prompt			# Load pointer Operator_Prompt into $a0
	la	$a1, Operator				# Load pointer Operator into $a1
	jal	GetOperator
	
	# PRINT NEWLINE
	li	$v0, 11					# Load print character syscall
	addi	$a0, $0, 0xA				# Load ascii character for newline into $a0
	syscall						# Execute
	
	#  GETINPUT2
	la	$a0, Second_Prompt			# Load pointer Second_Prompt into $a0
	la	$a1, Second_Input			# Load pointer Second_Input into $a1
	jal 	GetInput				# Jump to procedure printInputStr1
	
	la	$a0, First_Input			# Load address of First_Input into $a0
	la	$a1, Second_Input			# Load address of Second_Input into $a1
	la	$a2, Result				# Load address of Result into $a2
	la	$a3, Remainder 				# Load address of Result into $a3
	la 	$ra, continue
	# OPERATOR BRANCH
	beq	$v1, 43, AddNumJump			# Branch if $v1 is a '+' Operator
	beq	$v1, 45, SubNumJump			# Branch if $v1 is a '-' Operator
	beq	$v1, 42, MultNumJump			# Branch if $v1 is a '*' Operator
	beq	$v1, 47, DivNumJump			# Branch if $v1 is a '/' Operator

	# INVALID OPERATOR 
	li	$v0, 4					# Load print string syscall
	la	$a0, Invalid_Prompt			# Load address for invalid Operator string
	syscall						# Execute
	j	Main					# Loop to start of program
	
	# Jump and link to AddNum 
	AddNumJump:
	la	$a0, First_Input			# Load address of First_Input into $a0
	la	$a1, Second_Input			# Load address of Second_Input into $a1
	la	$a2, Result				# Load address of Result into $a2
	jal	AddNum					# Jump and link to AddNum
	j 	continue				# Jump to continue program
	
	# Jump and link to SubNum
	SubNumJump:
	la	$a0, First_Input			# Load address of First_Input into $a0
	la	$a1, Second_Input			# Load address of Second_Input into $a1
	la	$a2, Result				# Load address of Result into $a2
	jal	SubNum					# Jump and link to SubNum
	j 	continue				# Jump to continue program
	
	# Jump and link to MultNum
	MultNumJump:
	la	$a0, First_Input			# Load address of First_Input into $a0
	la	$a1, Second_Input			# Load address of Second_Input into $a1
	la	$a2, Result				# Load address of Result into $a2
	jal	MultNum					# Jump and link to MultNum
	j 	continue				# Jump to continue program
	
	# Jump and link to DivNum
	DivNumJump:
	la	$a0, First_Input			# Load address of First_Input into $a0
	la	$a1, Second_Input			# Load address of Second_Input into $a1
	la	$a2, Result				# Load address of Result into $a2
	la	$a3, Remainder 				# Load address of Result into $a3
	jal	DivNum					# Jump and link to DivNum
	j 	continue				# Jump to continue program
	
	# Continue after operation is done
	continue:
	
	# DISPLAY RESULT
	la	$a0, First_Input			# Load address of First_Input into $a0
	la	$a1, Second_Input			# Load address of Second_Input into $a1
	la	$a2, Operator				# Load address of Operator into $a2
	la	$a3, Result				# Load address of Result into $a3

	jal	Display					# Jump and link to displayNumb
	
	# DISPLAY REMAINDER IF NECESSARY
	lw	$t0, Operator				# Load Operator value into $t0
	bne   	$t0, 47, skipRemainder			# Branch if division Operator was used
	
	# PRINT REMAINDER
	la	$a0, Remainder_Prompt			# Load value of Remainder into $a0
	li	$v0, 4					# Load print character syscall
	syscall		
	
	lw	$a0, Remainder				# Load value of Remainder into $a0
	li	$v0, 1					# Load print character syscall
	syscall						# Execute
	
	# If not division, Remainder is skipped
	skipRemainder:
	
	# PRINT NEWLINE
	li	$v0, 11					# Load print character syscall
	addi	$a0, $0, 0xA				# Load ascii character for newline into $a0
	syscall	
	
	# CLEAR LABELS
	sw	$0, First_Input				# Clear First_Input
	sw	$0, Second_Input			# Clear Second_Input
	sw	$0, Result				# Clear Result
	sw	$0, Operator				# Clear Operator
	sw	$0, Remainder				# Clear Remainder
	
	# LOOP
	j	Main					# Loop to beginning of program
	
	# DIVISION BY ZERO
	divisionByZero:
	li	$v0, 4					# Load print string syscall
	la	$a0, DivByZero_Prompt			# Load in divisionByZero string
	syscall						# Execute
	j	Main					# Loop Program
	
	# DIVISION BY NEGATIVE
	divisionByNeg:
	li	$v0, 4					# Load print string syscall
	la	$a0, DivByNeg_Prompt			# Load in DivByNeg_Prompt string
	syscall						# Execute
	j	Main					# Loop Program
	
# Procedure: GetInput
GetInput:
	# PRINT STRING
	li	$v0, 4					# Load print string syscall
	syscall						# Execute
	
	# READ INPUT
	li	$v0, 5					# Load read integer syscall
	syscall						# Execute
	sw	$v0, ($a1)				# Store value at address $a1 into label
	
	jr	$ra					# Return to Main

# Procedure: GetOperator
GetOperator:
	# PRINT STRING
	li	$v0, 4					# Load print string syscall
	syscall						# Execute
	
	# READ INPUT
	li	$v0, 12					# Load read character syscall
	syscall						# Execute
	move	$v1, $v0				# Return Operator character in $v1
	sw	$v1, ($a1)				# Store asciiz number into label
	
	jr	$ra					# Return to Main
	
# Procedure: AddNumb   0($a2) = 0($a0) + 0($a1)
AddNum:
	# LOAD WORDS
	lw	$t0, ($a0)				# Load word of address $a0 into $t0
	lw	$t1, ($a1)				# Load word of address $a1 into $t1
	#lw	$t2, ($a2)				# Load word of address $a2 into $t2
		
	# ADD INPUTS
	add	$t2, $t0, $t1				# Add two inputs together
	sw	$t2, ($a2)				# Store in pointer of $a2
	
	jr	$ra					# Return to Main
	
# Procedure: SubNumb   0($a2) = 0($a0) - 0($a1)
SubNum:
	# LOAD WORDS
	lw	$t0, ($a0)				# Load word of address $a0 into $t0
	lw	$t1, ($a1)				# Load word of address $a1 into $t1
	lw	$t2, ($a2)				# Load word of address $a1 into $t1
		
	# SUBTRACT INPUTS
	sub	$t2, $t0, $t1				# Add two inputs together
	sw	$t2, ($a2)				# Store in pointer of $a2

	jr	$ra					# Return to Main
	
#Procedure: MultNumb   0($a2) = 0($a0) * 0($a1)
MultNum:
	# LOAD WORDS
	lw	$t0, ($a0)				# Load word of address $a0 into $t0
	lw	$t1, ($a1)				# Load word of address $a1 into $t1
	lw	$t3, ($a2)				# Load word of address $a2 into $t3
	
	# CHECK BIT
	loopMult:
		andi	$t2, $t1, 1			# Check if bit is set; #t2 bit_check
		beqz	$t2, clearBitMult		# Branch if bit is set
		addu	$t3, $t3, $t0			# Add num2 to Result if bit is clear; #t3 Result

	# MULTIPLY AND SHIFT
	clearBitMult:
		sll	$t0, $t0, 1			# Shift num1 left one bit to multiply by power of 2
		srl	$t1, $t1, 1			# Shift num2 right one bit to check next bit
		bnez	$t1, loopMult			# If num2 is not equal to zero, loop again, otherwise done
		sw 	$t3, ($a2)			# Store Result into label
		jr	$ra				# Return to Main
	
# Procedure: DivNumb   0($a2) = 0($a0) / 0($a1)   0($a3) = 0($a0) % 0($a1)
DivNum:
	# LOAD WORDS
	lw	$t0, ($a0)				# Load word of address $a0 into $t0
	lw	$t1, ($a1)				# Load word of address $a1 into $t1
	li	$t2, 0					# Running quotient
	
	# CHECK IF DIVISION BY 0
	beqz 	$t1, divisionByZero 			# Jump if 0
	
	# CHECK IF DIVISION BY NEGATIVE
	bltz   	$t0, divisionByNeg 			# Jump if negative
	bltz   	$t1, divisionByNeg 			# Jump if negative

	# CHECK IF DIVIDEND IS GREATER THAN DIVISOR
	loopDiv:
		bgt   $t0, $t1, beginDivision		# Branch if dividend is greater than divisor
		bne   $t0, $t1, Finish			# Branch if dividend is equal to divisor
		sub   $t0, $t0, $t1			# Subtract Dividend and Divisor = 0
		addi  $t2, $t2, 1			# Add 1 due to dividend and divisors being equal
		
	Finish:			
		sw    $t0, ($a3)			# Store Remainder into label	
		sw    $t2, ($a2)			# Store Result into label
		jr    $ra				# Return to Main

	# SHIFT UNTIL DIVISOR IS BIGGER THAN DIVIDEND
	beginDivision:
		li   $t4, 1				# Set temp quotient to 1
		move $t3, $t1				# Copy divisor into temp divisor
		sll  $t3, $t3, 1			# Shift temp divisor left 1 before going into loop
		bgt  $t0, $t3, divisionLoop		# Branch if dividend is greater than temp divisor
		j    contDiv				# Else jump to contDiv
		
	divisionLoop:
		sll $t4, $t4, 1				# Shift left temp quotient by 1
		sll $t3, $t3, 1				# Shift left temp divisor by 1
		bgt $t0, $t3, divisionLoop		# Shift until temp divisor is greater than dividend
	
	contDiv:
		add	$t2, $t2, $t4			# Set running quotient = running quotient + temp quotient
		srl	$t3, $t3, 1			# Undo temp divisors last shift
		sub	$t0, $t0, $t3 			# Set dividend = dividend - temp divisor
		j	loopDiv
		


# Procedure: Display
Display:
	# LOAD WORDS
	lw		$t0, ($a0)				# Load First_Input value into #t0
	lw		$t1, ($a1)				# Load Second_Input value into #t1
	lw		$t2, ($a2)				# Load Operator asciiz value into #t2
	lw		$t3, ($a3)				# Load Result value into #t3

	# PRINT INPUT1
	li	$v0, 1						# Load syscall for print integer
	move	$a0, $t0					# Copy First_Input value into $a0 for printing
	syscall							# Print integer in $a0(First_Input)
	
	# PRINT SPACE
	li	$v0, 11						# Load syscall for print integer
	addi	$a0, $0, 0x20					# Load ascii for space into $a0
	syscall							# Execute
	
	# PRINT OPERATOR
	li	$v0, 11						# Load syscall for print integer
	add 	$a0, $0, $t2					# Load ascii for Operator into $a0
	syscall							# Execute
	
	# PRINT SPACE
	li	$v0, 11						# Load syscall for print integer
	addi	$a0, $0, 0x20					# Load ascii for space into $a0
	syscall							# Execute
	
	# PRINT INPUT2
	li	$v0, 1						# Load syscall for print integer
	move	$a0, $t1					# Copy Second_Input value into $a0 for printing
	syscall							# Execute
	
	# PRINT SPACE
	li	$v0, 11						# Load syscall for print integer
	addi	$a0, $0, 0x20					# Load ascii for space into $a0
	syscall							# Execute
	
	# PRINT EQUAL SIGN
	li	$v0, 11						# Load syscall for print integer
	addi	$a0, $0, 0x3D					# Load ascii for space into $a0
	syscall							# Execute
	
	# PRINT SPACE
	li	$v0, 11						# Load syscall for print integer
	addi	$a0, $0, 0x20					# Load ascii for space into $a0
	syscall							# Execute
	
	# PRINT RESULT
	li	$v0, 1						# Load syscall for print integer
	move	$a0, $t3					# Copy Second_Input value into $a0 for printing
	syscall							# Execute
	
	# PRINT NEWLINE
	li	$v0, 11						# Load print character syscall
	addi	$a0, $0, 0xA					# Load ascii character for newline into $a0
	syscall							# Execute
	
	jr		$ra					# Return to Main
