;-----------------------------------------------------
; handles int 0x09
;-----------------------------------------------------
keyhandler:
    cli
    pusha
    in al, 0x60                     ; get key data
    mov bl, al                      ; save it
    mov byte [port60], al

    in al, 0x61                     ; keybrd control
    mov ah, al
    or al, 0x80                     ; disable bit 7
    out 0x61, al                    ; send it back
    xchg ah, al                     ; get original
    out 0x61, al                    ; send that back

    mov al, 0x20                    ; End of Interrupt
    out 0x20, al                    ;

    and bl, 0x80                    ; key released
    jnz done                        ; don't repeat

    mov al, [port60]
    ;
    ; do something with the scan-code here
    ;
done:
    popa
    iret
port60    db    0        ; where we'll store the scan-code