; Kisgyorgy Zoltan, kzim2149, 532
; L1b_10
; B. feladat – bitenkénti logikai műveletek
; Írassuk ki a kiértékelendő kifejezést, olvassuk be az a, b, c, d értékeket az io_readint függvény segítségével, majd írassuk ki a beolvasott értékeket és az eredményt egymás alá bináris formában az io_writebin függvény segítségével.

%include 'io.inc'

global main 

section .text
main:
    ;feladat kiir
	mov eax,str_feladat
	call io_writestr
	call io_writeln

    ;a-beolvas
	mov eax,str_a
	call io_writestr
	call io_readint
	call io_writebin
	call io_writeln
    push eax

    ;b-beolvas
    mov eax,str_b
    call io_writestr
	call io_readint
	call io_writebin
	call io_writeln
    push eax

    ;c-beolvas
    mov eax,str_c
    call io_writestr
	call io_readint
	call io_writebin
	call io_writeln
    push eax

    ;d-beolvas
    mov eax,str_d
    call io_writestr
	call io_readint
	call io_writebin
	call io_writeln
    push eax   
	
    ;  ((b XOR a) AND (NOT c)) OR(d XOR (NOT d))
    mov eax, [esp+8] ; b
    mov ebx, [esp+12] ; a
    xor eax, ebx ; b XOR a
    mov ecx, eax ; ecx = b XOR a
    mov eax , [esp+4] ; c
    not eax ; NOT c
    and eax, ecx ; (NOT c) AND (b XOR a)
    mov ecx, eax ; ecx = (NOT c) AND (b XOR a)
    mov eax, [esp] ; d
    mov ebx, eax ; ebx = d
    not ebx ; NOT d
    xor eax, ebx ; d XOR (NOT d)
    or eax, ecx ; ((NOT c) AND (b XOR a)) OR (d XOR (NOT d)) 
    mov ebx, eax ; eredmeny
	mov eax, str_eredmeny
    call io_writestr
    call io_writeln
    mov eax, ebx ; eredmeny
    call io_writebin
	
	pop eax
	pop eax
	pop eax
	pop eax
	
    ret
section .data
    str_feladat  db '((b XOR a) AND (NOT c)) OR(d XOR (NOT d))', 0
    str_eredmeny  db '((b XOR a) AND (NOT c)) OR(d XOR (NOT d))= ', 0
    str_a  db 'a = ', 0 ; 12
    str_b  db 'b = ', 0 ; 8
    str_c  db 'c = ', 0 ; 4
    str_d  db 'd = ', 0 ; 0