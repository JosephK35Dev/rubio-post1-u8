; post1d.asm - REPE CMPSB compara iguales y diferentes
bits 16
org 100h
section .data
cad1 db 'NASM x86'
cad2 db 'NASM x86'
cad3 db 'NASM ARM'
msg1 db 'cad1 vs cad2: Iguales (8 bytes).',13,10,'$'
msg2 db 'cad1 vs cad3: Diferentes; indice base-0: $'
msg_cx db ' CX restante=$'
hexbuf db '0000$'
nl db 13,10,'$'
section .text
start:
 mov ax,ds
 mov es,ax
 mov si,cad1
 mov di,cad2
 mov cx,8
 cld
 repe cmpsb
 jne .error_igual
 mov dx,msg1
 mov ah,09h
 int 21h
 jmp .comparar_distinto
.error_igual:
 mov dx,nl
 mov ah,09h
 int 21h
.comparar_distinto:
 mov si,cad1
 mov di,cad3
 mov cx,8
 cld
 repe cmpsb
 je .error_diferente
 mov bx,si
 sub bx,cad1
 dec bx
 mov dx,msg2
 mov ah,09h
 int 21h
 mov ax,bx
 call imprimir_decimal
 mov dx,msg_cx
 mov ah,09h
 int 21h
 mov ax,cx
 call imprimir_hex
 jmp .fin
.error_diferente:
 mov dx,nl
 mov ah,09h
 int 21h
.fin:
 mov dx,nl
 mov ah,09h
 int 21h
 xor ah,ah
 int 16h
 mov ax,4C00h
 int 21h
imprimir_decimal:
 aam
 add ax,3030h
 push ax
 mov dl,ah
 mov ah,02h
 int 21h
 pop ax
 mov dl,al
 mov ah,02h
 int 21h
 ret
imprimir_hex:
 mov bx,ax
 mov si,hexbuf+3
 mov cx,4
.hex_digito:
 mov al,bl
 and al,0Fh
 cmp al,9
 jbe .numero
 add al,'A'-10
 jmp .guardar
.numero:
 add al,'0'
.guardar:
 mov [si],al
 dec si
 shr bx,1
 shr bx,1
 shr bx,1
 shr bx,1
 loop .hex_digito
 mov dx,hexbuf
 mov ah,09h
 int 21h
 ret
