.data
Title: .asciiz "Welcome to Tic-Tac-Toe in Assembly!!!\n\n The positions are as follows:\n\n"
Positions: .asciiz "1|2|3\n4|5|6\n7|8|9\n\n"
Player1Text: .asciiz "Please Enter a Position to put an X!!!\n\n"
Player2Text: .asciiz "Please Enter a Position to put an O!!!\n\n"
Board: .asciiz " | | \n | | \n | | \n"
InputNumber: .byte 1
WinnerMessage: .asciiz "Player X wins!!!\n\n"
DrawMessage: .asciiz "It's a draw!!!\n\n"

.globl main
.text
main:

    li $t0, 1        # Current player - Initial player is 1
    li $t1, 9        # Number of turns remaining
    li $t2, 9        # Board Test Incrementer
    la $t3, Board    # Character address
    li $v0, 4        # syscall 4 – print string

    la $a0, Title
    syscall

    la $a0, Positions
    syscall

Play:

    beq $t1, 0, CheckWinner

    beq $t0, 1, Player1
    j Player2

Player1:

    li $v0, 4
    la $a0, Player1Text
    syscall

    li $v0, 5            # Read Integer
    syscall
    move $s0, $v0        # Put input into $s0
    subi $s0, $s0, 1      # Adjust for zero-based indexing
    divu $s0, $s0, 3      # Divide by 3 to get the row
    mflo $t6              # Store the quotient in $t6
    divu $s0, $s0, 3      # Divide by 3 to get the column
    mflo $t5              # Store the quotient in $t5
    mul $t5, $t5, 2       # Multiply the column by 2 to get the correct position
    add $t3, $t3, $t5     # Add the column offset to the starting position
    add $t3, $t3, $t6     # Add the row offset to the calculated position
    mul $t3, $t3, 2       # Multiply the position by 2 to skip the vertical bars

    lbu $t4, 0($t3)
    addi $t4, $t4, 56
    sb $t4, 0($t3)

    addi $t1, $t1, -1
    li $t0, 2
    j OutputBoard

Player2:

    li $v0, 4
    la $a0, Player2Text
    syscall

    li $v0, 5            # Read Integer
    syscall
    move $s0, $v0        # Put input into $s0
    subi $s0, $s0, 1      # Adjust for zero-based indexing
    divu $s0, $s0, 3      # Divide by 3 to get the row
    mflo $t6              # Store the quotient in $t6
    divu $s0, $s0, 3      # Divide by 3 to get the column
    mflo $t5              # Store the quotient in $t5
    mul $t5, $t5, 2       # Multiply the column by 2 to get the correct position
    add $t3, $t3, $t5     # Add the column offset to the starting position
    add $t3, $t3, $t6     # Add the row offset to the calculated position
    mul $t3, $t3, 2       # Multiply the position by 2 to skip the vertical bars

    lb $t4, 0($t3)
    addi $t4, $t4, 47
    sb $t4, 0($t3)

    addi $t1, $t1, -1
    li $t0, 1
    j OutputBoard

OutputBoard:

    li $v0, 4
    la $a0, Positions
    syscall

    la $a0, Board
    syscall

    li $s0, 0
    la $t3, Board
    j Play

CheckWinner:

    # Check for a winner
    la $t3, Board
    li $t4, 0

CheckRows:

    lb $t5, 0($t3)
    lb $t6, 2($t3)
    lb $t7, 4($t3)

    beq $t5, $t6, CheckColumns
    beq $t6, $t7, CheckColumns
    beq $t5, $t7, CheckColumns

    addi $t3, $t3, 6   # Move to the next row
    addi $t4, $t4, 1
    bne $t4, 3, CheckRows

DeclareDraw:

    # If no winner is found, it's a draw
    li $v0, 4
    la $a0, DrawMessage
    syscall

    j Exit

CheckColumns:

    sub $t3, $t3, 18  # Move back to the start of the row
    li $t4, 0

CheckColsLoop:

    lb $t5, 0($t3)
    lb $t6, 6($t3)
    lb $t7, 12($t3)

    beq $t5, $t6, CheckDiagonals
    beq $t6, $t7, CheckDiagonals
    beq $t5, $t7, CheckDiagonals

    addi $t3, $t3, 2   # Move to the next column
    addi $t4, $t4, 1
    bne $t4, 3, CheckColsLoop

CheckDiagonals:

    li $t4, 0
    li $t5, 0

    lb $t6, 0($t3)
    lb $t7, 8($t3)
    lb $t8, 16($t3)

    beq $t6, $t7, DeclareWinner
    beq $t7, $t8, DeclareWinner
    beq $t6, $t8, DeclareWinner

    j DeclareDraw

DeclareWinner:

    # If a winner is found, declare the winner and exit
    li $v0, 4
    la $a0, WinnerMessage
    syscall

Exit:

    li $v0, 10
    syscall
