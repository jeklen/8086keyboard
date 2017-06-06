;每10s响铃一次，同时屏幕上显示消息the bell is ring!
data segment
	;count dw 182
	count dw 364
	mess  db "The bell is ring!", 0AH, 0DH, '$'
data ends

stackseg segment stack
	db 400 dup(0)
	TOP equ 400
stackseg ends

code segment
	assume cs:code, ds:data, ss:stackseg
	
RING proc near
	push dx
	push ax
	push cx
	push dx
	mov ax, data
	mov ds, ax
	sti	;开中断
	dec count	;十秒计数
	jz block
	cmp count, 182
	jz unblock
	jmp EXIT

  unblock:
    mov al, 00H
	out 21H, al
	jmp EXIT

  block:
	mov al, 02H
	out 21H, al
  setcount:
	mov count, 364
	
  EXIT:
	cli
	pop dx
	pop cx
	pop ax
	pop dx
	sti
	iret
RING endp

start:
	push ds
	sub ax, ax
	push ax
	;设置ds
	mov ax, data
	mov ds, ax
	;set ss
	mov ax, stackseg
	mov ss, ax
	mov sp, TOP
	
	mov al, 13h
	out 20h, al
	mov al, 8h
	out 21h, al
	mov al, 01h
	out 21h, al
	mov al, 02H
	out 21h, al
	
	cli
	mov al, 1CH
	mov ah, 35H
	;ah=35时取中断向量，al=中断类型，es:bx=中断向量
	int 21h		;得到原中断向量
	push es		;存储原中断向量
	push bx		
	push ds
	
	mov dx, offset RING	;中断子程序ring的偏移地址和段地址
	mov ax, seg RING
	mov ds, ax
	mov al, 1CH	;设置中断向量
	mov ah, 25h
	;ah=25h时设置中断向量 ds:dx = 中断向量，al=中断向量号
	int 21h
	sti
	pop ds	;important

  Initialize:
	mov dx, offset Initialize
	int 27H

code ends
end start

  