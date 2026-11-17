@echo off
nasm -f bin POST1.ASM -o POST1.COM
nasm -f bin POST1B.ASM -o POST1B.COM
nasm -f bin POST1C.ASM -o POST1C.COM
nasm -f bin POST1D.ASM -o POST1D.COM
nasm -f bin POST1E.ASM -o POST1E.COM
nasm -f bin POST2.ASM -o POST2.COM
nasm -f bin POST2B.ASM -o POST2B.COM
nasm -f bin POST2C.ASM -o POST2C.COM
nasm -f bin POST2D.ASM -o POST2D.COM
dir POST*.COM
