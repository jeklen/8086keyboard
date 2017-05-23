assume cs:code

stack segment
	db 128 dup(0)
stack ends

code segment
start:
	mov ax, stack
	mov ss, ax
	mov sp, 128
	
	mov ah, 2h
	mov dl, 'a'
  s:
    int 21H
	call delay
	inc dl
	cmp dl, 'z'
	jna s
	
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