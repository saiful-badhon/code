.data
	msg1: .asciiz "Welcome to tic tac toe"
	turn1: .asciiz "Player 1's turn: "
	turn2: .asciiz "Player 2's turn: "
	win1: .asciiz "Player 1 win."
	win2: .asciiz "Player 2 win."
	lastdraw: .asciiz "Draw."
	line1: .asciiz "1 2 3"
	line2: .asciiz "4 5 6"
	line3: .asciiz "7 8 9"
	guide: .asciiz "Enter the location[1-9] to play the games."
	guide1: .asciiz "Player 1: X and Player 2: O."
	grid: .asciiz  #we use grid to store the array of tic-tac-toe 3x3
.text

#display the main and guide the player to play the games
main:
	li $s3, 0
	li $s4, 0
	la $a0, msg1
	li $v0, 4
	syscall
	jal newline
	j displaysample

#to determine the turn of player 1 and player 2
turn:
	jal newline
	beq $s3, 0, play1 #0 for player 1
	beq $s3, 1, play2 #1 for player 2

#manage player 1's turn	
play1:
	la $a0, turn1
	li $v0, 4
	syscall
	jal newline
	j play

#manage player 2's turn	
play2:
	la $a0, turn2
	li $v0, 4
	syscall
	jal newline
	j play

#manage the game. this function will jumep to three function: getinput, checkinput and storeinput
play:
	jal newline
	beq $s4, 9, draw
	jal getinput
	jal checkinput
	j storeinput

#display the initial sample(location of the tic-tac-toe[1-9])
#load and display line1, line2, line3, line4
#display the initial sample(location of the tic-tac-toe[1-9])
#load and display line1, line2, line3, line4
# Function to display the initial sample
displaysample:
    # Step 1: Allocate stack space
    subu $sp, $sp, 20

    # Step 2: Write to stack
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    # Step 3: Call function
    la $a0, line1
    li $v0, 4
    syscall
    jal newline

    la $a0, line2
    li $v0, 4
    syscall
    jal newline

    la $a0, line3
    li $v0, 4
    syscall
    jal newline

    la $a0, guide
    li $v0, 4
    syscall
    jal newline

    la $a0, guide1
    li $v0, 4
    syscall
    jal newline

    # Step 4: Read from stack
    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)

    # Step 5: Deallocate stack space
    addu $sp, $sp, 20

    # Continue with the control flow
    j turn

# Function to initialize display
display:
    # Step 1: Allocate stack space
    subu $sp, $sp, 8

    # Step 2: Write to stack
    sw $ra, 4($sp)
    sw $s0, 0($sp)

    # Step 3: Call function
    li $s0, 0
    li $s1, 0
    j displayline

    # Step 4: Read from stack
    lw $ra, 4($sp)
    lw $s0, 0($sp)

    # Step 5: Deallocate stack space
    addu $sp, $sp, 8

    # Continue with the control flow
    j $ra

# Function to display newline for displaying grid
displayline:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    addi $s1, $s1, 3
    jal newline
    jal displaygrid

    # Step D: Return to caller
    j $ra

# Function to display all the information in the grid
displaygrid:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    beq $s0, 9, checkwinall
    beq $s0, $s1, displayline
    addi $s0, $s0, 1
    la $t2, grid
    add $t2, $t2, $s0
    lb $t3, ($t2)
    jal addspace
    beq $t3, 0, displayspace
    beq $t3, 1, displayx
    beq $t3, 2, displayo

    # Step D: Return to caller
    j $ra

# Function to display X
displayx:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    li $a0, 88
    li $v0, 11
    syscall
    j displaygrid

    # Step D: Return to caller
    j $ra

# Function to display O
displayo:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    li $a0, 79
    li $v0, 11
    syscall
    j displaygrid

    # Step D: Return to caller
    j $ra

# Function to display ? if the value in grid is 0
displayspace:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    li $a0, 63
    li $v0, 11
    syscall
    j displaygrid  # Jump back to grid

    # Step D: Return to caller
    j $ra

# Function to get input from user
getinput:
    # Step 1: Allocate stack space
    subu $sp, $sp, 4

    # Step 2: Write to stack
    sw $ra, 0($sp)

    # Step 3: Call function
    li $v0, 5
    syscall
    li $s2, 0
    add $s2, $s2, $v0

    # Step 4: Read from stack
    lw $ra, 0($sp)

    # Step 5: Deallocate stack space
    addu $sp, $sp, 4

    # Return to previous function
    jr $ra

# Function to check if the input is within the range of [1-9]
checkinput:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    la $t1, grid
    add $t1, $t1, $s2
    lb $t2, ($t1)
    bne $t2, 0, turn
    bge $s2, 10, turn
    ble $s2, 0, turn

    # Step D: Return to caller
    j $ra

# Function to store the input into grid
storeinput:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    addi $s4, $s4, 1
    beq $s3, 0, storex
    beq $s3, 1, storeo

    # Step D: Return to caller
    j $ra

# Function to store player 1's turn
storex:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    la $t1, grid
    add $t1, $t1, $s2
    li $t2, 1
    sb $t2, ($t1)
    li $s3, 1
    j display

    # Step D: Return to caller
    j $ra

# Function to store player 2's turn
storeo:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    la $t1, grid
    add $t1, $t1, $s2
    li $t2, 2
    sb $t2, ($t1)
    li $s3, 0
    j display

    # Step D: Return to caller
    j $ra

