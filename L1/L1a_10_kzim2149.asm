; Kisgyorgy Zoltan, kzim2149, 532
; L1a_10
; A. feladat – aritmetikai kifejezés kiértékelése, „div” az egész osztás hányadosát, „mod” pedig a maradékát jelenti. 
; a, b, c, d, e, f, g előjeles egész számok, az io_readint függvénnyel olvassuk be őket ebben a sorrendben. Az eredményt az io_writeint eljárás segítségével írjuk ki.

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
    push eax

    ;b-beolvas
    mov eax,str_b
    call io_writestr
	call io_readint
    push eax

    ;c-beolvas
    mov eax,str_c
    call io_writestr
	call io_readint
    push eax

    ;d-beolvas
    mov eax,str_d
    call io_writestr
	call io_readint
    push eax   

    ;e-beolvas
    mov eax,str_e
    call io_writestr
	call io_readint
    push eax

    ;f-beolvas
    mov eax,str_f
    call io_writestr
	call io_readint
    push eax
    
    ;g-beolvas
    mov eax,str_g
    call io_writestr
	call io_readint
    call io_writeln
    push eax
	
	; 1 - (a + (b div (a - (c div 6)))) - (g mod 48) - (d mod 42) + (((c * f) + e) div g)

    mov eax, [esp + 16] ; c
    mov ebx, 6
    cdq
    idiv ebx
    mov ebx, eax
    ; (c div 6) in ebx
    
    mov eax, [esp + 24] ; a
    sub eax, ebx
    ; (a - (c div 6)) in eax
    
    mov ebx, eax
    mov eax, [esp + 20] ; b
    cdq
    idiv ebx
    mov ebx, eax
    ; (b div (a - (c div 6))) in ebx
    
    mov eax, [esp + 24] ; a
    add eax, ebx
    mov ebx, eax
    ; (a + (b div (a - (c div 6))) in ebx

    mov eax, 1
    sub eax, ebx
    mov ecx, eax
    ; 1 - (a + (b div (a - (c div 6)))) in ecx

    mov eax, [esp] ; g
    mov ebx, 48
    cdq
    idiv ebx
    mov ebx, edx ; (g mod 48) in ebx
    mov eax, ecx ; 1 - (a + (b div (a - (c div 6)))) in eax
    sub eax, ebx ; 1 - (a + (b div (a - (c div 6)))) - (g mod 48) in eax
    mov ecx, eax
    ; 1 - (a + (b div (a - (c div 6)))) - (g mod 48) in ecx

    mov eax, [esp + 12] ; d
    mov ebx, 42
    cdq
    idiv ebx
    mov ebx, edx ; (d mod 42) in ebx
    mov eax, ecx ; 1 - (a + (b div (a - (c div 6)))) - (g mod 48) in eax
    sub eax, ebx ; 1 - (a + (b div (a - (c div 6)))) - (g mod 48) - (d mod 42) in eax
    mov ecx, eax
    ; 1 - (a + (b div (a - (c div 6)))) - (g mod 48) - (d mod 42) in ecx

    mov eax, [esp + 16] ; c
    mov ebx, [esp + 4] ; f
    xor edx, edx
    imul ebx ; (c * f) in eax
    mov ebx, [esp + 8] ; e
    add eax, ebx ; ((c * f) + e) in eax
    mov ebx, [esp] ; g
    cdq
    idiv ebx ; (((c * f) + e) div g) in eax
    mov ebx, eax ; (((c * f) + e) div g) in ebx
    mov eax, ecx ; 1 - (a + (b div (a - (c div 6)))) - (g mod 48) - (d mod 42) in eax
    add eax, ebx ; 1 - (a + (b div (a - (c div 6)))) - (g mod 48) - (d mod 42) + (((c * f) + e) div g) in eax
    call io_writeint ;;;;; to remove
    call io_writeln ;;;;; to remove

    mov ecx, eax ; eredmeny in ecx
    mov eax, str_eredmeny
    call io_writestr
    mov eax, ecx
    call io_writeint
	
	pop eax
	pop eax
	pop eax
	pop eax
	pop eax
	pop eax
	pop eax
    ret
section .data
    str_feladat  db '1 - (a + (b div (a - (c div 6)))) - (g mod 48) - (d mod 42) + (((c * f) + e) div g)', 0
    str_a  db 'a = ', 0 ; 24
    str_b  db 'b = ', 0 ; 20
    str_c  db 'c = ', 0 ; 16
    str_d  db 'd = ', 0 ; 12
    str_e  db 'e = ', 0 ; 8
    str_f  db 'f = ', 0 ; 4
    str_g  db 'g = ', 0 ; 0
    str_eredmeny  db '1 - (a + (b div (a - (c div 6)))) - (g mod 48) - (d mod 42) + (((c * f) + e) div g)=', 0
