@echo off
echo Compilando %1.ASM
nasm -f bin %1.ASM -o %1.COM
dir %1.COM
