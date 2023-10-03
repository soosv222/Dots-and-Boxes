.data
a: .asciiz "a"
b: .asciiz "b"
c: .asciiz "c"
d: .asciiz "d"
e: .asciiz "e"
f: .asciiz "f"
g: .asciiz "g"
rightOrDown: .asciiz "Right or down? 1 if right, 2 if down.\n" 
letterQuestion: .asciiz "Letter?\n"
numberQuestion: .asciiz "Number?\n"
input: .space 80
inputSize: .word 81
prev_dir: .word 1 #1 IS RIGHT, 2  is down
prev_letter:  .asciiz " "
prev_num: .word 0
debug: .asciiz "\n"

.text

.globl newMove, botMove
	
	newMove:
		li $v0 4
		la $a0 rightOrDown #ask if right or down
		syscall
		
		li $v0 5 #read input right or down
		syscall
		
		move $t0 $v0 #move $v0 to $t0
		
		beq $t0 1 horizLine #if 1, horizontal line
		
		vertiLine:
			li $v0 4
			la $a0 letterQuestion #ask what letter
			syscall
			
			# Read letter 
    			li $v0, 8
    			la $a0, input
   			lw $a1, inputSize
   			syscall
    			
    			#branch based on letter
    			lb $a0, input
    			
    			move $s0 $a0
    			
    			li $v0 4
			la $a0 numberQuestion #ask what number
			syscall
			
			# Read number 
    			li $v0, 5
   			syscall
   			
   			j updateVert
   						
		
		horizLine:
			li $v0 4
			la $a0 letterQuestion #ask what letter
			syscall
			
			# Read letter 
    			li $v0, 8
    			la $a0, input
   			lw $a1, inputSize
   			syscall
    			
    			#branch based on letter
    			lb $a0, input
    			
    			move $s0 $a0
    			
    			li $v0 4
			la $a0 numberQuestion #ask what number
			syscall
			
			# Read number 
    			li $v0, 5
   			syscall
   			
   			j updateHoriz
		
		jr $ra
		
	botMove:
	
		li $t0 0
		hBotLoop1: beq $t0 6 exitHBotLoop1 #iterates through boxes to find one that can be filled this turn		
		
			addi $sp $sp -4	#store ra in stack
			sw $ra 0($sp)
			
			move $a0 $t0	#select top row array (t7)
			jal selHArr
			move $t7 $v0
			addi $a0 $a0 1	#select bottom row array (t6)
			jal selHArr
			move $t6 $v0
			move $a0 $t0	#sel col array (t5)
			jal selCArr
			move $t5 $v0
			
			lw $ra 0($sp)	#load ra from stack
			addi $sp $sp 4
			
			li $t1 0
			hBotLoop2: beq $t1 8 exitHBotLoop2
			
				li $t4 0 	#t4 is the edge counter
				add $t2 $t1 $t1
				add $t2 $t2 $t2	#t2 holds offset
				add $t3 $t7 $t2 #top line val addr
				
				lw $t3 ($t3)
				beq $t3 0 topEmpty #if top is empty
					addi $t4 $t4 1
				topEmpty:
				
				add $t3 $t5 $t2
				lw $t3 ($t3)
				beq $t3 0 leftEmpty #if left empty
					addi $t4 $t4 1
				leftEmpty:
				
				add $t3 $t5 $t2
				addi $t3 $t3 4
				lw $t3 ($t3)
				beq $t3 0 rightEmpty #if right is empty
					addi $t4 $t4 1
				rightEmpty:
							
				add $t3 $t6 $t2
				lw $t3 ($t3)
				beq $t3 0 btmEmpty #if btm is empt
					addi $t4 $t4 1
				btmEmpty:
				
				bne $t4 3 boxNotFillable
					add $t3 $t7 $t2 #top line val addr
					lw $t3 ($t3)
					beq $t3 1 topFull #if top is Full
						move $a0 $t0
						addi $sp $sp -4
						sw $ra 0($sp)
						jal iToC
						lw $ra 0($sp)
						addi $sp $sp 4
						move $s0 $v0
						addi $t1 $t1 1
						move $v0 $t1
								
						j updateHoriz
					topFull:
					
					add $t3 $t5 $t2
					lw $t3 ($t3)
					beq $t3 1 leftFull #if left Full
						move $a0 $t0
						addi $sp $sp -4
						sw $ra 0($sp)
						jal iToC
						lw $ra 0($sp)
						addi $sp $sp 4
						move $s0 $v0
						addi $t1 $t1 1
						move $v0 $t1
								
						j updateVert
					leftFull:
					
					add $t3 $t5 $t2
					addi $t3 $t3 4
					lw $t3 ($t3)
					beq $t3 1 rightFull #if right is Full
						move $a0 $t0
						addi $sp $sp -4
						sw $ra 0($sp)
						jal iToC
						lw $ra 0($sp)
						addi $sp $sp 4
						move $s0 $v0
						addi $t1 $t1 2
						move $v0 $t1
								
						j updateVert
					rightFull:
							
					add $t3 $t6 $t2
					lw $t3 ($t3)
					beq $t3 1 btmFull #if btm is Full
						move $a0 $t0
						addi $a0 $a0 1
						addi $sp $sp -4
						sw $ra 0($sp)
						jal iToC
						lw $ra 0($sp)
						addi $sp $sp 4
						move $s0 $v0
						addi $t1 $t1 1
						move $v0 $t1
								
						j updateHoriz
					btmFull:
				boxNotFillable:
			addi $t1 $t1 1
			j hBotLoop2
			exitHBotLoop2:
		addi $t0 $t0 1
		j hBotLoop1
		exitHBotLoop1:
		
		li $t0 0
		noBoxesVert1: beq $t0 6 exitNoBoxesVert1 #look for empty horiz line
			
			addi $sp $sp -4	#store ra in stack
			sw $ra 0($sp)
			
			move $a0 $t0	#select top row array (t7)
			jal selHArr
			move $t7 $v0
			addi $a0 $a0 1	#select bottom row array (t6)
			jal selHArr
			move $t6 $v0
			move $a0 $t0	#sel col array (t5)
			jal selCArr
			move $t5 $v0
			
			lw $ra 0($sp)	#load ra from stack
			addi $sp $sp 4
			
			li $t1 0
			noBoxesVert2: beq $t1 9 exitNoBoxesVert2
				add $t2 $t1 $t1
				add $t2 $t2 $t2	#t2 holds offset
			
				add $t3 $t5 $t2
				lw $t3 ($t3)
				beq $t3 1 skipCheck #if currCol empty
				currColEmpt:
					beq $t1 0 checkRight
						li $t4 0
						
						add $t3 $t5 $t2
						addi $t3 $t3 -4
						lw $t3 ($t3)
						beq $t3 0 leftLeftEmt
							addi $t4 $t4 1
						leftLeftEmt:
						
						add $t3 $t7 $t2
						addi $t3 $t3 -4
						lw $t3 ($t3)
						beq $t3 0 leftTopEmt
							addi $t4 $t4 1
						leftTopEmt:
						
						add $t3 $t6 $t2
						addi $t3 $t3 -4
						lw $t3 ($t3)
						beq $t3 0 leftBotEmt
							addi $t4 $t4 1
						leftBotEmt:
						
						bge $t4 2 skipCheck
						beq $t1 8 skipRight
					checkRight:
						li $t4 0
						
						add $t3 $t5 $t2
						addi $t3 $t3 4
						lw $t3 ($t3)
						beq $t3 0 rightRightEmt
							addi $t4 $t4 1
						rightRightEmt:
						
						add $t3 $t7 $t2
						lw $t3 ($t3)
						beq $t3 0 rightTopEmt
							addi $t4 $t4 1
						rightTopEmt:
						
						add $t3 $t6 $t2
						lw $t3 ($t3)
						beq $t3 0 rightBotEmt
							addi $t4 $t4 1
						rightBotEmt:
						
					bge $t4 2 skipCheck
					skipRight:
						
					move $a0 $t0
					#addi $a0 $a0 1
					addi $sp $sp -4
					sw $ra 0($sp)
					jal iToC
					lw $ra 0($sp)
					addi $sp $sp 4
					move $s0 $v0
					addi $t1 $t1 1
					move $v0 $t1
							
					j updateVert
						
				skipCheck:
				
			addi $t1 $t1 1
			j noBoxesVert2
			exitNoBoxesVert2:
		addi $t0 $t0 1
		j noBoxesVert1
		exitNoBoxesVert1:
		
		li $t0 0
		noBoxesHoriz1: beq $t0 7 exitNoBoxesHoriz1 #look for empty horiz line
			
			addi $sp $sp -4	#store ra in stack
			sw $ra 0($sp)
			
			beq $t0 0 skipTop
				move $a0 $t0
				addi $a0 $a0 -1
				jal selHArr
				move $t8 $v0	#select top row array ($t8)
				jal selCArr
				move $t9 $v0	#select top col array ($t9)
			skipTop:
			move $a0 $t0	#select curr row array (t7)
			jal selHArr
			move $t7 $v0
			addi $a0 $a0 1	#select bottom row array (t6)
			jal selHArr
			move $t6 $v0
			move $a0 $t0	#sel botm col array (t5)
			jal selCArr
			move $t5 $v0
			
			lw $ra 0($sp)	#load ra from stack
			addi $sp $sp 4
			
			li $t1 0
			noBoxesHoriz2: beq $t1 9 exitNoBoxesHoriz2
			
				add $t2 $t1 $t1
				add $t2 $t2 $t2	#t2 holds offset
			
				add $t3 $t7 $t2
				lw $t3 ($t3)
				beq $t3 1 skipCheck2 #if currRow empty
				currColEmpt2:
					
					beq $t0 0 checkBottom
						li $t4 0
						
						add $t3 $t8 $t2
						lw $t3 ($t3)
						beq $t3 0 topTopEmt
							addi $t4 $t4 1
						topTopEmt:
						
						add $t3 $t9 $t2
						lw $t3 ($t3)
						beq $t3 0 topLeftEmt
							addi $t4 $t4 1
						topLeftEmt:
						
						add $t3 $t9 $t2
						addi $t3 $t3 4
						lw $t3 ($t3)
						beq $t3 0 topRightEmt
							addi $t4 $t4 1
						topRightEmt:
						
						beq $t4 2 skipCheck2
						beq $t0 6 skipBottom
					checkBottom:
						li $t4 0
						
						add $t3 $t6 $t2
						addi $t3 $t3 4
						lw $t3 ($t3)
						beq $t3 0 botmBotmEmt
							addi $t4 $t4 1
						botmBotmEmt:
						
						add $t3 $t5 $t2
						lw $t3 ($t3)
						beq $t3 0 botmLeftEmt
							addi $t4 $t4 1
						botmLeftEmt:
						
						add $t3 $t5 $t2
						addi $t3 $t3 4
						lw $t3 ($t3)
						beq $t3 0 botmRightEmt
							addi $t4 $t4 1
						botmRightEmt:
						
					beq $t4 2 skipCheck2
					skipBottom:
						
					move $a0 $t0
					#addi $a0 $a0 1
					addi $sp $sp -4
					sw $ra 0($sp)
					jal iToC
					lw $ra 0($sp)
					addi $sp $sp 4
					move $s0 $v0
					addi $t1 $t1 1
					move $v0 $t1
							
					j updateHoriz
						
				skipCheck2:
				
			addi $t1 $t1 1
			j noBoxesHoriz2
			exitNoBoxesHoriz2:
		addi $t0 $t0 1
		j noBoxesHoriz1
		exitNoBoxesHoriz1:
		
		
		li $t0 0
		hFinishChains1: beq $t0 7 exitHFinishChains1
		
			addi $sp $sp -4
			sw $ra 0($sp)
			move $a0 $t0
			jal selHArr
			move $t2 $v0
			lw $ra 0($sp)
			addi $sp $sp 4
		
			li $t1 0
			hFinishChains2: beq $t1 9 exitHFinishChains2
				add $t3 $t1 $t1
				add $t3 $t3 $t3
				add $t3 $t3 $t2
				lw $t3 ($t3)
				beq $t3 1 skipHAdd
					move $a0 $t0
					#addi $a0 $a0 1
					addi $sp $sp -4
					sw $ra 0($sp)
					jal iToC
					lw $ra 0($sp)
					addi $sp $sp 4
					move $s0 $v0
					addi $t1 $t1 1
					move $v0 $t1
				
					j updateHoriz
				skipHAdd:
				
			addi $t1 $t1 1
			exitHFinishChains2:
		addi $t0 $t0 1
		exitHFinishChains1:
		
		vFinishChains1: beq $t0 6 exitVFinishChains1
		
			addi $sp $sp -4
			sw $ra 0($sp)
			move $a0 $t0
			jal selCArr
			move $t2 $v0
			lw $ra 0($sp)
			addi $sp $sp 4
		
			li $t1 0
			vFinishChains2: beq $t1 9 exitVFinishChains2
				add $t3 $t1 $t1
				add $t3 $t3 $t3
				add $t3 $t3 $t2
				lw $t3 ($t3)
				beq $t3 1 skipVAdd
					move $a0 $t0
					#addi $a0 $a0 1
					addi $sp $sp -4
					sw $ra 0($sp)
					jal iToC
					lw $ra 0($sp)
					addi $sp $sp 4
					move $s0 $v0
					addi $t1 $t1 1
					move $v0 $t1
				
					j updateVert
				skipVAdd:
				
			addi $t1 $t1 1
			exitVFinishChains2:
		addi $t0 $t0 1
		exitVFinishChains1:
		
		j printTest
		
		jr $ra












