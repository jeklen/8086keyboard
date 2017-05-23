assume cs:code
data segment
	Message db 'Hello World.$'
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
start:
	mov ah, 9
	mov dx, seg Message
	mov ds, dx
	mov dx, offset message
	int 21H
	call delay

	
	mov ax, 4c00h
	int 21h
	
  delay:
	push ax
	push dx
	mov dx, 1000h	;循环100 0000次
	mov ax, 0
  s1:
	sub ax, 1
	sbb dx, 0
	cmp ax, 0
	jne s1
	cmp dx, 0
	jne s1
	pop dx
	pop ax
	ret
	
	code ends
	end start