; ������ͨ�����룬������ȷ
Code  Segment
   Assume CS:Code,DS:Code
; ����������������������������������������������������������������������������������
; Subroutine ��ʱָ����ʱ�������
; ��ڣ�
; Didas=ʱ���������1����Լ���18.2�Σ�10�������182�Ρ�����ʱ�������10���α��������΢��㣩
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
; ����������������������������������������������������������������������������������
Didas  equ  182 ;��ʱ10��
Start:   call Delay ;�����ʱ�ӳ�����CPU�ٶ�û�й�ϵ��ͨ�õ�
Exit_Proc: mov  ah,4ch ;��������
   int  21h
Code  ENDS
   END   Start ;���뵽�˽���