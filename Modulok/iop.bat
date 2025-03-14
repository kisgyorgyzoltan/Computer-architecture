nasm -f win32 iopelda.asm
nasm -f win32 ionum.asm
nlink ionum.obj iopelda.obj -lmio -o iopelda.exe
del ionum.obj
del iopelda.obj