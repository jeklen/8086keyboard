data segment

ends

stack segment
	db 128 dup(0)
ends

code segment
assume cs:code, ds:data, ss:stack

delay proc near
	push dx
	push cx
	xor ax, ax
	int 1ah
	mov cs:Times, dx
	mov cs:Times[2], cx
  read_time:
	xor ax, ax
	int 1ah
	sub dx, cs:Times
	sbb cx, cs:Times[2]
	cmp dx, Diads
	;jb表示小于则跳转，ja表示大于则跳转
	jb read_time
	pop cx
	pop dx
	ret
Times	dw	0, 0
delay endp
;--------------------------------------------------------
Diads	equ		182	;延时10s

start:
	call delay


mov ax, 4c00h
int 21h

ends

end start