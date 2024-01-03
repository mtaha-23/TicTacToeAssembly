org 0x100
jmp start
board: db '1','2','3','4','5','6','7','8','9'
player1Name:db '               '
player2Name:db '               '
turnMsg: db 'MARK:'
name1:db 'Player 1(X):',0
name2:db 'Player 2(O):',0
playerTurn: db 2
winner: db 0		;game is continue
drawMsg: db 'GAME TIED'
winnerMsg: db 'WINNER>>>'
escMsg: db 'ESC Pressed - GAME EXIT'
msg1:db '1. Play'
msg2:db '2. Instruction'
msg4:db '3. Exit'
msg3:db 'press ESC to continue'
instruction1: db 'Choose 1-9, Mark 3 consecutive symbols, row-wise,'
instruction2: db 'column-wise or diagonal-wise to win'

;--------------> SCREEN CLEARING SUBROUTINE
clrscr:    
    push ax
    push es
    push di

    mov ax, 0xb800	
    mov es, ax
    mov di, 0		
	mov ax, 0x0720	
	mov cx, 2000
	
	rep stosw
	
    pop di
    pop es
    pop ax
    ret

;--------------> PRINT STRING SUBROUTINE
printstr:
	push bp
	mov bp, sp 
	push ax
	push cx
	push es
	push di
	push si
	
	mov ax, 0xb800
	mov es, ax
	mov al, 80
	mul byte[bp+8]
	add ax, [bp+6]
	shl ax, 1
	mov di, ax 		;location
	
	mov cx, [bp+12]	;length
	mov si, [bp+4] 	;offset
	mov ax, [bp+10] ;attribute
	mov al, 0
	cld

next:
	lodsb
	stosw
	loop next
	
	pop si
	pop di
	pop es
	pop cx
	pop ax
	pop bp
	ret 10

;--------------> GETTING NAME INPUT FROM USER SUBROUTINE
askname:
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push es
	push di
	push si
	
	;;;;;;;;;;;;;display name1 or name2 label;;;;;;;;;;;;
	mov bx, 13 			;length (+12)
	push bx
	mov bh, 0x02 		;attribute(+10) 
	push bx
	mov bx, [bp+6] 		;y value (+8)
	push bx
	mov bx, 0 			;x value (+6)
	push bx
	mov bx, [bp+4] 		; string offset (+4)
	push bx
	call printstr
	
	;as row (y-value) was passed and col is 10 because length of name1 or name2 string ,so we now calculate the position to print name on screen while taking input
	mov al, 80
	mul byte[bp+6]
	add al, 13		;the length of string
	shl ax, 1
	mov di, ax
	
	mov ax, 0xb800
	mov es, ax
	mov si, [bp+8]	;store player name in this string
	mov cx, 0
	
charInput:
	mov ah, 0x0
	int 0x16		;get keystroke
		
	cmp al,0Dh		;keep taking input until enter is pressed
	je exit

	mov [si],al		;storing the player name
	inc si
	inc cx			;counts the total number of characters taken input

	cmp cx, 16
	je exit 			;maximum 15 char name can be entered 
	
	mov bl,al
	mov bh,04h
	mov word[es:di], bx	;printing the name on screen while taking input
	add di, 2
	jmp charInput

exit:

	pop si
	pop di
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
	
;--------------> DISPLAY PLAYER NAMES SUBROUTINE
displayPlayerNames:
	push bp
	mov bp, sp
	push bx
	
	mov bx, 13 			;length (+12)
	push bx
	mov bh, 0x02 		;attribute(+10) 
	push bx
	mov bx, 2 			;y value (+8)
	push bx
	mov bx, 0 			;x value (+6)
	push bx
	mov bx, name1 		; string offset (+4)
	push bx
	call printstr
	
	mov bx, [bp+8] 			;length (+12)
	push bx
	mov bh, 0x02 		;attribute(+10) 
	push bx
	mov bx, 2 			;y value (+8)
	push bx
	mov bx, 14 			;x value (+6)
	push bx
	mov bx, [bp+6] ; string offset (+4)
	push bx
	call printstr
	
	mov bx, 13 			;length (+12)
	push bx
	mov bh, 0x04 		;attribute(+10) 
	push bx
	mov bx, 2 			;y value (+8)
	push bx
	mov bx, 40 			;x value (+6)
	push bx
	mov bx, name2 		; string offset (+4)
	push bx
	call printstr
	
	mov bx, [bp+8] 			;length (+12)
	push bx
	mov bh, 0x04 		;attribute(+10) 
	push bx
	mov bx, 2 			;y value (+8)
	push bx
	mov bx, 54 			;x value (+6)
	push bx
	mov bx, [bp+4] ; string offset (+4)
	push bx
	call printstr
	
	pop bx
	pop bp
	ret 6

