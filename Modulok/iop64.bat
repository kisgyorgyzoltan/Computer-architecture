nasm -f win32 iopelda64.asm
nasm -f win32 ionum.asm
nlink ionum.obj iopelda64.obj -lmio -o iopelda64.exe
del ionum.obj
del iopelda64.obj