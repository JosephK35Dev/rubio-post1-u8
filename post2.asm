; post2.asm - suma y resta de 32 bits con ADC/SBB
bits 16
org 100h
section .data
aLo dw 0FFFFh
aHi dw 0001h
bLo dw 0001h
bHi dw 0001h
resLo dw 0
resHi dw 0
msgS db 'Suma 32 bits ADC: DX:AX=0003:0000 OK',13,10,'$'
msgE db 'Error en suma ADC',13,10,'$'
msgR db 'Resta 32 bits SBB: DX:AX=0001:FFFF OK',13,10,'$'
msgER db 'Error en resta SBB',13,10,'$'
section .text
start:
 mov ax,[aLo]
 mov dx,[aHi]
 mov bx,[bLo]
 mov cx,[bHi]
 add ax,bx
 adc dx,cx
 mov [resLo],ax
 mov [resHi],dx
 cmp ax,0000h
 jne .error_suma
 cmp dx,0003h
 jne .error_suma
 mov dx,msgS
 mov ah,09h
 int 21h
 jmp .resta
.error_suma:
 mov dx,msgE
 mov ah,09h
 int 21h
.resta:
 mov ax,0000h
 mov dx,0003h
 mov bx,0001h
 mov cx,0001h
 sub ax,bx
 sbb dx,cx
 mov [resLo],ax
 mov [resHi],dx
 cmp ax,0FFFFh
 jne .error_resta
 cmp dx,0001h
 jne .error_resta
 mov dx,msgR
 mov ah,09h
 int 21h
 jmp .fin
.error_resta:
 mov dx,msgER
 mov ah,09h
 int 21h
.fin:
 xor ah,ah
 int 16h
 mov ax,4C00h
 int 21h
