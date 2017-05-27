; 初始化8259 假设8259占用的I/O
; 地址为FF00和FF02H(奇地址)
;4条ICW命令依次写入
;ICW1必须写入偶地址端口（A0=0）
;ICW2必须写入奇地址端口（A0=1）
;ICW3只有在ICW1中的SNGL=0即级联时写入
;ICW4只有在ICW1中IC4=1时才写入
;三条OCW命令次序上没有要求
;但OCW1写入偶地址端口，2、3写入奇地址端口
;D4、D3位为00时为OCW2，为01时为OCW3
mov dx, 0FF00H	;8259地址A0=0
mov al, 13H	;ICW1 边沿触发，单片
out dx, al

mov dx, 0FF02H	;8259地址A0=1
mov al, 48H		;写ICW2，设置中断类型码
out dx, al	;设置中断向量为48H-4FH(IR0-IR7)单片8259，不对ICW3设置

mov al, 03H	;写ICW4,8086/88模式，自动中断结束(EOI),非缓冲，一般嵌套
out dx, al

mov al, 0E0H ;写OCW1，屏蔽IR5、IR6、IR7中断源
out dx, al	 ;假定这三个中断输入未用,其他开中断
