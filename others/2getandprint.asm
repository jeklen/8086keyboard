; 获取键盘输入并显示在屏幕上
assume cs:code
data segment
	dw 0,0
	port60	db	0	;where we'll store the scan-code
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
start:
	mov ax, stack
	mov ss, ax
	mov sp, 128


	mov ah, 2h
	
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
    mov ax, 10h
  s0:
    sub ax, 1
    cmp ax, 0
    jne s0
    pop ax
    ret
	
  keyhandler:
	cli
	push ax
	push bx
	in al, 60h		;get key data
	mov bl, al		;save  it
	mov [port60], al
	
	in al, 61h		;keyboard control
	mov ah, al
	or al, 80h		;disable bit 7
	out 61h, al		;send it  back
	xchg ah, al		;get original
	out 61h, al		;send that back
	mov dl, [port60]
	
	mov al, 20h		;End of interrupt
	out 20h, al
	
	;and bl, 80h		;key released
	;jnz done		;don't repeat
	
  done:
	pop bx
	pop ax
	ret
	;iret
	
	code ends
	end start