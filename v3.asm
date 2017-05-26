;通过9号中断，不断获得键盘输入并显示在屏幕上
;进入循环：
;1. 10s不接受任何东西
;2. 10s密码键盘(也就是一个键盘中断，也就是进入9号中断）		
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
	
Delay Proc Near
	push dx
	push cx
	xor ax, ax
	int 1ah
	mov cs:Times, dx
	mov cs:Times[2], cx
Read_Time: xor	ax, ax
	int 1ah
	sub dx, cs:Times
	sbb cx, cs:Times[2]
	cmp dx, Diadas
	jb 	Read_Time
	pop cx
	pop dx
	ret
Times dw	0,0
Diadas equ 182
Delay EndP
;--------------------------------------------------------
start:
	mov ax, data
	mov ds, ax
	mov ax, stack
	mov ss, ax
	mov sp, TOP
	
	;修改中断入口地址
	cli
	mov ax, 0
	mov es, ax				;ES = 0
	mov bx, 9*4				;BX为中断向量表项地址
	mov ax, offset keyhandler
	mov es:[bx], ax			;中断程序入口段偏移
							;0000:0024H
	mov ax, seg keyhandler		
	mov es:[bx+2], ax		;中断程序入口段地址
	sti
	
	;loop for 6 times
  Secretkey:
	call Delay
	call Delay
	jnz Secretkey
Exit_Proc:	mov ah,4ch	;结束程序
	int 21h

  keyhandler:
    push ax
    push bx

    in AL, 60h
    MOV DL, AL
    MOV AH, 02H
    INT 21H
	
	cli
	mov al, 20h			;End of Interrupt
	out 20h, al
	
	pop bx
	pop ax
	iret
	
code ends
end start