;--------------> PRINTING BOARD SUBROUTINE
drawBoard:
	push ax
	push es
	push di
	push si
	push cx
	push bx
	
	mov ax, 0xb800
	mov es, ax
	mov di, 1180
	mov si, board

	mov bx, 3
row:	
	mov cx, 3
	boxesRow1:
		mov word [es:di], 0x017C	; prints |
		add di, 2
		mov word [es:di], 0x0720	; print space
		add di, 2
		mov word [es:di], 0x0720	; print space
		add di, 2
		mov word [es:di], 0x0720	; print space
		add di, 2
		mov word [es:di], 0x017C	; print |
		loop boxesRow1
		
		add di, 136
		mov cx, 3
	boxesRow2:
		mov word [es:di], 0x017C	; prints |
		add di, 2
		mov word [es:di], 0x0720	; print space
		add di, 2
		
		mov ax, [si]
		
		cmp al, 'X'
		je XColor
		cmp al, 'O'
		je OColor
		jne digitColor

digitColor:							;blue color for digit		
		mov ah, 0x1
		jmp printIndex
XColor:								;green color for X
		mov ah, 0x2
		jmp printIndex
OColor:								;red color for O
		mov ah, 0x4	
		
printIndex:		
		mov [es:di], ax				; print array index
		inc si
		add di, 2
		
		mov word [es:di], 0x0720	; print space
		add di, 2
		mov word [es:di], 0x017C	; print |
		loop boxesRow2
	
		add di, 136
		mov cx, 3
	boxesRow3:
		mov word [es:di], 0x017C	; prints |
		add di, 2
		mov word [es:di], 0x015F	; print __
		add di, 2
		mov word [es:di], 0x015F	; print __
		add di, 2
		mov word [es:di], 0x015F	; print __
		add di, 2
		mov word [es:di], 0x017C	; print |
		loop boxesRow3
		
		add di, 136
		
	dec bx
	cmp bx, 0
	jne row

	
	pop bx
	pop cx
	pop si
	pop di
	pop es
	pop ax	
	
	ret

;--------------> PRINTING PLAYER'S TURN MESSAGE SUBROUTINE	
printTurnMsg:
	push ax
	push es
	push bx
	
	;;prints MOVE: message
	mov bx, 5			;length (+12)
	push bx
	mov bh, 0x07 		;attribute(+10) 
	push bx
	mov bx, 17 			;y value (+8)
	push bx
	mov bx, 0 			;x value (+6)
	push bx
	mov bx, turnMsg ; string offset (+4)
	push bx
	call printstr
	
	;;prints player name for whoses turn is this
	
	mov bx, 15			;length (+12)
	push bx
	mov bh, 0x07 		;attribute(+10) 
	push bx
	mov bx, 17 			;y value (+8)
	push bx
	mov bx, 6 			;x value (+6)
	push bx
	
	cmp byte [playerTurn], 1
	je player1Turn 
	
	mov bx, player2Name
	jmp printIt
	
player1Turn:	
	mov bx, player1Name ; string offset (+4)
	
printIt:	
	push bx
	call printstr
	
	pop bx
	pop es
	pop ax
	ret

;--------------> CHECKING WIN CONDITION SUBROUTINE	
checkWin:
	push bx
	push si
	
	mov si, board

row1:
	mov bl, [si+0]
	cmp [si+1], bl
	jne row2
	cmp bl, [si+2] 
	je won
	
row2:
	mov bl, [si+3]
	cmp [si+4], bl
	jne row3
	cmp bl, [si+5] 
	je won

row3:
	mov bl, [si+6]
	cmp [si+7], bl
	jne col1
	cmp bl, [si+8] 
	je won
	
