
.data

madeBox: .asciiz "MADE BOX!\n"


.text

.globl checkRightVert, checkTopHor, checkBottomHor


		#VERTICAL BOX
		
		#check right box
		checkRightVert:
		
		#set $t2 (box boolean) to 0
		li $t2, 0
		
		#if last column, only check left box
		beq $s3, 9, checkLeftVert
		
		#check right pipe
		checkRightPipeVert:
		
		#move $s3 (num input) to $t0
		move $t0, $s3
		
		#multiply $t0 (num input) by 4
		add $t0, $t0, $t0
		add $t0, $t0, $t0
		
		#move $s1 (pipe array address) to $t1
		move $t1, $s1
		
		#add $t0 (offset) to $t1 (pipe array address)
		add $t1, $t1, $t0
		
		#if no pipe, check left vert
		lw $t1, ($t1)
		beq $t1, 0, checkLeftVert
			
		#else, check top right
		checkTopRightVert:
		
		#move $s3 (num input) to $t0
		move $t0, $s3
		
		#multiply $t0 (num input) by 4
		add $t0, $t0, $t0
		add $t0, $t0, $t0
		
		#subtract $t0 by 4
		sub $t0, $t0, 4
		
		#move $s0 (top dash array address) to $t1
		move $t1, $s0
		
		#add $t0 (offset) to $t1 (top dash array address)
		add $t1, $t1, $t0
		
		#if no dash, check left vert
		lw $t1, ($t1)
		beq $t1, 0, checkLeftVert
		
		#else, check bottom right
		checkBottomRightVert:
		
		#move $s3 (num input) to $t0
		move $t0, $s3
		
		#multiply $t0 (num input) by 4
		add $t0, $t0, $t0
		add $t0, $t0, $t0
		
		#subtract $t0 by 4
		sub $t0, $t0, 4
		
		#move $s2 (bottom dash array address) to $t1
		move $t1, $s2
		
		#add $t0 (offset) to $t1 (bottom dash array address)
		add $t1, $t1, $t0
		
		#if no dash, check left vert
		lw $t1, ($t1)
		beq $t1, 0, checkLeftVert
		
		#else, add box
		addBoxRightVert:
			
			#move $s3 (num input) to $t0
			move $t0, $s3
			
			#multiply $t0 (num input) by 4
			add $t0, $t0, $t0
			add $t0, $t0, $t0
			
			#subtract $t0 by 4
			sub $t0, $t0, 4
			
			#move $s4 (boxes array address) to $t1
			move $t1, $s4
			
			#add $t0 (offset) to $t1 (boxes array address)
			add $t1, $t1, $t0
			
			#set box value to 1
			li $t2, 1
			sw $t2, ($t1)
			
			#print "made box"
			li $v0, 4
			la $a0, madeBox
			syscall
			
			#update score
			addi $sp $sp -4
			sw $ra 0($sp)
			jal updateScore
			lw $ra 0($sp)
			addi $sp $sp 4
			
			#if not first column, check left vert
			bgt $s3, 1, checkLeftVert
			
			#if first column, print board and move again
			leftColumnRightBoxPrintBoard:
			addi $sp $sp -4
			sw $ra 0($sp)
			jal nextTurn
			lw $ra 0($sp)
			addi $sp $sp 4
			j printBoard
		

		#check left box
		checkLeftVert:
		
		#check left pipe
		checkLeftPipeVert:
		
		#move $s3 (num input) to $t0
		move $t0, $s3
		
		#multiply $t0 (num input) by 4
		add $t0, $t0, $t0
		add $t0, $t0, $t0
		
		#subtract $t0 (offset) by 8
		sub $t0, $t0, 8
		
		#move $s1 (pipe array address) to $t1
		move $t1, $s1
		
		#add $t0 (offset) to $t1 (pipe array address)
		add $t1, $t1, $t0
		
		#if pipe exists check top left vert
		lw $t1, ($t1)
		beq $t1, 1, checkTopLeftVert
		
		#else, if previous box wasn't created, print board
		beq $t2, 0, printBoard
		
		#else, move again and print board
		addi $sp $sp -4
		sw $ra 0($sp)
		jal nextTurn
		lw $ra 0($sp)
		addi $sp $sp 4
		j printBoard
		
		#else, check top left
		checkTopLeftVert:
		
		#move $s3 (num input) to $t0
		move $t0, $s3
		
		#multiply $t0 (num input) by 4
		add $t0, $t0, $t0
		add $t0, $t0, $t0
		
		#subtract $t0 by 8
		sub $t0, $t0, 8
		
		#move $s0 (top dash array address) to $t1
		move $t1, $s0
		
		#add $t0 (offset) to $t1 (top dash array address)
		add $t1, $t1, $t0
		
		#if dash exists check bottom left vert
		lw $t1, ($t1)
		beq $t1, 1, checkBottomLeftVert
		
		#else, if previous box wasn't created, print board
		beq $t2, 0, printBoard
		
		#else, move again and print board
		addi $sp $sp -4
		sw $ra 0($sp)
		jal nextTurn
		lw $ra 0($sp)
		addi $sp $sp 4
		j printBoard
		
		#else, check bottom left
		checkBottomLeftVert:
		
		#move $s3 (num input) to $t0
		move $t0, $s3
		
		#multiply $t0 (num input) by 4
		add $t0, $t0, $t0
		add $t0, $t0, $t0
		
		#subtract $t0 by 8
		sub $t0, $t0, 8
		
		#move $s2 (bottom dash array address) to $t1
		move $t1, $s2
		
		#add $t0 (offset) to $t1 (bottom dash array address)
		add $t1, $t1, $t0
		
		#if dash exists, add box
		lw $t1, ($t1)
		beq $t1, 1, addBoxLeftVert
		
		#else, if previous box wasn't created, print board
		beq $t2, 0, printBoard
		
		#else, move again and print board
		addi $sp $sp -4
		sw $ra 0($sp)
		jal nextTurn
		lw $ra 0($sp)
		addi $sp $sp 4
		j printBoard
		
		#else, add box
		addBoxLeftVert:
		
			#move $s3 (num input) to $t0
			move $t0, $s3
			
			#multiply $t0 (num input) by 4
			add $t0, $t0, $t0
			add $t0, $t0, $t0
			
			#subtract $t0 by 4
			sub $t0, $t0, 8
			
			#move $s4 (boxes array address) to $t1
			move $t1, $s4
			
			#add $t0 (offset) to $t1 (boxes array address)
			add $t1, $t1, $t0
			
			#set box value to 1
			li $t2, 1
			sw $t2, ($t1)
			
			#print made box
			li $v0, 4
			la $a0, madeBox
			syscall
			
			#update score
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			jal updateScore
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			
			#move again and print board
			addi $sp $sp -4
			sw $ra 0($sp)
			jal nextTurn
			lw $ra 0($sp)
			addi $sp $sp 4
			j printBoard
		
		#print board
		j printBoard
		
		
		
		
		#HORIZONTAL BOX
		
		#check top box
		checkTopHor:
		
		#set $t2 (box boolean) to 0
		li $t2, 0
		
		#check top dash
		checkTopDashHor:
		
		#move $s3 (num input) to $t0
		move $t0, $s3
		
		#multiply $t0 (num input) by 4
		add $t0, $t0, $t0
		add $t0, $t0, $t0
		
		#subtract $t0 (offset) by 4
		sub $t0, $t0, 4
		
		#move $s0 (top dash array address) to $t1
		move $t1, $s0
		
		#add $t0 (offset) to $t1 (top dash array address)
		add $t1, $t1, $t0
		
		#if no dash, check bottom hor
		lw $t1, ($t1)
		beq $t1, 0, checkBottomHor
		
		#else, check top left pipe
		checkTopLeftHor:
		
		#move $s3 (num input) to $t0
		move $t0, $s3
		
		#multiply $t0 (num input) by 4
		add $t0, $t0, $t0
		add $t0, $t0, $t0
		
		#subtract $t0 by 4
		sub $t0, $t0, 4
		
		#move $s1 (top pipe array address) to $t1
		move $t1, $s1
		
		#add $t0 (offset) to $t1 (top pipe array address)
		add $t1, $t1, $t0
		
		#if no pipe, check bottom hor
		lw $t1, ($t1)
		beq $t1, 0, checkBottomHor
		
		#else, check top right pipe
		checkTopRightHor:
		
		#move $s3 (num input) to $t0
		move $t0, $s3
		
		#multiply $t0 (num input) by 4
		add $t0, $t0, $t0
		add $t0, $t0, $t0
		
		#move $s1 (top pipe array address) to $t1
		move $t1, $s1
		
		#add $t0 (offset) to $t1 (top pipe array address)
		add $t1, $t1, $t0
		
		#if no pipe, check bottom hor
		lw $t1, ($t1)
		beq $t1, 0, checkBottomHor
		
		#else, add box
		addBoxTopHor:
			
			#move $s3 (num input) to $t0
			move $t0, $s3
			
			#multiply $t0 (num input) by 4
			add $t0, $t0, $t0
			add $t0, $t0, $t0
			
			#subtract $t0 by 4
			sub $t0, $t0, 4
			
			#move $s2 (top boxes array address) to $t1
			move $t1, $s2
			
			#add $t0 (offset) to $t1 (top boxes array address)
			add $t1, $t1, $t0
			
			#set box value to 1
			li $t2, 1
			sw $t2, ($t1)
			
			#print "made box"
			li $v0, 4
			la $a0, madeBox
			syscall
			
			#update score
			addi $sp $sp -4
			sw $ra 0($sp)
			jal updateScore
			lw $ra 0($sp)
			addi $sp $sp 4
			
			
			#if not row g, check bottom horizontal
			bne $s7, 1, checkBottomHor
			
			#if row g, print board and move again
			rowGTopBoxPrintBoard:
			addi $sp $sp -4
			sw $ra 0($sp)
			jal nextTurn
			lw $ra 0($sp)
			addi $sp $sp 4
			j printBoard
			
			#if row g, print board
			#beq $s7, 1, printBoard
			
			#else, check bottom hor
			#j checkBottomHor
		

		
		#check bottom box
		checkBottomHor:
		
		#check bottom dash
		checkBottomDashHor:
		
		#move $s3 (num input) to $t0
		move $t0, $s3
		
		#multiply $t0 (num input) by 4
		add $t0, $t0, $t0
		add $t0, $t0, $t0
		
		#subtract $t0 (offset) by 4
		sub $t0, $t0, 4
		
		#move $s6 (bottom dash array address) to $t1
		move $t1, $s6
		
		#add $t0 (offset) to $t1 (bottom dash array address)
		add $t1, $t1, $t0

		#if dash exists, check bottom left hor
		lw $t1, ($t1)
		beq $t1, 1, checkBottomLeftHor
		
		#else, if previous box wasn't created, print board
		beq $t2, 0, printBoard
				
		#else, move again and print board
		addi $sp $sp -4
		sw $ra 0($sp)
		jal nextTurn
		lw $ra 0($sp)
		addi $sp $sp 4
		j printBoard
		
		#else, check bottom left
		checkBottomLeftHor:
		
		#move $s3 (num input) to $t0
		move $t0, $s3
		
		#multiply $t0 (num input) by 4
		add $t0, $t0, $t0
		add $t0, $t0, $t0
		
		#subtract $t0 by 4
		sub $t0, $t0, 4
		
		#move $s5 (bottom pipe array address) to $t1
		move $t1, $s5
		
		#add $t0 (offset) to $t1 (bottom pipe array address)
		add $t1, $t1, $t0
		
		#if pipe exists, check bottom right hor
		lw $t1, ($t1)
		beq $t1, 1, checkBottomRightHor
		
		#else, if previous box wasn't created, print board
		beq $t2, 0, printBoard
		
		#else, move again and print board
		addi $sp $sp -4
		sw $ra 0($sp)
		jal nextTurn
		lw $ra 0($sp)
		addi $sp $sp 4
		j printBoard
		
		#else, check bottom right
		checkBottomRightHor:
		
		#move $s3 (num input) to $t0
		move $t0, $s3
		
		#multiply $t0 (num input) by 4
		add $t0, $t0, $t0
		add $t0, $t0, $t0
		
		#move $s5 (bottom pipe array address) to $t1
		move $t1, $s5
		
		#add $t0 (offset) to $t1 (bottom pipe array address)
		add $t1, $t1, $t0
		
		#if pipe exists, add box
		lw $t1, ($t1)
		beq $t1, 1, addBoxBottomHor
		
		#else, if previous box wasn't created, print board
		beq $t2, 0, printBoard
		
		#else, move again and print board
		addi $sp $sp -4
		sw $ra 0($sp)
		jal nextTurn
		lw $ra 0($sp)
		addi $sp $sp 4
		j printBoard
		
		#else, add box
		addBoxBottomHor:
		
			#move $s3 (num input) to $t0
			move $t0, $s3
			
			#multiply $t0 (num input) by 4
			add $t0, $t0, $t0
			add $t0, $t0, $t0
			
			#subtract $t0 by 4
			sub $t0, $t0, 4
			
			#move $s4 (boxes array address) to $t1
			move $t1, $s4
			
			#add $t0 (offset) to $t1 (boxes array address)
			add $t1, $t1, $t0
			
			#set box value to 1
			li $t2, 1
			sw $t2, ($t1)
			
			#print made box
			li $v0, 4
			la $a0, madeBox
			syscall
			
			#update score
			addi $sp $sp -4
			sw $ra 0($sp)
			jal updateScore
			lw $ra 0($sp)
			addi $sp $sp 4
			
			#move again and print board
			addi $sp $sp -4
			sw $ra 0($sp)
			jal nextTurn
			lw $ra 0($sp)
			addi $sp $sp 4
			j printBoard
			
		
		#print board
		j printBoard




