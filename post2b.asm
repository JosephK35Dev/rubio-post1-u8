; post2b.asm - BCD empaquetado con DAA y DAS
bits 16
org 100h
section .data
msg1 db 'DAA 47+38 = 85 (BCD).',13,10,'$'
msg2 db 'DAA 99+01 = 00; carry al siguiente byte.',13,10,'$'
msg3 db 'DAS 73-28 = 45 (BCD).',13,10,'$'
msg4 db 'DAS 20-01 = 19 (BCD).',13,10,'$'
msgE db 'Error en ajuste BCD.',13,10,'$'
section .text
start:
 mov al,47h
 add al,38h
 daa
 cmp al,85h
 jne .error
 mov dx,msg1
 mov ah,09h
 int 21h
 mov al,99h
 add al,01h
 daa
 jc .carry_ok
 jmp .error
.carry_ok:
 cmp al,00h
 jne .error
 mov dx,msg2
 mov ah,09h
 int 21h
 mov al,73h
 sub al,28h
 das
 cmp al,45h
 jne .error
 mov dx,msg3
 mov ah,09h
 int 21h
 mov al,20h
 sub al,01h
 das
 cmp al,19h
 jne .error
 mov dx,msg4
 mov ah,09h
 int 21h
 jmp .fin
.error:
 mov dx,msgE
 mov ah,09h
 int 21h
.fin:
 xor ah,ah
 int 16h
 mov ax,4C00h
 int 21h
