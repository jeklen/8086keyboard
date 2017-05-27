data segment
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
	
code ends
end start