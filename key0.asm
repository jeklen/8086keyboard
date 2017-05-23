data segment

data ends

stack segment stack
    DB  100 DUP(0)  
    TOP EQU 700
stack ends

code segment   
    assume cs:code, ds:data, ss:stack
start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    mov sp, TOP
    ; add your code here
	;-----------------------------------------------------
; handles int 09
;-----------------------------------------------------
keyhandler:
    cli
    push ax
	push bx
    in al, 60h                     ; get key data
    mov bl, al                      ; save it
    ;mov byte [port60], al
	mov [port60], al

    in al, 61h                     ; keybrd control
    mov ah, al
    or al, 80h                     ; disable bit 7
    out 61h, al                    ; send it back
    xchg ah, al                     ; get original
    out 61h, al                    ; send that back

    mov al, 20h                    ; End of Interrupt
    out 20h, al                    ;

    and bl, 80h                    ; key released
    jnz done                        ; don't repeat

    mov al, [port60]
    ;
    ; do something with the scan-code here
done:
    pop ax
	pop bx
    iret
port60    db    0        ; where we'll store the scan-code

mov ax, 4c00h
int 21h  

code ends

end start