col1:
	mov bl, [si+0]
	cmp [si+3], bl
	jne col2
	cmp bl, [si+6] 
	je won	
	
col2:
	mov bl, [si+1]
	cmp [si+4], bl
	jne col3
	cmp bl, [si+7] 
	je won	

col3:
	mov bl, [si+2]
	cmp [si+5], bl
	jne diag1
	cmp bl, [si+8] 
	je won		

	;diagonal
diag1:
	mov bl, [si+2]
	cmp [si+4], bl
	jne diag2
	cmp bl, [si+6] 
	je won	
	
	;main diagonal
diag2:
	mov bl, [si+0]
	cmp [si+4], bl
	jne notFin
	cmp bl, [si+8] 
	je won	

notFin:	
	mov byte [winner], 0			;game is still not finished
	jmp exit1
	
won:
	cmp bl, 'O'
	je player2won

player1won:
	mov byte [winner], 1			;game won by player 	
	jmp exit1
player2won:
	mov byte [winner], 2			;game won by player 2
	
exit1:		
	
	pop si
	pop bx 
	ret

;--------------> CHECKING IF THE WHOLE TABLE HAS BEEN FILLED SUBROUTINE
checkDraw:
	push si
	push cx
	push di
	
	mov cx, 9
	mov si, 0
	
	;traversing the whole array and checking if there is any index present with number, that is not yet marked
traverse:
	cmp byte [board+si], 'X'
	je checkNextIndex
	cmp byte [board+si], 'O'
	je checkNextIndex
	jne exit3				;empty index found than exit
	
checkNextIndex:
	inc si
	loop traverse
	
	mov byte [winner], 3	;game is tied

exit3:	
	pop di
	pop cx
	pop si
	ret

;--------------> RESULT PRINTING SUBROUTINE
printResult:
	push ax
	push bx
	
	cmp byte [winner], 1	;Player 1 Wins
	je printP1Wins
	cmp byte [winner], 2	;Player 2 Wins
	je printP2Wins
	cmp byte [winner], 3	;Game Tied
	je gameTied
	cmp byte [winner], 4	;ESC was Pressed
	je escPressed
	
printP1Wins:
	mov ax, player1Name
	jmp out2
	
printP2Wins:
	mov ax, player2Name
	
	;;prints the name of winner
out2:
	mov bx, 9 			;length (+12)
	push bx
	mov bh, 0x07 		;attribute(+10) 
	push bx
	mov bx, 20		;y value (+8)
	push bx
	mov bx, 30 			;x value (+6)
	push bx
	mov bx, winnerMsg	; winnerMsg string (+4)
	push bx				
	call printstr
	
	mov bx, 15 			;length (+12)
	push bx
	mov bh, 0x07 		;attribute(+10) 
	push bx
	mov bx, 20 		;y value (+8)
	push bx
	mov bx, 39 			;x value (+6)
	push bx
	
	push ax				; playerName string that was stored in ax(+4)
	call printstr
	
	jmp exit5

	;;prints Game Tied
gameTied:
	
	mov bx, 9 			;length (+12)
	push bx
	mov bh, 0x03 		;attribute(+10) 
	push bx
	mov bx, 20 			;y value (+8)
	push bx
	mov bx, 20 			;x value (+6)
	push bx
	mov bx, drawMsg		; game TIED/DRAW string (+4)
	push bx					
	call printstr
	
	jmp exit5
	
	;;prints Game Exit
escPressed:
	
	mov bx, 23 			;length (+12)
	push bx
	mov bh, 0x03 		;attribute(+10)
	push bx
	mov bx, 20 			;y value (+8)
	push bx
	mov bx, 20 			;x value (+6)
	push bx
	mov bx, escMsg	; game exit string (+4)
	push bx					
	call printstr
	
exit5:	
	pop bx
	pop ax
	ret

;--------------> MENU
menu:
	push bx
	push ax

