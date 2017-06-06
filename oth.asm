cseg segment
	assume cs:cseg, ds:cseg
	org 100h
start:
	jmp initialize
	
new_keyboard_io	proc far   ;这一部分是驻留在内存中的内容
	sti
	nop
	iret
new_keyboard_io endp

initialize:
	mov dx, offset new_keyboard_io	;新的键盘处理程序
	mov al, 16h	;需更改的向量号(interrupt index)
	mov ah, 25h	;更改系统中断向量表
	int 21h
	
	mov dx, offset initialize
	int 27h	;讲标签initialize前的程序驻留内存
	
cseg ends
end start