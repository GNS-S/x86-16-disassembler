.model small
buferioDydis	EQU	121

BSeg SEGMENT

	ORG	100h
	ASSUME ds:BSeg, cs:BSeg, ss:BSeg

Pradzia:; 5 + 1 + 7 + 2 + 4 + 1 + 8 + 1 + 2 + 1 + 2 + 2 + 2 + 1 + 1 
	xd db 12h
	mov ax, bx
	inc [si+2]
	dec word ptr cs:[bp+si+1]
	inc byte ptr cs:[bp+si+501]
	jmp farjump
	mov jmpisorinistiesioginis, 00F1h
	mul byte ptr [si+0ff80h]
	mov ax, [bp+si+1234]
	mov si, 1234h
	inc byte ptr [si]
	inc word ptr [si]
	dec byte ptr[xd]
	dec word ptr[xd]
	div bh
	JNS	pradzia
	JO pradzia
	JNO pradzia
	JNAE pradzia
	JAE pradzia
	JE pradzia
	JNE pradzia
	JBE pradzia
	JAE pradzia
	JS pradzia
	JNS pradzia
	JP pradzia
	JNP pradzia
	JL pradzia
	JGE pradzia
	JLE pradzia
	JG pradzia
	LOOP pradzia
	INT 25h
	callisorinistiesioginis db 09Ah, 0AFh, 0CDh, 015h, 0D6h ; neisvaizduoju kaip kitaip ji iskviest tai tiesiog masinini koda insertinu cia
	call bx
	call ds:[bp+si+0c5F9h]
	call testing
	jmpisorinistiesioginis db 0EAh, 0AFh, 0CDh, 015h, 0D6h ; neisvaizduoju kaip kitaip ji iskviest tai tiesiog masinini koda insertinu cia 
	jmp bx
	jmp ds:[bp+si+0c5F9h]
	jmp Pradzia
	jmp farjump 
	INT 15h
	ret
	ret 2h
	xor ax, 1b
	mul byte ptr [si+80h]
	mul dl
	mul BX
	mul byte ptr [si+0ff80h]
	div bh
	div DI
	div word ptr ss:[bx+10h]
	
	cmp byte ptr ds:[bp+si+0c5F9h], 91h
	cmp ax, 9101h
	cmp al, 2h
	cmp ah, 3h
	cmp cx, ax
	cmp ax, cx
	cmp si, cs:[bp+di+0ABF9h]
	dec ch
	dec DX
	dec byte ptr es:[di+015F9h]
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub ax, 101h
	sub al, 2h
	sub ah, 3h
	
	add word ptr ds:[bp+si+0c5F9h], 01ff1h
	add ax, 101h
	add al, 2h
	add ah, 3h
	inc ch
	inc word ptr es:[bx+si+015F9h]
	mov ax, cx
	mov cx, ax
	add cx, ax
	add ax, cx
	add si, cs:[bp+di+0ABF9h]
	
	
	push cs
	push dx
	push cs:[bp+di+0ABF9h] 
	
	
	pop ss
	pop si
	pop ss:[bx+di+0BA21h] 
	
	
	MOV	cx, 0ABCDh
	mov ax, ds
	
	mov si, 0
	mov ax, [si]
	mov [si +2h], ax
	mov  byte ptr cs:[si+1252h], 0F1h
	mov [bx], si
	

ret
ret
ret
ret
ret
ret
cmp  byte ptr ss:[si+1ff2h], 00F1h
add  byte ptr ss:[si+1ff2h], 00F1h
mov   ss:[si+1ff2h], 061h
mov jmpisorinistiesioginis, 00F1h
mov ds:[013ch], 00F1h
add jmpisorinistiesioginis, 00F1h
cmp jmpisorinistiesioginis, 00F1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
	sub word ptr ds:[bp+si+0c5F9h], 01ff1h
farjump:
testing proc
ret
testing endp
	;mov ax, 4C04h
	
    ;int 21h

BSeg ENDS
END	Pradzia