mainpage:
	call clrscr
	mov bx, 7 			;length (+12)
	push bx
	mov bh, 0x02 		;attribute(+10) 
	push bx
	mov bx, 10 		;y value (+8)
	push bx
	mov bx, 30 			;x value (+6)
	push bx
	mov bx, msg1 		; string offset (+4)
	push bx
	call printstr
	
	mov bx, 14 			;length (+12)
	push bx
	mov bh, 0x02 		;attribute(+10) 
	push bx
	mov bx, 11 		;y value (+8)
	push bx
	mov bx, 30 			;x value (+6)
	push bx
	mov bx, msg2 		; string offset (+4)
	push bx
	call printstr
	
	mov bx, 7 			;length (+12)
	push bx
	mov bh, 0x02 		;attribute(+10) 
	push bx
	mov bx, 12 		;y value (+8)
	push bx
	mov bx, 30 			;x value (+6)
	push bx
	mov bx, msg4 		; string offset (+4)
	push bx
	call printstr
	mov ah, 0
	int 0x16
	
	sub al, 0x30
	
	cmp al, 1
	je play
	cmp al, 2
	je printInstruction
	cmp al, 3
	je exit6
	jne mainpage

exit6:
	mov ax, 0x4c00
	int 0x21	

printInstruction:
	call clrscr
	
	;prints instruction 1
	mov bx, 49 			;length (+12)
	push bx
	mov bh, 0x02 		;attribute(+10) 
	push bx
	mov bx, 10 		;y value (+8)
	push bx
	mov bx, 15 			;x value (+6)
	push bx
	mov bx, instruction1 		; string offset (+4)
	push bx
	call printstr
	
	;prints instruction 2
	mov bx, 35 			;length (+12)
	push bx
	mov bh, 0x02 		;attribute(+10) 
	push bx
	mov bx, 11 		;y value (+8)
	push bx
	mov bx, 15 			;x value (+6)
	push bx
	mov bx, instruction2 		; string offset (+4)
	push bx
	call printstr

	mov bx, 21 			;length (+12)
	push bx
	mov bh, 0x02 		;attribute(+10) 
	push bx
	mov bx, 12 		;y value (+8)
	push bx
	mov bx, 20 			;x value (+6)
	push bx
	mov bx, msg3 		; string offset (+4)
	push bx
	call printstr	
	
	mov ah, 0
	int 0x16
	
	cmp al, 0x1B		;if esc is pressed	
	je mainpage
	jne printInstruction
	
play:
	pop ax
	pop bx
	ret

;--------------> START
start:
	call menu
	call clrscr
	
	mov bx, player1Name	;label to store name1 (+8)
	push bx
	mov bx, 1		;y value (+6)
	push bx
	mov bx, name1 ;(+4)
	push bx
	call askname
	
	mov bx, player2Name	;label to store name2 (+8)
	push bx
	mov bx, 2		;y value (+6)
	push bx
	mov bx, name2 ;(+4)
	push bx
	call askname
	
	call clrscr
	
	mov bx, 15		;max length of a name
	push bx
	mov bx, player1Name 	
	push bx
	mov bx, player2Name
	push bx
	call displayPlayerNames
	
continueGame:	
	call drawBoard
	
	call printTurnMsg 

again:	
	;input from user
	mov ah,0
	int 0x16
	
	cmp al, 0x1B
	je escQuit
	
	;calculating the box number
	mov ah, 0
	mov si, ax
	sub si, 0x31		
	
	;if number is not between 0-8  (8 because we have now subtracted 31 ascii from si)
	cmp si, 0
	jl again
	cmp si, 8
	jg again
	
	;checking if the box is already Marked
	cmp byte [board+si], 'X'
	je again 
	cmp byte [board+si], 'O'
	je again
	
	cmp byte [playerTurn], 1
	je markX

	;marking 
markO:
	mov byte [board+si], 'O'
	jmp checkCondition
markX:	
	mov byte [board+si], 'X'

checkCondition:
	call drawBoard
	
	call checkWin
	;check if the game was finished
	cmp byte [winner], 0
	jne gameFinished
	
	call checkDraw
	
	;changing player turn
	cmp byte [playerTurn], 1	
	je changeTurn 
	
	mov byte [playerTurn], 1		;change player turn to 1, now Player1's turn
	jmp out1
changeTurn:
	mov byte [playerTurn], 2		;change player turn to 2, now Player2's turn

out1:	
	cmp byte [winner], 0			;checks if the game is still not finished
	je continueGame
	
	jmp gameFinished

escQuit:
	mov byte [winner] , 4	
	
gameFinished:
	call printResult
		
	mov ax, 0x4c00
	int 0x21