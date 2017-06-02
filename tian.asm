assume cs:code,ds:data,ss:stack
data segment

data ends

stack segment stack
    db   128  dup(0)
stack ends

code segment
start:
    mov  ax,data
    mov  ds,ax
    mov  ax,stack
    mov  ss,ax
    mov  sp,128
    mov  ax,0
    mov  es,ax
    push es:[36]
    pop  es:[200h]
    push es:[38]
    pop  es:[202h]
    mov  ax,363
    mov  es:[300h],ax
    
    cli
    mov ax,offset fun2
    mov word ptr es:[36],ax
    mov ax,seg fun2   
    mov word ptr es:[38],ax
    mov ax,offset fun1
    mov word ptr es:[112],ax
    mov ax,seg fun1 
    mov word ptr es:[114],ax
    sti
    
    mov dx,offset leave
    int 27h 

fun1:
    sti
    push ax
    push es
    mov  ax,0
    mov  es,ax 
    mov  ax,es:[300h]
    cmp  ax,182
    je   return
    cmp  ax,0
    je   f1
    jmp  return
f1: mov  ax,363
    mov  es:[300h],ax
return:
    mov ax,es:[300h] 
    dec ax
    mov es:[300h],ax
    cli             
    mov al,20h
    out 20,al
    pop es
    pop ax
    iret
    
fun2:
    sti
    push ax
    push bx
    push es
    pushf
    pushf
    pop  bx
    and  bx,11111100b
    push bx      
    popf
    mov ax,0
    mov es,ax
    call dword ptr es:[200h] 
    mov ax,0040h
    mov es,ax
    mov bx,001ah
    mov ax,es:[bx]
    mov bx,ax 
    mov ax,es:[bx]
    cmp al,'z'
    jg  return1
    cmp al,'A'
    jl  return1   
    cmp al,'z'
    je f21
    cmp al,'Z'
    je f22
    inc al
    jmp return1
f21:mov al,'a'
    jmp return1
f22:mov al,'A' 

return1: 
    mov es:[bx],ax
    mov ax,0
    mov es,ax
    mov ax,es:[300h]
    mov ax,180
    jnc return2
    mov ax,0040h
    mov es,ax
    mov bx,001ah
    mov ax,es:[bx]
    mov bx,001ch
    mov es:[bx],ax
    
return2:
    cli
    mov al,20h
    out 20,al
    pop es
    pop bx
    pop ax
    iret
    
leave:
    code ends
end start    
    
    
    
    
    
    
    
    
    

