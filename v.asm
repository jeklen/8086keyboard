;任务：在屏幕中间依次显示‘a'~’z' 并可以让人看清。在显示的过程中 按下Esc后，改变显示的颜色  
  
assume cs:code  
  
;栈  
stack segment  
    db 128 dup (0)  
stack ends  
  
;store data  
data segment  
    dw 0,0  
data ends  
  
;  
code segment  
start:    
    mov ax,stack  
    mov ss,ax  
    mov sp,128      ;ss:sp  
  
    mov ax,data  
    mov ds,ax       ;ds  
      
    mov ax,0  
    mov es,ax       ;es  
  
  
    ;将键盘原来的中断例程地址复制到ds:[0]中  
    push es:[9*4]  
    pop ds:[0]  
    push es:[9*4+2]  
    pop ds:[2]      ;  
  
    ;将新的int9地址写入中断向量表  
    mov word ptr es:[9*4],offset int9  
    mov es:[9*4+2],cs   ;int9  
  
  
    ;屏幕依次输出a---z  
    mov ax,0b800h  
    mov es,ax  
    mov ah,'a'  
s:  mov es:[160*12+40*2],ah  
    call delay  ;delay用来延时  也就是空循环  
    inc ah  
    cmp ah,'z'  
    jna s  
      
    mov ax,0  
    mov es,ax  
  
    ;恢复中断向量表  
    push ds:[0]  
    pop es:[9*4]  
    push ds:[2]  
    pop es:[9*4+2]  
  
    ;exit  
    mov ax,4c00h  
    int 21h  
  
;延时  
delay:  push ax     ;因为用到dx，ax 先将他们保存到栈中  
    push dx  
    mov dx,1000h  
    mov ax,0  
s1: sub ax,1  
    sbb dx,0  
    cmp ax,0  
    jne s1  
    cmp dx,0  
    jne s1  
    pop dx  
    pop ax  
    ret ;call---ret 是一对  
;------------------------------  
;int9  
  
int9:           ;我们新编写的中断例程  
    push ax  
    push bx  
    push es     ;保存环境  
  
    in al,60    ;从键盘读取一个字符  
    pushf  
    pushf  
    pop bx  
    and bh,11111100b  
    push bx  
    popf  
    call dword ptr ds:[0];调用原来的int9  
  
    cmp al,1    ;1表示Esc  
    jne int9ret  
  
    mov ax,0b800h  
    mov es,ax  
    inc byte ptr es:[160*12+40*2+1]     ;变色  
  
int9ret:        ;恢复环境颜色  
    pop es  
    pop bx  
    pop ax  
    iret  
  
  
  
  
code ends  
end start  