data segment
	dw 0, 0
	C	DW	0h
	;port60	db	0
data ends

stack segment
	DB	100 DUP(0)
	TOP	EQU	100
stack ends

code segment
	assume cs:code, ds:data, ss:stack

;--------------------------------------------------------
start:
	mov ax, data
	mov ds, ax
	mov ax, stack
	mov ss, ax
	mov sp, TOP
	
	mov ax, 0
	mov es, ax
	push es:[9*4]
	pop ds:[0]
	push es:[9*4+2]
	pop ds:[2]
	
	mov word ptr es:[9*4], offset int9
	mov es:[9*4+2], cs
	
	;loop for 6 times
	mov cx, 1FFFh
  Secretkey:
	mov ah, 0
	int 16h
	mov dl, al
	mov ah, 2h
	int 21h
	nop
	jnz Secretkey
Exit_Proc:	mov ah,4ch	;结束程序
	int 21h

  int9:
	push ax
	push bx
	push es
	
	pushf
	pushf
	pop bx
	and bh, 11111100b
	push bx
	popf
	call dword ptr ds:[0]
	
	pop es
	pop bx
	pop ax
	iret
code ends
end start