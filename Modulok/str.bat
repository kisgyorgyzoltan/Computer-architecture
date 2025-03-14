nasm -f win32 ionum.asm
nasm -f win32 iostr.asm
nasm -f win32 strings.asm
nasm -f win32 strpelda.asm
nlink ionum.obj iostr.obj strings.obj strpelda.obj -lmio -o str.exe
del ionum.obj
del iostr.obj
del strings.obj
del strpelda.obj