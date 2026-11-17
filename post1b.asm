; post1b.asm - variante optimizada REP MOVSW mas MOVSB impar
bits 16
org 100h
section .data
origen db 'HOLA, MUNDO!',0
destino times 13 db 0
msg db 'Copiado con MOVSW: $'
nl db 13,10,'$'
msg_cx db 'CX final=$'
msg_df db ' DF=$'
cx_fin dw 0
df_char db '0'
hexbuf db '0000$'
section .text
start:
 mov ax,ds
 mov es,ax
 mov si,origen
 mov di,destino
 mov cx,13
 cld
 mov ax,cx
 shr cx,1
 rep movsw
 and ax,1
 jz .sin_impar
 movsb
.sin_impar:
 mov [cx_fin],cx
 pushf
 pop ax
 and ax,0400h
 jz .df_cero
 mov byte [df_char],'1'
 jmp .imprimir
.df_cero:
 mov byte [df_char],'0'
.imprimir:
 mov dx,msg
 mov ah,09h
 int 21h
 mov si,destino
 call imprimir_nulo
 mov dx,nl
 mov ah,09h
 int 21h
 mov dx,msg_cx
 mov ah,09h
 int 21h
 mov ax,[cx_fin]
 call imprimir_hex
 mov dx,msg_df
 mov ah,09h
 int 21h
 mov dl,[df_char]
 mov ah,02h
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