# Function to check if all values are displayed and initiate win condition checks
checkwinall:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    bge $s4, 5, wincondition1
    j turn

    # Step D: Return to caller
    j $ra

# Function to check if all values in the first row are the same
wincondition1:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    li $s6, 0
    li $s5, 1
    la $t1, grid
    add $t1, $t1, $s5
    lb $t2, ($t1)
    addi $t1, $t1, 1
    lb $t3, ($t1)
    addi $t1, $t1, 1
    lb $t4, ($t1)
    add $s6, $s6, $t2
    bne $t2, $t3, wincondition2
    bne $t3, $t4, wincondition2
    beq $t2, 0, wincondition2
    j win

    # Step D: Return to caller
    j $ra

# Function to check if all values in the first column are the same
wincondition2:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    li $s6, 0
    li $s5, 1
    la $t1, grid
    add $t1, $t1, $s5
    lb $t2, ($t1)
    addi $t1, $t1, 3
    lb $t3, ($t1)
    addi $t1, $t1, 3
    lb $t4, ($t1)
    add $s6, $s6, $t2
    bne $t2, $t3, wincondition3
    bne $t3, $t4, wincondition3
    beq $t2, 0, wincondition3
    j win

    # Step D: Return to caller
    j $ra

# Function to check if diagonal positions have the same value
wincondition3:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    li $s6, 0
    li $s5, 1
    la $t1, grid
    add $t1, $t1, $s5
    lb $t2, ($t1)
    addi $t1, $t1, 4
    lb $t3, ($t1)
    addi $t1, $t1, 4
    lb $t4, ($t1)
    add $s6, $s6, $t2
    bne $t2, $t3, wincondition4
    bne $t3, $t4, wincondition4
    beq $t2, 0, wincondition4
    j win

    # Step D: Return to caller
    j $ra

# Function to check if all values in the second column are the same
wincondition4:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    li $s6, 0
    li $s5, 2
    la $t1, grid
    add $t1, $t1, $s5
    lb $t2, ($t1)
    addi $t1, $t1, 3
    lb $t3, ($t1)
    addi $t1, $t1, 3
    lb $t4, ($t1)
    add $s6, $s6, $t2
    bne $t2, $t3, wincondition5
    bne $t3, $t4, wincondition5
    beq $t2, 0, wincondition5
    j win

    # Step D: Return to caller
    j $ra

# Function to check if all values in the second row are the same
wincondition5:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    li $s6, 0
    li $s5, 4
    la $t1, grid
    add $t1, $t1, $s5
    lb $t2, ($t1)
    addi $t1, $t1, 1
    lb $t3, ($t1)
    addi $t1, $t1, 1
    lb $t4, ($t1)
    add $s6, $s6, $t2
    bne $t2, $t3, wincondition6
    bne $t3, $t4, wincondition6
    beq $t2, 0, wincondition6
    j win

    # Step D: Return to caller
    j $ra

# Function to check if diagonal positions have the same value
wincondition6:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    li $s6, 0
    li $s5, 3
    la $t1, grid
    add $t1, $t1, $s5
    lb $t2, ($t1)
    addi $t1, $t1, 2
    lb $t3, ($t1)
    addi $t1, $t1, 2
    lb $t4, ($t1)
    add $s6, $s6, $t2
    bne $t2, $t3, wincondition7
    bne $t3, $t4, wincondition7
    beq $t2, 0, wincondition7
    j win

    # Step D: Return to caller
    j $ra

# Function to check if all values in the third column are the same
wincondition7:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    li $s6, 

# Function to make a new line
newline:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    li $a0, 10   # load line
    li $v0, 11   # print line
    syscall

    # Step D: Return to caller
    jr $ra

# Function to add space
addspace:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    li $a0, 32   # load space
    li $v0, 11   # print space
    syscall

    # Step D: Return to caller
    jr $ra

# Function to display the winner
win:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    beq $s6, 1, player1win   # check if $s6 == 1(x), jump to player1win
    beq $s6, 2, player2win   # check if $s6 == 2(O), jump to player2win

    # Step D: Return to caller
    j $ra

# Function to load and display win1
player1win:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    j newline
    la $a0, win1
    li $v0, 4
    syscall
    j end

    # Step D: Return to caller
    j $ra

# Function to load and display win2
player2win:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    j newline
    la $a0, win2
    li $v0, 4
    syscall
    j end

    # Step D: Return to caller
    j $ra

# Function to load and display lastdraw
draw:
    # Step A: Read input args from the stack
    # No input args to read in this case

    # Step B: Business logic
    j newline
    la $a0, lastdraw
    li $v0, 4
    syscall
    j end

    # Step D: Return to caller
    j $ra

#to make new line	
newline:
	li $a0, 10 #load line
	li $v0, 11 #print line
	syscall
	jr $ra
#to make space
addspace:
	li $a0, 32 #load space
	li $v0, 11 #print space
	syscall
	jr $ra

#to display the winner
win:
	beq $s6, 1, player1win #check if $s6==1(x),jump to player1win
	beq $s6, 2, player2win #check if $s6==2(O),jump to player2win

#load and display win1
player1win:
	jal newline
	la $a0, win1
	li $v0, 4
	syscall
	j end
	
#load and display win2
player2win:
	jal newline
	la $a0, win2
	li $v0, 4
	syscall
	j end

#load and display lastdraw
draw:
	jal newline
	la $a0, lastdraw
	li $v0, 4
	syscall
	j end
	
#exit the program
end:
	li $v0, 10
	syscall
