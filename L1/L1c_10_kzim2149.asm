; Kisgyorgy Zoltan, kzim2149, 532
; L1c_10
; C. feladat – feltételes kifejezés
; Írassuk ki a kiértékelendő kifejezést, olvassuk be az a, b, c, d értékeket az io_readint függvény segítségével, majd írassuk ki a beolvasott értékeket és az eredményt egymás alá (előjeles egész számként).
; Megjegyzés: az  a, b, c értékek előjeles egészek, míg a d érték szigorúan pozitív (tekinthetünk rá előjeles számként is, de a tesztprogram csak pozitív értékeket fog generálni).

%include 'io.inc'

global main 

section .text
main:

    ;a-beolvas
	mov eax,str_a
	call io_writestr
	call io_readint
    mov edi,eax
    push eax

    ;b-beolvas
    mov eax,str_b
    call io_writestr
	call io_readint
    mov ebx,eax
    push eax

    ;c-beolvas
    mov eax,str_c
    call io_writestr
	call io_readint
    mov ecx,eax   
    push eax

    ;d-beolvas
    mov eax,str_d
    call io_writestr
	call io_readint
    push eax   
	
	mov eax,[esp+12]
	call io_writeint
	call io_writeln
	mov eax,[esp+8]
	call io_writeint
	call io_writeln
	mov eax,[esp+4]
	call io_writeint
	call io_writeln
	mov eax,[esp+0]
	call io_writeint
	call io_writeln
	
	;megoldas
	mov eax,[esp+0];d
	mov ebx,4
	cdq
	idiv ebx
	
	cmp edx,0
	je e1
	cmp edx,1
	je e2
	cmp edx,2
	je e3
    cmp edx,3
    je e4
	
    e1:
        ; 1 - c * b
        mov eax, str_e1
        call io_writestr
        call io_writeln

        mov eax, [esp + 4] ; c
        mov ebx, [esp + 8] ; b
        imul eax, ebx
        mov ebx, eax
        mov eax, 1
        sub eax, ebx ; eax = 1 - c * b
        call io_writeint
        call io_writeln
        jmp vege
    e2:
        ; (a * b) - (b mod 13)
        mov eax, str_e2
        call io_writestr
        call io_writeln
        mov eax, [esp + 12] ; a
        mov ebx, [esp + 8] ; b
        imul eax, ebx
        mov ecx, eax ; ecx = a * b
        mov eax, [esp + 8] ; b
        mov ebx, 13
        cdq
        idiv ebx
        mov ebx, edx ; ebx = b mod 13
        mov eax, ecx ; eax = a * b
        sub eax, ebx ; eax = (a * b) - (b mod 13)
        call io_writeint
        call io_writeln
        jmp vege
    e3:
        ; 11 - (2 * b)
        mov eax, str_e3
        call io_writestr
        call io_writeln
        mov eax, 2
        mov ebx, [esp + 8] ; b
        imul eax, ebx
        mov ebx, eax
        mov eax, 11
        sub eax, ebx ; eax = 11 - (2 * b)
        call io_writeint
        call io_writeln
        jmp vege
    e4:
        ; (a - c) * (b + c)
        mov eax, str_e4
        call io_writestr
        call io_writeln
        mov eax, [esp + 12] ; a
        mov ebx, [esp + 4] ; c
        sub eax, ebx ; eax = a - c
        mov ebx, [esp + 8] ; b
        mov ecx, [esp + 4] ; c
        add ebx, ecx ; ebx = b + c
        imul eax, ebx ; eax = (a - c) * (b + c)
        call io_writeint
        call io_writeln
	
    vege:
        pop eax
        pop eax
        pop eax
        pop eax
        
        ret
section .data
    str_a  db 'a = ', 0 ; 12
    str_b  db 'b = ', 0 ; 8
    str_c  db 'c = ', 0 ; 4
    str_d  db 'd = ', 0 ; 0
	str_e1 db '1 - c * b=', 0
	str_e2 db '(a * b) - (b mod 13)=', 0
	str_e3 db '11 - (2 * b)=', 0
	str_e4 db '(a - c) * (b + c)=', 0
