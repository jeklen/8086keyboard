; keyboard interrupt to show a to z
; IN OUT是对威慑的读写操作指令
; 每一个外设有一个地址
; in al, 20H 表示从20H地址所对应的外设读一个字节到AL
; out 20H, al表示将al持有的数据写入21H地址所对应的外设
data segment
	dw 0, 0
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
	assume cs:code
	
start:
	mov ax, stack
	mov ss, ax
	mov sp, 128		;set ss:sp
	
	mov ax, data
	mov ds, ax		;ds
	
	mov ax, 0
	mov es, ax		;es(extra segment)
	
	;将键盘原来的中断例程地址复制到ds:[0]中
	push es:[9*4]
	pop ds:[0]
	push es:[9*4+2]
	pop ds:[2]
	
	;将新的int9地址写入中断向量表
	mov word ptr es:[9*4], offset int9
	mov es:[9*4+2],cs	;int9
	
	;屏幕依次输出a---z
	mov ax, 0b800h
	mov  es, ax
	mov ah, 'a'
  s:
	mov es:[160*12+40*2], ah
	call delay
	inc ah
	cmp ah, 'z'
	jna s 
	
	mov ax, 0
	mov es, ax
	
	;恢复中断向量表
	push ds:[0]
	pop es:[9*4]
	push ds:[2]
	pop es:[9*4+2]
	
	;exit
	mov ax, 4c00h
	int 21h
	
  ;延时
  delay:
	push ax
	push dx
	mov dx, 1000h
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
  ;-----------------------------
  ;int 9
  int9:
	push ax
	push bx
	push es
	
	in al, 60