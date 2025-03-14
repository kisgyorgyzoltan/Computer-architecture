	; Kisgyorgy Zoltan, 532, kzim2149
	%include 'mio.inc'
	%include 'ionum.inc'

    global main

    section .text
main:
    .start:
    ; call ReadInt64 ; edx:eax 
    ; call ReadHex64
    call ReadBin64
    jc .hiba
    ; call WriteHex64
    ; call WriteInt64
    nop
    call WriteBin64
    ; call mio_writeln
    ; push eax
    ; mov eax, edx
    ; call WriteBin
    ; call mio_writeln
    ; pop eax
    ; call WriteBin

    ret

.hiba:
    mov eax, hiba
    call mio_writestr
    call mio_writeln
    jmp .start

section .data
    hiba db 'Hiba tortent!', 0
