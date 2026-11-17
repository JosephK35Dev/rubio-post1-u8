; post1e.asm - LODSB/STOSB copia y convierte a mayusculas
bits 16
org 100h
section .data
origen db 'hola, mundo!',0
destino times 13 db 0
msg db 'Transformado: $'
msg_regs db 13,10,'Bytes copiados (CX inicial): 13; DF=0',13,10,'$'
nl db 13,10,'$'
section .text
start:
 mov ax,ds
 mov es,ax
 mov si,origen
 mov di,destino
 mov cx,13
 cld
.bucle:
 lodsb
 cmp al,'a'
 jb .guardar
 cmp al,'z'
 ja .guardar
 sub al,20h
.guardar:
 stosb
 loop .bucle
 mov dx,msg
 mov ah,09h
 int 21h
 mov si,destino
 call imprimir_nulo
 mov dx,msg_regs
 mov ah,09h
 int 21h
 xor ah,ah
 int 16h
 mov ax,4C00h
 int 21h
imprimir_nulo:
 lodsb
 or al,al
 jz .fin
 mov dl,al
 mov ah,02h
 int 21h
 jmp imprimir_nulo
.fin:
 ret
