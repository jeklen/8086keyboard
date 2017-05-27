data segment

data ends

stackseg segment stack
	db 128 dup(0)
stackseg ends

code segment
assume cs:code, ds:data, ss:stackseg

delay proc near
	push dx
	push cx
	xor ax, ax
	int 1ah
	mov cs:Times, dx
	mov cs:Times[2], cx
  read_time:
  	mov ah, 01h	;check if a key is pressed
	int 16h
	jz notpressed	;zero = no pressed
  	mov ah, 0
	int 16h
	mov dl, al
	cmp dl, 'z'
	jnz judgeZ
	mov dl, 'a'
	sub dl, 1h
	cmp dl, 'Z'
  judgeZ:
	cmp dl, 'Z'
	jnz getsecret
	mov dl, 'A'
	sub dl, 1h	
  getsecret:
	add dl, 1h
	mov ah, 2h
	int 21h
  notpressed:
	xor ax, ax
	int 1ah
	sub dx, cs:Times
	sbb cx, cs:Times[2]
	cmp dx, Diads
	;jb表示小于则跳转，ja表示大于则跳转
	jb read_time
	pop cx
	pop dx
	ret
Times	dw	0, 0
delay endp
;--------------------------------------------------------
Diads	equ		182	;延时10s

start:
	mov al, 13h
	out 20h, al
	mov al, 8h
	out 21h, al
	mov al, 01h
	out 21h, al

	call delay

	mov al, 02H ;写OCW1，屏蔽IR5、IR6、IR7中断源
	out 21h, al	 ;假定这三个中断输入未用,其他开中断

	call delay
	
	mov al, 00H ;写OCW1，屏蔽IR5、IR6、IR7中断源
	out 21h, al	 ;假定这三个中断输入未用,其他开中断
	
	call delay


mov ax, 4c00h
int 21h

code ends

end start