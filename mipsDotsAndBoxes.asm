.data
newline: '\n'
dot:		.asciiz "*"
dash:	.asciiz "-"
pipe:	.asciiz "|"
space:		.asciiz " "
box: .asciiz "X"
cols: .asciiz "  1   2   3   4   5   6   7   8   9\n"
rows: .asciiz "a"
	.asciiz "b"
	.asciiz "c"
	.asciiz "d"
	.asciiz "e"
	.asciiz "f"
	.asciiz "g"
a: .asciiz "a"
b: .asciiz "b"
c: .asciiz "c"
d: .asciiz "d"
e: .asciiz "e"
f: .asciiz "f"
g: .asciiz "g"
invalidMove: .asciiz "Invalid move\n"
madeBox: .asciiz "MADE BOX!\n"
WINS: .asciiz "WINS\n"
TIE: .asciiz "TIE\n"
test: .asciiz "test\n"
printGameOver: .asciiz "Game Over!\n"
bool_hor_a: .word 0, 0, 0, 0, 0, 0, 0, 0
bool_hor_b: .word 0, 0, 0, 0, 0, 0, 0, 0
bool_hor_c: .word 0, 0, 0, 0, 0, 0, 0, 0
bool_hor_d: .word 0, 0, 0, 0, 0, 0, 0, 0
bool_hor_e: .word 0, 0, 0, 0, 0, 0, 0, 0
bool_hor_f: .word 0, 0, 0, 0, 0, 0, 0, 0
bool_hor_g: .word 0, 0, 0, 0, 0, 0, 0, 0

bool_vert_a: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
bool_vert_b: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
bool_vert_c: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
bool_vert_d: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
bool_vert_e: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
bool_vert_f: .word 0, 0, 0, 0, 0, 0, 0, 0, 0

boxes_a: .word 0, 0, 0, 0, 0, 0, 0, 0
boxes_b: .word 0, 0, 0, 0, 0, 0, 0, 0
boxes_c: .word 0, 0, 0, 0, 0, 0, 0, 0
boxes_d: .word 0, 0, 0, 0, 0, 0, 0, 0
boxes_e: .word 0, 0, 0, 0, 0, 0, 0, 0
boxes_f: .word 0, 0, 0, 0, 0, 0, 0, 0

p1: .asciiz "  p1: "
p2: .asciiz " p2: "

p1_score: .word 0
p2_score: .word 0

p1_turn: .asciiz "p1's turn: "
p2_turn: .asciiz "p2's turn: "

curr_turn: .word 0
        
