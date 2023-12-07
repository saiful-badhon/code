
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
displaysample:
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
	j turn
#initial display
display:
	li $s0, 0 #set $s0 to 0
	li $s1, 0 #set $s1 to 1
	j displayline #jump to displayline

#to display newline for displaying grid
displayline:
	addi $s1, $s1, 3 #add $s1 + 3 to make sure every 3 output make a new line
	jal newline
	j displaygrid #jump to disply grid

#displaying all the information in grid
displaygrid:
	beq $s0, 9, checkwinall #if $s0==9(all the value in grid are displayed), check the winning condition
	beq $s0, $s1, displayline
	addi $s0, $s0, 1 #increment $s0
	la $t2, grid #load the current grid address
	add $t2, $t2, $s0  #add the address with $s0
	lb $t3, ($t2) #load byte of $t2 to $t3
	jal addspace #to make space
	beq $t3, 0, displayspace #if the value in $t3==0 jump to displayspace
	beq $t3, 1, displayx #if $t3==1 jump to displayx
	beq $t3, 2, displayo #if $t3==2 jump to displayo

#to display 1 to x
displayx:
	li $a0, 88 #load x
	li $v0, 11 #print x
	syscall
	j displaygrid

#to display 2 to O
displayo:
	li $a0, 79 #load O
	li $v0, 11 #print O
	syscall
	j displaygrid

#to display ? if the value in grid is 0
displayspace:
	li $a0, 63 #load ?
	li $v0, 11 #print ?
	syscall
	j displaygrid #jump back to grid

#get input from user
getinput:
	li $v0, 5 #read the location from player
	syscall
	li $s2, 0
	add $s2, $s2, $v0 #add the location to and save to $s2
	jr $ra #return to previous function

#check the input is it within the range of [1-9] or not
checkinput:
	la $t1, grid  #load the grid address
	add $t1, $t1, $s2 #add the $s2 to $t1 to get the exact location
	lb $t2, ($t1) #load the $t1 into $t2
	bne $t2, 0, turn # check if $t2!=0 jump to turn
	bge $s2, 10, turn # check if $s2 >= 10, jump to turn
	ble $s2, 0, turn # check if $s2 <= 0, jump to turn
	jr $ra #return to previous function

#store the input into grid	
storeinput:
	addi $s4, $s4, 1 #increment $s4 for every turn
	beq $s3, 0, storex #if player 1's turn jump to storex
	beq $s3, 1, storeo #if player 2's turn jump to storeo

#to store the player 1's turn
storex:
	la $t1, grid #load the grid
	add $t1, $t1, $s2 #add $s2 location to $t1 to get the exact location
	li $t2, 1 
	sb $t2, ($t1) #store $t1 to $t2
	li $s3, 1 #change the turn to player 2
	j display #jump to display
	
#to store the player 2's turn
storeo:
	la $t1, grid
	add $t1, $t1, $s2
	li $t2, 2
	sb $t2, ($t1)
	li $s3, 0 #change the turn to player 1
	j display

#to check the winning condition
checkwinall:
	bge $s4, 5, wincondition1 #if $s4>=5 check the winning condition)
	j turn #if not jump to turn

#check if all the values in first row has the same value
wincondition1:
	li $s6, 0 #set $s6 to 0
	li $s5, 1 #set$s5 to 1
	la $t1, grid #load grid to $t1
	add $t1, $t1, $s5 #add $t1 + $s5 to access the value in position 1
	lb $t2, ($t1) #load $t1 to $t2
	addi $t1, $t1, 1 #increment address $t1 + 1 
	lb $t3, ($t1) #load $t1 to $t3
	addi $t1, $t1, 1 #increment address $t1 + 1 
	lb $t4, ($t1) #load $t1 to $t4
	add $s6, $s6, $t2 #add $s6 +$t2 for further checking
	bne $t2, $t3, wincondition2 #check if the values are same, jump to next wincondition
	bne $t3, $t4, wincondition2 #check if the values are same, jump to next wincondition
	beq $t2, 0, wincondition2 #check if $t2 is equal to 0 which is empty, jump to next wincondition
	j win #else jump to win

#check if all the values in first column has the same value
wincondition2:
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

#check if the position 1,5,9(diagonal) have the same value
wincondition3:
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

#check if all the values in second column have the same value
wincondition4:
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

#check if all the values in second row are same
wincondition5:
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

#check if positon 3,5,7(second diagonal) are same
wincondition6:
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

#check all the values in third column are same
wincondition7:
	li $s6, 0
	li $s5, 3
	la $t1, grid
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 3
	lb $t3, ($t1)
	addi $t1, $t1, 3
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, wincondition8
	bne $t3, $t4, wincondition8
	beq $t2, 0, wincondition8
	j win

#check if all the values in third row are same
wincondition8:
	li $s6, 0
	li $s5, 7
	la $t1, grid
	add $t1, $t1, $s5
	lb $t2, ($t1)
	addi $t1, $t1, 1
	lb $t3, ($t1)
	addi $t1, $t1, 1
	lb $t4, ($t1)
	add $s6, $s6, $t2
	bne $t2, $t3, turn #check if $t2!=t$t3 return to turn
	bne $t3, $t4, turn #check if $t4!=t$t3 return to turn
	beq $t2, 0, turn #check if $t2 has mssing values, retur to turn
	j win #else jump to win
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
