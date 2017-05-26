; 这个程序可以从a到z依次显示字符
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
	;call delay
	inc dl
	cmp dl, 'z'
	jna s
	
	mov ax, 4c00h
	int 21h
	         
  delay:
    push ax
    mov ax, 10h
  s0:
    sub ax, 1
    cmp ax, 0
    jne s0
    pop ax
    ret
	
	code ends
	end start