; post2d.asm - AAA/AAS con BCD desempaquetado
bits 16
org 100h
section .data
msgS db 'AAA: 7 + 8 = $'
msgR db 13,10,'AAS: 13 - 8 = $'
msgE db 13,10,'Error en AAA/AAS.',13,10,'$'
msgAh db ' (AH=00h)',13,10,'$'
section .text
start:
 mov ax,0003h
 int 10h
 mov dx,msgS
 mov ah,09h
 int 21h
 xor ah,ah
 mov al,07h
 add al,08h
 aaa
 cmp ax,0105h
 jne .error
 push ax
 mov dl,ah
 add dl,'0'
 mov ah,02h
 int 21h
 pop ax
 mov dl,al
 add dl,'0'
 mov ah,02h
 int 21h
 mov dx,msgR
 mov ah,09h
 int 21h
 mov ax,0103h
 sub al,08h
 aas
 cmp ax,0005h
 jne .error
 mov dl,al
 add dl,'0'
 mov ah,02h
 int 21h
 mov dx,msgAh
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
