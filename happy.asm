;每10s响铃一次，同时屏幕上显示消息the bell is ring!
data segment
	count dw 1
	mess  db "The bell is ring!", 0AH, 0DH, '$'
data ends

code segment
	assume cs:code, ds:data

main proc far
start:
	push ds
	sub ax, ax
	push ax
	;设置ds
	mov ax, data
	mov ds, ax
	
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
	pop ds	;important
	
	in al, 21h	;设置中断屏蔽位，21h为8259中断屏蔽寄存器端口地址
	and al, 0FEH
	out 21h, al
	
	sti	;开中断
	mov di, 2000	;延迟
  Delay1: 
	mov si, 3000	;等待中断
  Delay1:
	dec si
	jnz delay1
	dec di
	jnz delay
	
	pop dx	;取原中断向量
	pop ds
	mov al, 1CH
	mov ah, 25H
	int 21h
	ret
main endp
code ends

RING proc near
	push dx
	push ax
	push cx
	push dx
	mov ax, data
	mov ds, ax
	sti	;开中断
	dec count	;十秒计数
	jnz EXIT
	mov dx, offset mess
	mov ah, 09h	;显示消息
	int 21h
	
	mov dx, 100
  tenseconds:
	mov cx, 140h
  towait:
	loop towait
	dec dx
	jne tenseconds
	mov count 182
  EXIT:
	cli
	pop dx
	pop cx
	pop ax
	pop dx
	iret
RING endp
code ends
end start
  