.text
.globl main, updateVert, updateHoriz, printBoard, printTest, updateScore, nextTurn, selHArr, selCArr, iToC
	main:	
		jal printBoard
		Turn:
		
			#prints whose turn it is
			lw $t0, curr_turn
			beq $t0, 0, currp1 #if 0, p1
				la $a0, p2_turn #else, p2 (bot)
				li $v0, 4
				syscall
				#bot move
				jal botMove
				j currp2
				
			currp1:
				la $a0, p1_turn
				li $v0, 4
				syscall
				
				#asks for user next move
				jal newMove
				
			currp2:
			#updates turn
			jal nextTurn
			
		j Turn	#loops to do another turn
		
		li $v0, 10
		syscall

		
	printBoard:
		#print p1 score
		la $a0 p1
		li $v0 4
		syscall
		lw $t0 p1_score
		move $a0 $t0
		li $v0 1
		syscall
		
		#print p2 score
		la $a0 p2
		li $v0 4
		syscall
		lw $t0 p2_score
		move $a0 $t0
		li $v0 1
		syscall
		la $a0 newline
		li $v0 4
		syscall	
		
		#print 1 2 3 4 5 6 7 8 9
		li $v0, 4
		la $a0, cols
		syscall	
		
		#set $t0 (row increment) to 0
		li $t0 0
		
		#loop through rows a-f
		LoopRow: 
		
			#loop until row increment = 6
			bge $t0, 6, exitLoopRow
			
			#set $t2 to double of $t0 (row increment)
			add $t2, $t0, $t0
			
			#prepare to print
			li $v0, 4
			
			#print current row letter
			la $a0, rows($t2)
			syscall
			
			#print space
			la $a0 space
			syscall
			
			#set $t1 (column increment) to 0
			li $t1 0
			
			LoopDashes:
			
				#loop until column increment = 7 (8 times total)
				bge $t1 8 exitLoopDashes
				
				#print "*"
				la $a0 dot
				syscall
				
				#prints " "
				la $a0 space
				syscall
				
				#branch depending on $t0 (row increment)
				beq $t0, 0, selectADash
				beq $t0, 1, selectBDash
				beq $t0, 2, selectCDash
				beq $t0, 3, selectDDash
				beq $t0, 4, selectEDash
				beq $t0, 5, selectFDash
				
				#load horizontal array depending on row
				selectADash:
					la $v0, bool_hor_a
					j printDashes
				selectBDash:
					la $v0, bool_hor_b
					j printDashes
				selectCDash:
					la $v0, bool_hor_c
					j printDashes
				selectDDash:
					la $v0, bool_hor_d
					j printDashes
				selectEDash:
					la $v0, bool_hor_e
					j printDashes
				selectFDash:
					la $v0, bool_hor_f
					j printDashes
					
				#print dashes
				printDashes:
				
				#multiply $t1 (column increment) by 4 and store in $t2
				add $t2, $t1, $t1
				add $t2, $t2, $t2
				
				#add $t2 (offset) to $v0 (horizontal array address)
				add $v0, $v0, $t2
				
				#load coordinate value into $a0
				lw $a0, ($v0)
				
				#if value 1, print dash
				beq $a0, 1, printDash
				
				#else, print space
				li $v0, 4
				la $a0, space
				j noDash
				
				#print dash
				printDash:
				li $v0, 4
				la $a0, dash
				
				#print space or dash
				noDash:
				syscall
				
				#print another space
				la $a0, space
				syscall
			
				#increment $t1 (column increment)
				add $t1, $t1, 1
				
				#loop
				j LoopDashes
			
			#finished dash loop
			exitLoopDashes:
			
			#print dot
			la $a0, dot
			syscall
			
			#print newline
			la $a0, newline
			syscall
			
			#print two spaces
			la $a0, space
			syscall
			syscall
			
			#load 0 into $t0 (column increment)
			li $t1 0
			
			LoopPipe:
				
				#loop until column increment = 7 (8 times total)
				bge  $t1, 8, exitLoopPipe
				
				#branch depending on $t0 (row increment)
				beq $t0, 0, selectAPipe
				beq $t0, 1, selectBPipe
				beq $t0, 2, selectCPipe
				beq $t0, 3, selectDPipe
				beq $t0, 4, selectEPipe
				beq $t0, 5, selectFPipe
				
				#load vertical and box array depending on row
				selectAPipe:
					la $v0, bool_vert_a
					la $v1, boxes_a
					j printPipes
				selectBPipe:
					la $v0, bool_vert_b
					la $v1, boxes_b
					j printPipes
				selectCPipe:
					la $v0, bool_vert_c
					la $v1, boxes_c
					j printPipes
				selectDPipe:
					la $v0, bool_vert_d
					la $v1, boxes_d
					j printPipes
				selectEPipe:
					la $v0, bool_vert_e
					la $v1, boxes_e
					j printPipes
				selectFPipe:
					la $v0, bool_vert_f
					la $v1, boxes_f
					j printPipes
					
				#print pipes
				printPipes:
				
				#store $v0 (pipe array address) in $s0 (for later)
				move $s0, $v0
				
				#multiply $t1 (column increment) by 4 and store in $t2
				add $t2, $t1, $t1
				add $t2, $t2, $t2
				
				#add $t2 (offset) to $v0 (horizontal array address)
				add $v0, $v0, $t2
				
				#load coordinate value into $a0
				lw $a0, ($v0)
				
				#if value 1, print pipe
				beq $a0, 1, printPipe
				
				#else, print space
				li $v0, 4
				la $a0, space
				j noPipe
				
				#print pipe
				printPipe:
				li $v0, 4
				la $a0, pipe
				
				#print space or pipe
				noPipe:
				syscall
				
				#print another space
				li $v0, 4
				la $a0, space
				syscall
				
				#determine whether to print box
				add $v1, $v1, $t2
				lw $a0, ($v1)
				beq $a0, 1, printBox
				
				#no box
				li $v0, 4
				la $a0, space
				j noBox
				
				#print box
				printBox:
				li $v0, 4
				la $a0, box
				
				#print space or box
				noBox:
				syscall
				
				#print another space
				la $a0, space
				syscall
				
				#increment $t1 (column increment)		
				add $t1, $t1, 1
				
				#loop
				j LoopPipe
			
			#finished pipe loop
			exitLoopPipe:
			
			#determine whether to print final pipe
			add $s0, $s0, 32
			lw $s0, ($s0)
			beq $s0, 1, printFinalPipe
			
			#no final pipe
			li $v0, 4
			la $a0, space
			j noFinalPipe
			
			#print box
			printFinalPipe:
			li $v0, 4
			la $a0, pipe
			
			#print space or box
			noFinalPipe:
			syscall
			
			#print new line
			la $a0, newline
			syscall
			
			#increment $t0 (row increment)
			add $t0, $t0, 1
			
			#iterate next row
			j LoopRow
		
		
		#finished all rows a-f
		exitLoopRow:
		
		#set $t2 to 12
		add $t2, $t0, $t0
			la $a0, rows($t2)
			syscall
			la $a0, space
			syscall
			li $t1, 0
			Loop4: bge $t1, 8, exitLoop4	#prints last row
				la $a0, dot
				syscall
				la $a0, space
				syscall
				
				la $v0, bool_hor_g
				
				add $t2, $t1, $t1		#v0 (array address) is incremented
				add $t2, $t2, $t2
				add $v0, $v0, $t2
				lw $a0, ($v0)
				beq $a0, 1, printDash2
					li $v0, 4
					la $a0, space
				j noDash2
				printDash2:
					li $v0, 4
					la $a0, dash
				noDash2:
				syscall
				la $a0, space
				syscall
				add $t1, $t1, 1
				j Loop4
			exitLoop4:
			la $a0, dot
			syscall
			la $a0, newline
			syscall
			syscall	
			add $t0, $t0, 1
				
		jr $ra
	

	printInvalidMove:
		
		#print "invalid move"
		li $v0, 4
		la $a0, invalidMove
		syscall
		
		#ask user input again
		j newMove


	#ALL LINE UPDATES
	
	updateVert:
		
		#move $v0 (num input) to $t0 and $s3 (for later)
		move $t0, $v0
		move $s3, $v0
		
		#multiply $t0 (num input) by 4
		add $t0, $t0, $t0
		add $t0, $t0, $t0
		
		#subtract $t0 (num input) by 4
		sub $t0, $t0, 4
		
		#check which letter user inputted and branch
		lb $t1, a
    		beq $t1, $s0, loadBoolVertA
    		lb $t1, b
    		beq $t1, $s0, loadBoolVertB
    		lb $t1, c
    		beq $t1, $s0, loadBoolVertC
    		lb $t1, d
    		beq $t1, $s0, loadBoolVertD
    		lb $t1, e
    		beq $t1, $s0, loadBoolVertE
    		lb $t1, f
    		beq $t1, $s0, loadBoolVertF
    		
    		#if letter doesn't exist, print invalid
    		j printInvalidMove
    		
    		#load address of array for letter
    		loadBoolVertA:
    			li $s1, 1 #save s1 as 1 (a) for later
    			la $v0, bool_vert_a
    			j vertExitSwitch
    		loadBoolVertB:
    			li $s1, 2 #save s1 as 2 (b) for later
    			la $v0, bool_vert_b
    			j vertExitSwitch
    		loadBoolVertC:
    			li $s1, 3 #save s1 as 3 (c) for later
    			la $v0, bool_vert_c
    			j vertExitSwitch
    		loadBoolVertD:
    			li $s1, 4 #save s1 as 4 (d) for later
    			la $v0, bool_vert_d
    			j vertExitSwitch
    		loadBoolVertE:
    			li $s1, 5 #save s1 as 5 (e) for later
    			la $v0, bool_vert_e
    			j vertExitSwitch
    		loadBoolVertF:
    			li $s1, 6 #save s1 as 6 (f) for later
    			la $v0, bool_vert_f
    			j vertExitSwitch
    		
    		vertExitSwitch:
		#add $t0 (num input) to $v0 (array address)
		add $v0, $v0, $t0
		
		#load $v0 (coordinate address) to $t0
		lw $t0, ($v0)
		
		#check if valid move
		beq $t0, 1, printInvalidMove
		
		#change value to 1
		li $t1, 1
		sw $t1, ($v0)
		
		#update boxes
		j updateBoxesVert
		
	updateHoriz:
		
		#move $v0 (num input) to $t0 and $s3 (for later)
		move $t0, $v0
		move $s3, $v0
		
		#multiply $t0 by 4
		add $t0, $t0, $t0
		add $t0, $t0, $t0
		
		#subtract $t0 by 4
		sub $t0, $t0, 4
		
		#branch based on user inputted letter
		lb $t1, a
    		beq $t1, $s0, loadBoolHorizA
    		lb $t1, b
    		beq $t1, $s0, loadBoolHorizB
    		lb $t1, c
    		beq $t1, $s0, loadBoolHorizC
    		lb $t1, d
    		beq $t1, $s0, loadBoolHorizD
    		lb $t1, e
    		beq $t1, $s0, loadBoolHorizE
    		lb $t1, f
    		beq $t1, $s0, loadBoolHorizF
    		lb $t1, g
    		beq $t1, $s0, loadBoolHorizG
    		
    		#print invalid move if letter not between a-g
    		j printInvalidMove
    		
    		#store bool_vert into $v0
    		loadBoolHorizA:
    			li $s1, 1 #save s1 as 1 (a) for later
    			la $v0 bool_hor_a
    			j horizExitSwitch
    		loadBoolHorizB:
    			li $s1, 2 #save s1 as 2 (b) for later
    			la $v0 bool_hor_b
    			j horizExitSwitch
    		loadBoolHorizC:
    			li $s1, 3 #save s1 as 3 (c) for later
    			la $v0 bool_hor_c
    			j horizExitSwitch
    		loadBoolHorizD:
    			li $s1, 4 #save s1 as 4 (d) for later
    			la $v0 bool_hor_d
    			j horizExitSwitch
    		loadBoolHorizE:
    			li $s1, 5 #save s1 as 5 (e) for later
    			la $v0 bool_hor_e
    			j horizExitSwitch
    		loadBoolHorizF:
    			li $s1, 6 #save s1 as 6 (f) for later
    			la $v0 bool_hor_f
    			j horizExitSwitch
    		loadBoolHorizG:
    			li $s1, 7 #save s1 as 7 (g) for later
    			la $v0 bool_hor_g
    			j horizExitSwitch
    		horizExitSwitch:
		
		#add $t0 to $v0
		add $v0, $v0, $t0
		
		
		#load $v0 to $t0
		lw $t0, ($v0)
		
		#check if valid move
		beq $t0, 1, printInvalidMove
		
		#change value to 1
		li $t1, 1
		sw $t1, ($v0)
		
		#update boxes
		j updateBoxesHor
		
	
	updateBoxesVert:
		
		#branch based on what row line was drawn
		beq $s1, 1, origVertRowA
		beq $s1, 2, origVertRowB
		beq $s1, 3, origVertRowC
		beq $s1, 4, origVertRowD
		beq $s1, 5, origVertRowE
		beq $s1, 6, origVertRowF
		
		#load necessary array addresses based on original row
		origVertRowA:
		la $s0, bool_hor_a
		la $s1, bool_vert_a
		la $s2, bool_hor_b
		la $s4, boxes_a
		j checkRightVert
		
		origVertRowB:
		la $s0, bool_hor_b
		la $s1, bool_vert_b
		la $s2, bool_hor_c
		la $s4, boxes_b
		j checkRightVert
		
		origVertRowC:
		la $s0, bool_hor_c
		la $s1, bool_vert_c
		la $s2, bool_hor_d
		la $s4, boxes_c
		j checkRightVert
		
		origVertRowD:
		la $s0, bool_hor_d
		la $s1, bool_vert_d
		la $s2, bool_hor_e
		la $s4, boxes_d
		j checkRightVert
		
		origVertRowE:
		la $s0, bool_hor_e
		la $s1, bool_vert_e
		la $s2, bool_hor_f
		la $s4, boxes_e
		j checkRightVert
		
		origVertRowF:
		la $s0, bool_hor_f
		la $s1, bool_vert_f
		la $s2, bool_hor_g
		la $s4, boxes_f
		j checkRightVert
		
		
	updateBoxesHor:
		
		#branch based on what row line was drawn
		beq $s1, 1, origHorRowA
		beq $s1, 2, origHorRowB
		beq $s1, 3, origHorRowC
		beq $s1, 4, origHorRowD
		beq $s1, 5, origHorRowE
		beq $s1, 6, origHorRowF
		beq $s1, 7, origHorRowG
		
		#load necessary array addresses based on original row
		origHorRowA:
		la $s4, boxes_a
		la $s5, bool_vert_a
		la $s6, bool_hor_b
		li $t2, 0 #because going straight to bottom hor, need to set $t2 (box created bool) to 0
		j checkBottomHor
		
		origHorRowB:
		la $s0, bool_hor_a
		la $s1, bool_vert_a
		la $s2, boxes_a
		la $s4, boxes_b
		la $s5, bool_vert_b
		la $s6, bool_hor_c
		j checkTopHor
		
		origHorRowC:
		la $s0, bool_hor_b
		la $s1, bool_vert_b
		la $s2, boxes_b
		la $s4, boxes_c
		la $s5, bool_vert_c
		la $s6, bool_hor_d
		j checkTopHor
		
		origHorRowD:
		la $s0, bool_hor_c
		la $s1, bool_vert_c
		la $s2, boxes_c
		la $s4, boxes_d
		la $s5, bool_vert_d
		la $s6, bool_hor_e
		j checkTopHor
		
		origHorRowE:
		la $s0, bool_hor_d
		la $s1, bool_vert_d
		la $s2, boxes_d
		la $s4, boxes_e
		la $s5, bool_vert_e
		la $s6, bool_hor_f
		j checkTopHor
		
		origHorRowF:
		la $s0, bool_hor_e
		la $s1, bool_vert_e
		la $s2, boxes_e
		la $s4, boxes_f
		la $s5, bool_vert_f
		la $s6, bool_hor_g
		j checkTopHor
		
		origHorRowG:
		la $s0, bool_hor_f
		la $s1, bool_vert_f
		la $s2, boxes_f
		li $s7, 1 #set $s7 to 1 so don't check bottom box later
		j checkTopHor
		
	updateScore:
		lw $t3, curr_turn
		beq $t3, 0, p1Point	#if it is p1's turn update p1 score
			lw $t4, p2_score	#else update p2 score
			addi $t4, $t4, 1
			sw $t4, p2_score
			j p2Point
		p1Point:
			lw $t4, p1_score
			addi $t4, $t4, 1
			sw $t4, p1_score
		p2Point:
		
		#adds and checks total score
		lw $t5, p2_score
		lw $t4, p1_score
		add $t0, $t4, $t5
		bge $t0, 48, gameOver
		
		jr $ra
		
		gameOver:
		
		#prints game over
		li $v0, 4
		la $a0, printGameOver
		syscall
		
		#prints score
		li $v0, 4
		la $a0, p1
		syscall
		
		li $v0, 1
		move $a0, $t4
		syscall
		
		li $v0, 4
		la $a0, p2
		syscall
		
		li $v0, 1
		move $a0, $t5
		syscall
		
		li $v0, 4
		la $a0, newline
		syscall
		
		
		#prints winner
		bgt $t4, $t5, p1Wins
		bgt $t5, $t4, p2Wins
		
		#prints tie
		la $a0, TIE
		syscall
		
		#exit
		li $v0, 10
		syscall
		
		#prints p1wins
		p1Wins:
		la $a0, p1
		syscall
		
		la $a0, WINS
		syscall
		
		#exit
		li $v0, 10
		syscall
		
		#prints p2wins
		p2Wins:
		la $a0, p2
		syscall
		
		la $a0, WINS
		syscall
		
		#exit
		li $v0, 10
		syscall
		
		
	nextTurn:
	
		#check who just played
		lw $t3, curr_turn	
		beq $t3, 0, p1Turn
		
			#bot tutn
			move $t3, $zero
			j p2Turn
			
		#p1 moved
		p1Turn:
			addi $t3,  $t3, 1
			
		p2Turn:
		sw $t3, curr_turn
		jr $ra
	
	selHArr:	#a0 = row # v0 = row arr adress (finds row adress for given row index)
		beq $a0, 0, hA
		beq $a0, 1, hB
		beq $a0, 2, hC
		beq $a0, 3, hD
		beq $a0, 4, hE
		beq $a0, 5, hF
		beq $a0, 6, hG
		
		hA:
			la $v0, bool_hor_a
			j exitsSelHArr
		hB:
			la $v0, bool_hor_b
			j exitsSelHArr
		hC:
			la $v0, bool_hor_c
			j exitsSelHArr
		hD:
			la $v0, bool_hor_d
			j exitsSelHArr
		hE:
			la $v0, bool_hor_e
			j exitsSelHArr
		hF:
			la $v0, bool_hor_f
			j exitsSelHArr
		hG:
			la $v0, bool_hor_g
			j exitsSelHArr
		exitsSelHArr:
	jr $ra
	
	selCArr:	#a0 = coloumn # v0 = col arr adress (finds column adress for given col index)
		beq $a0, 0, cA
		beq $a0, 1, cB
		beq $a0, 2, cC
		beq $a0, 3, cD
		beq $a0, 4, cE
		beq $a0, 5, cF
		
		cA:
			la $v0, bool_vert_a
			j exitsSelCArr
		cB:
			la $v0, bool_vert_b
			j exitsSelCArr
		cC:
			la $v0, bool_vert_c
			j exitsSelCArr
		cD:
			la $v0, bool_vert_d
			j exitsSelCArr
		cE:
			la $v0, bool_vert_e
			j exitsSelCArr
		cF:
			la $v0, bool_vert_f
			j exitsSelCArr
		exitsSelCArr:
	jr $ra
	
	iToC:	#a0 = row index #v0 = row letter in byte form (changes from number to letter)
		beq $a0, 0, charA
		beq $a0, 1, charB
		beq $a0, 2, charC
		beq $a0, 3, charD
		beq $a0, 4, charE
		beq $a0, 5, charF
		beq $a0, 6, charG
		charA:
			lb $v0 a
			j exitIToC
		charB:
			lb $v0 b
			j exitIToC
		charC:
			lb $v0 c
			j exitIToC
		charD:
			lb $v0 d
			j exitIToC
		charE:
			lb $v0 e
			j exitIToC
		charF:
			lb $v0 f
			j exitIToC
		charG:
			lb $v0 g
			j exitIToC
		exitIToC:
	jr $ra


printTest:
li $v0, 4
la $a0, test
syscall


