; 本程序通过编译，运行正确
Code  Segment
   Assume CS:Code,DS:Code
; －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
; Subroutine 延时指定的时钟嘀嗒数
; 入口：
; Didas=时钟嘀嗒数（1秒钟约嘀嗒18.2次，10秒钟嘀嗒182次。若延时不是秒的10数次倍，误差稍微大点）
Delay   Proc  Near 
   push dx
   push cx
   xor  ax,ax
   int  1ah
   mov  cs:Times,dx
   mov  cs:Times[2],cx
Read_Time: xor  ax,ax
   int  1ah
   sub  dx,cs:Times
   sbb  cx,cs:Times[2]
   cmp  dx,Didas
   jb  Read_Time
   pop  cx
   pop  dx
   ret 
Times  dw  0,0
Delay   EndP 
; －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
Didas  equ  182 ;延时10秒
Start:   call Delay ;这个延时子程序与CPU速度没有关系，通用的
Exit_Proc: mov  ah,4ch ;结束程序
   int  21h
Code  ENDS
   END   Start ;编译到此结束