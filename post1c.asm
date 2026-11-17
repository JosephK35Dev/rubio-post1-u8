; post1c.asm - REPNE SCASB busca caracter y muestra indice decimal
bits 16
org 100h
section .data
cadena db 'Arquitectura de Computadores',0
LONG_CAD equ 28
objetivo db 0
indice dw 0
msg_busca db 'Buscando d en Arquitectura de Computadores: $'
msg_hallado db 'Hallado en indice base-0: $'
msg_no db 13,10,'Buscando z: No encontrado.$'
nl db 13,10,'$'
section .text
start:
 mov ax,ds
 mov es,ax
 mov dx,msg_busca
 mov ah,09h
 int 21h
 mov byte [objetivo],'d'
 mov al,[objetivo]
 mov di,cadena
 mov cx,LONG_CAD
 cld
 repne scasb
 jne .no_hallado
 mov bx,di
 sub bx,cadena
 dec bx
 mov [indice],bx
 mov dx,msg_hallado
 mov ah,09h
 int 21h
 mov ax,[indice]
 call imprimir_decimal
 jmp .buscar_z
.no_hallado:
 mov dx,msg_no
 mov ah,09h
 int 21h
.buscar_z:
 mov byte [objetivo],'z'
 mov al,[objetivo]
 mov di,cadena
 mov cx,LONG_CAD
 cld
 repne scasb
 jne .z_ausente
 mov dx,msg_hallado
 mov ah,09h
 int 21h
 mov bx,di
 sub bx,cadena
 dec bx
 mov ax,bx
 call imprimir_decimal
 jmp .fin
.z_ausente:
 mov dx,msg_no
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
