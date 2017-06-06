stackseg segment stack
	db 400 dup(0)
	TOP equ 400
stackseg ends

code segment
	assume cs:code, ds:code, ss:stackseg
	count dw 364
	Old_Keyboard_IO dd ?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     new_keyboard_io proc far         ;ÐÂÖÐ¶Ï
        assume cs:code,ds:code 
              
      STI          
           ;Section 1
      cmp ah,0                        ;ÓÐ°´¼üÅÌ
      je ki0
      assume ds:nothing
      jmp  Old_Keyboard_IO 
      
      
           ;Section 2
     ki0:
      pushf
      assume  ds:nothing
      call  Old_Keyboard_IO
      cmp  al,'a'
      jb  kidone 
      cmp  al,'z' 
      jb  ki1
      cmp  al,'z'
      je  ki2
      nop
      jmp kidone
     ki1:
      add al,1
      jmp kidone
      nop
     ki2:
      mov al,'a'
     kidone:     
      iret   
      
      
     new_keyboard_io endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RING proc near
	push dx
	push ax
	push cx
	push dx
	mov ax, code
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
	mov ax, code
	mov ds, ax
	;set ss
	mov ax, stackseg
	mov ss, ax
	mov sp, TOP
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	      mov al,16h
      mov ah,35h
      int 21h
      mov word ptr Old_Keyboard_IO,bx
      mov word ptr Old_Keyboard_IO[2],es      ;È¡ÖÐ¶ÏÏòÁ¿
           ;End Section 3 
           
           
      mov dx,offset new_keyboard_io
      mov al,16h
      mov ah,25h                              ;·ÅÐÂÖÐ¶ÏÏòÁ¿
      int 21h  
	  ;;;;;;;;;;;;;;;;;;;;;;
	
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

  