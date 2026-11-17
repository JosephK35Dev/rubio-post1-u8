; post2c.asm - calculadora de digitos con MUL y DIV
bits 16
org 100h
section .data
pA db 'Primer operando (0-9): $'
pB db 13,10,'Segundo operando (0-9): $'
promptOperador db 13,10,'Operacion (* o /): $'
msgR db 13,10,'Resultado: $'
msgRem db ' Resto: $'
msgZ db 13,10,'Division por cero.',13,10,'$'
msgOp db 13,10,'Operador invalido.',13,10,'$'
msgVal db 13,10,'Digite un numero de 0 a 9.',13,10,'$'
nl db 13,10,'$'
valorA db 0
valorB db 0
operador db 0
resultado db 0
resto db 0
section .text
start:
 mov ax,0003h
 int 10h
 mov dx,pA
 mov ah,09h
 int 21h
 mov ah,01h
 int 21h
 cmp al,'0'
 jb .invalido
 cmp al,'9'
 ja .invalido
 sub al,'0'
 mov [valorA],al
 mov dx,pB
 mov ah,09h
 int 21h
 mov ah,01h
 int 21h
 cmp al,'0'
 jb .invalido
 cmp al,'9'
 ja .invalido
 sub al,'0'
 mov [valorB],al
 mov dx,promptOperador
 mov ah,09h
 int 21h
 mov ah,01h
 int 21h
 mov [operador],al
 mov dx,msgR
 mov ah,09h
 int 21h
 cmp byte [operador],'*'
 je .multiplicar
 cmp byte [operador],'/'
 je .dividir
 mov dx,msgOp
 mov ah,09h
 int 21h
 jmp .fin
.multiplicar:
 mov al,[valorA]
 mul byte [valorB]
 call imprimirAX
 jmp .fin
.dividir:
 cmp byte [valorB],0
 je .division_cero
 xor ax,ax
 mov al,[valorA]
 div byte [valorB]
 mov [resultado],al
 mov [resto],ah
 xor ah,ah
 mov al,[resultado]
 call imprimirAX
 mov dx,msgRem
 mov ah,09h
 int 21h
 xor ax,ax
 mov al,[resto]
 call imprimirAX
 jmp .fin
.division_cero:
 mov dx,msgZ
 mov ah,09h
 int 21h
 jmp .fin
.invalido:
 mov dx,msgVal
 mov ah,09h
 int 21h
.fin:
 mov dx,nl
 mov ah,09h
 int 21h
 mov ax,4C00h
 int 21h
imprimirAX:
 mov bx,10
 xor cx,cx
.divide:
 xor dx,dx
 div bx
 push dx
 inc cx
 test ax,ax
 jnz .divide
.digito:
 pop dx
 add dl,'0'
 mov ah,02h
 int 21h
 loop .digito
 ret
