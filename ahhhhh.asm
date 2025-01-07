ORG 0000H
	LJMP INIT;初始化程序
ORG 0003H
	LJMP INT0P;外部中断0
	
ORG 0040H
INIT:
	MOV A,#00H
	MOV R4,#00H
	MOV P2,A	;初始化工作
	
	SETB EA		;开启总中断
	CLR IT0		;低电平触发
	SETB EX0	;允许外部中断0
MAIN:	
	
	LCALL DELAY10MS
	INC R4			;每10ms加一
	CJNE R4,#10,MAIN;
	MOV R4,#00H		;到了100ms则对R4清0
	MOV P2,A		;把A赋值给P2口
	CPL A			;对A取反，达到闪烁效果
	SJMP MAIN		;循环执行主函数
	
INT0P:			;外部中断0函数
	CLR EA		
	PUSH Acc	;压栈，保护A的值
	SETB EA
	
	MOV A,#0FEH	;初始化流水灯
	MOV R4,#00H
ILOOP:
	MOV C,P3.2
	JC RETU
	
	LCALL DELAY10MS
	INC R4
	CJNE R4,#6,ILOOP;
	MOV R4,#00H	;到了60ms则对R4清0
	MOV P2,A	;把A赋值给P2口
	RL A		;循环左移A，达到流水灯效果
	SJMP ILOOP	;在中断函数内循环，不建议！！！
RETU:	
	CLR EA
	POP Acc		;恢复A的值
	SETB EA
	RETI		;退出中断
	
DELAY10MS:			;@12.000MHz10ms延时函数
	MOV		30H,#49
	MOV		31H,#200
LOOP:
	DJNZ	31H,LOOP
	DJNZ	30H,LOOP
	RET
END



















	
