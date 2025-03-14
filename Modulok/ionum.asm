	; Kisgyorgy Zoltan, 532, kzim2149
	%include 'mio.inc'
	
	
	global ReadInt, WriteInt, ReadBin, WriteBin, ReadHex, WriteHex, ReadInt64, WriteInt64, ReadHex64, WriteHex64, ReadBin64, WriteBin64
	
	section .text
	
	;FUGGVENYEK
	
ReadInt:                      ;eax - be lesz a szam decimalis alakban beolvasva
	push ebx
	push ecx
	push edx
	push esi
	push edi
	
	push ebp
	mov ebp, esp
	sub esp, 12                  ; max 11 karakter hoszusagu lehet a szam + 1 a 0 karakternek
	
	mov ecx, 0
	mov eax, 0
.olvasSzamjegyek:
	; karakter beolvasasa eax - be
	mov eax, 0
	call mio_readchar
	
	;ENTER
	cmp al, 13
	je .feldolgoz
	
	;BACKSPACE
	cmp al, 8
	je .backspace
	
	cmp ecx, 12                  ; ha a karakterek szama 12 vagy tobb, akkor nem csinalunk semmit de noveljuk a szamlalot
	jge .haTobbMint12
	
	mov [esp + ecx], al          ; a beolvasott karaktert eltaroljuk a veremben
	
.haTobbMint12:
	inc ecx
	call mio_writechar
	
	jmp .olvasSzamjegyek
	
.backspace:
	; ha a szamjegyek szama 0, akkor nem csinalunk semmit
	cmp ecx, 0
	je .olvasSzamjegyek
	
	; ha nem 0, akkor toroljuk az utolso karaktert
	mov al, 8
	call mio_writechar
	mov al, ' '
	call mio_writechar
	mov al, 8
	call mio_writechar
	
	cmp ecx, 12
	jge .torolTobbMint12
	mov [esp + ecx], byte 0      ; a torolt karakter helyere 0 - at irunk
.torolTobbMint12:
	dec ecx                      ; a szamjegyek szamat csokkentjuk
	jmp .olvasSzamjegyek
.feldolgoz:
	cmp ecx, 12
	jge .hiba
	
	mov [esp + ecx], byte 0      ; a lezaro 0 - at irjuk a szam vegee
	mov edi, 0                   ; a szamot edi - be szamoljuk
	mov ecx, - 1                 ; a ciklus elejen noveljuk, ezert - 1
	mov esi, 1                   ; pozitiv szamot feltetelezzuk
	jmp .strbol
.strbol:                      ; a stringbol kiveszem a karaktereket es atalakitom egy szamma
	inc ecx
	
	mov eax, 0
	mov al, [esp + ecx]          ; a szamjegyet kiolvasom a verembol
	
	cmp al, byte 0               ; ha a szamjegy 0, akkor vegeztunk
	je .vege
	
	cmp al, 45                   ; ha a szamjegy ' - ', akkor a szam negativ
	je .minusz
	
	cmp al, '0'                  ; ha a szamjegy kisebb mint '0', akkor hiba
	jl .hiba
	
	cmp al, '9'                  ; ha a szamjegy nagyobb mint '9', akkor hiba
	jg .hiba
	
	sub al, byte '0'             ; a szamjegybol kivonjuk a '0' - at, igy megkapjuk a szamjegy erteket
	; a szamot (edi) szorozzuk 10 - el majd hozzaadjuk a szamjegyet (eax)
	push ecx
	mov ecx, 10
	imul edi, ecx
	pop ecx
	
	add edi, eax
	jmp .strbol
	
.minusz:
	; ha a ' - ' nem az elso karakter, akkor hiba
	cmp edi, 0                   ; ha a szam 0 csak akkor lehet ' - '
	jne .hiba
	
	mov esi, - 1
	jmp .strbol
	
.vege:
	imul edi, esi                ; a szamot megszorozzuk azzal, hogy pozitiv vagy negativ
	mov eax, edi                 ; a szamot atirjuk eax - be
	call mio_writeln             ; uj sor
	
	; base pointer es stack pointer visszaallitasa
	mov esp, ebp
	pop ebp
	
	; tobbi regiszter visszaallitasa
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	
	ret
.hiba:
	call mio_writeln             ; uj sor
	
	; base pointer es stack pointer visszaallitasa
	mov esp, ebp
	pop ebp
	
	; tobbi regiszter visszaallitasa
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	
	; hiba jelzes carry flag beallitasaval
	stc
	
	ret
WriteInt:                     ;eax - et irja ki
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	
	mov ebx, eax                 ; szamot ebx - be
	
	mov esi, 0                   ; szamjegyek szama esi - ben
	cmp ebx, dword 0             ; ha a szam 0, akkor kiirunk egy 0 - at
	je .nullaaa
	cmp ebx, 0                   ; ha a szam negativ, akkor kiirjuk a - jelet es a szamot pozitivva tesszuk
	jl .negativ
	
.mentd:
	cmp ebx, 0
	je .kiirasd
	mov eax, ebx                 ; eax - be masoljuk a szamot
	mov ecx, 10                  ; ecx - be tesszuk a 10 - et
	cdq
	idiv ecx                     ; edx - be kerul a maradek, eax - be a hanyados
	mov ebx, eax                 ; ebx - be tesszuk a hanyadost
	add edx, '0'                 ; a maradekhoz hozzaadjuk a '0' - at, igy megkapjuk a szamjegyet
	push edx                     ; a szamjegyet berakjuk a verembe
	
	inc esi                      ; noveljuk a szamjegyek szamat
	jmp .mentd
	
.kiirasd:
	cmp esi, 0                   ; ha a szamjegyek szama 0, akkor vegeztunk
	je .veged
	pop eax                      ; eax - be kerul a szamjegy
	call mio_writechar           ; kiirjuk a szamjegyet
	dec esi                      ; csokkentjuk a szamjegyek szamat
	jmp .kiirasd
	
.negativ:
	mov eax, 45                  ; a ' - ' karakter
	call mio_writechar
	imul ebx, - 1
	jmp .mentd
	
.veged:
	; regiszterek visszaallitasa
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	call mio_writeln             ; uj sor
	
	ret
.nullaaa:
	mov eax, 0
	mov al, 48
	call mio_writechar           ; kiirjuk a 0 - at
	
	; regiszterek visszaallitasa
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	
	call mio_writeln             ; uj sor
	
	ret
	
ReadInt64:                    ; EDX:EAX - be lesz a szam decimalis alakban beolvasva
	push ebx
	push ecx
	push esi
	push edi
	
	push ebp
	mov ebp, esp
	sub esp, 21                  ; max 20 karakter hoszusagu lehet a szam + 1 a 0 karakternek
	
	mov ecx, 0
	mov eax, 0
.olvasSzamjegyek:
	; karakter beolvasasa eax - be
	mov eax, 0
	call mio_readchar
	
	;ENTER
	cmp al, 13
	je .feldolgoz
	
	;BACKSPACE
	cmp al, 8
	je .backspace
	
	cmp ecx, 21
	jge .haTobbMint21
	mov [esp + ecx], al          ; a beolvasott karaktert eltaroljuk a veremben
.haTobbMint21:
	inc ecx
	call mio_writechar
	
	jmp .olvasSzamjegyek
.backspace:
	; ha a szamjegyek szama 0, akkor nem csinalunk semmit
	cmp ecx, 0
	je .olvasSzamjegyek
	
	; ha nem 0, akkor toroljuk az utolso karaktert
	mov al, 8
	call mio_writechar
	mov al, ' '
	call mio_writechar
	mov al, 8
	call mio_writechar
	
	cmp ecx, 21
	jge .torolTobbMint21
	mov [esp + ecx], byte 0      ; a torolt karakter helyere 0 - at irunk
.torolTobbMint21:
	dec ecx                      ; a szamjegyek szamat csokkentjuk
	jmp .olvasSzamjegyek
.feldolgoz:
	cmp ecx, 21
	jge .hiba
	
	mov [esp + ecx], byte 0      ; a lezaro 0 - at irjuk a szam vegee
	
	mov eax, 0                   ; a szam 0 - 15 kozotti bitjeit eax - be szamoljuk
	mov edx, 0                   ; a szam 16 - 31 kozotti bitjeit edx - be szamoljuk
	
	mov ecx, - 1                 ; a ciklus elejen noveljuk, ezert - 1
	
	mov esi, 1                   ; pozitiv szamot feltetelezzunk
	
	jmp .strbol
.strbol:                      ; a stringbol kiveszem a karaktereket es atalakitom egy szamma
	inc ecx
	
	mov ebx, 0
	mov bl, [esp + ecx]          ; a szamjegyet kiolvasom a verembol
	
	cmp bl, byte 0               ; ha a szamjegy 0, akkor vegeztunk
	je .vege
	
	cmp bl, 45                   ; ha a szamjegy ' - ', akkor a szam negativ
	je .minusz
	
	cmp bl, '0'                  ; ha a szamjegy kisebb mint '0', akkor hiba
	jl .hiba
	
	cmp bl, '9'                  ; ha a szamjegy nagyobb mint '9', akkor hiba
	jg .hiba
	
	sub bl, byte '0'             ; a szamjegybol kivonjuk a '0' - at, igy megkapjuk a szamjegy erteket
	
	; Szorzas 10 - el
	push ecx
	mov ecx, 10
	
	mov edi, edx                 ; lementem az eredeti edx - et edi - be
	mul ecx                      ; eax - ot szorozzuk 10 - el
	
	push eax                     ; lementem a szorzott eaxot
	push edx                     ; uj edx - et is
	
	mov eax, edi                 ; eredeti edx * 10
	imul eax, ecx
	jc .hiba
	pop edi
	add eax, edi
	mov edx, eax
	pop eax
	
	pop ecx
	
	add eax, ebx                 ; hozzaadjuk a szamjegyet
	adc edx, 0                   ; a carry flag - et hozzaadjuk a szam magasabb 16 bitjeihez
	jc .hiba
	
	jmp .strbol
.minusz:
	; ha a ' - ' nem az elso karakter, akkor hiba
	cmp ecx, 0                   ; ha a szam 0 csak akkor lehet ' - '
	jne .hiba
	
	mov esi, - 1
	jmp .strbol
.vege:
	clc
	cmp esi, - 1
	jne .nemnegativ
	not edx
	not eax
	add eax, 1
	adc edx, 0
.nemnegativ:
	call mio_writeln             ; uj sor
	
	; base pointer es stack pointer visszaallitasa
	mov esp, ebp
	pop ebp
	
	; tobbi regiszter visszaallitasa
	pop edi
	pop esi
	pop ecx
	pop ebx
	
	ret
.hiba:
	call mio_writeln             ; uj sor
	
	; base pointer es stack pointer visszaallitasa
	mov esp, ebp
	pop ebp
	
	; hiba jelzes carry flag beallitasaval
	stc
	
	; tobbi regiszter visszaallitasa
	pop edi
	pop esi
	pop ecx
	pop ebx
	
	ret
	
WriteInt64:                   ; EDX:EAX - et irja ki
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	
	mov esi, 0                   ; szamjegyek szama esi - ben
	cmp eax, dword 0             ; ha a szam 0, akkor kiirunk egy 0 - at
	jne .nemnulla
	cmp edx, dword 0
	jne .nemnulla
	jmp .nulla
.nemnulla:
	cmp edx, 0                   ; ha a szam negativ, akkor kiirjuk a - jelet es a szamot pozitivva tesszuk
	jl .negativ
	
.ment:
	mov ebx, 10
	
	; edx:eax osztasa 10 - el
	mov edi, eax                 ; regi eax - et mentem edi - be
	
	; edx / 10
	mov eax, edx                 ; edx - et atmasolom eax - be
	xor edx, edx                 ; nullazom edx - et
	div ebx
	; hanyados eax
	; maradek - > uj_edx = edx % 10
	push eax                     ; elmentem edx / 10 - et
	
	; uj_edx:regi_eax / 10
	mov eax, edi                 ; visszaallitom az eredeti eax - et
	div ebx
	; maradek edx, hanyados eax
	mov ecx, edx                 ; elmentem a maradekot ecx - be
	pop edx                      ; edx / 10 edx - be
	
	add ecx, '0'                 ; a maradekhoz hozzaadjuk a '0' - at, igy megkapjuk a szamjegyet
	push ecx                     ; a szamjegyet berakjuk a verembe
	
	inc esi                      ; noveljuk a szamjegyek szamat
	
	cmp edx, 0                   ; ha a szam 0, akkor vegeztunk
	jne .ment
	cmp eax, 0
	jne .ment
	jmp .kiiras
	
.kiiras:
	cmp esi, 0                   ; ha a szamjegyek szama 0, akkor vegeztunk
	je .veged
	pop eax                      ; eax - be kerul a szamjegy
	call mio_writechar           ; kiirjuk a szamjegyet
	dec esi                      ; csokkentjuk a szamjegyek szamat
	jmp .kiiras
.negativ:
	push eax
	mov eax, 45                  ; a ' - ' karakter
	call mio_writechar
	pop eax
	not edx
	not eax
	add eax, 1
	adc edx, 0
	jmp .ment
.veged:
	; regiszterek visszaallitasa
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	call mio_writeln             ; uj sor
	
	ret
.nulla:
	mov eax, 0
	mov al, 48
	call mio_writechar           ; kiirjuk a 0 - at
	
	; regiszterek visszaallitasa
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	
	call mio_writeln             ; uj sor
	
	ret
	
ReadBin:                      ;beolvas egy binaris szamot
	push ebx
	push ecx
	push edx
	push esi
	push edi

	push ebp
	mov ebp, esp
	sub esp, 33                  ; 32 biten 32 karakter lehet + 1 a 0 karakternek
	
	mov edi, 0                   ; db beolvasott karakter
.olvasrb:
	mov eax, 0                   ; eax - be olvasunk egy karaktert
	call mio_readchar
	
	;BACKSPACE
	cmp al, 8
	je .backspaceb
	
	;ENTER
	cmp al, 13
	je .feldolgoz
	
	cmp edi, 32                  ; ha a karakterek szama 32 vagy tobb, akkor nem csinalunk semmit de noveljuk a szamlalot
	jg .haTobbMint32
	mov [esp + edi], al          ; a beolvasott karaktert eltaroljuk a veremben
.haTobbMint32:
	inc edi                      ; noveljuk a beolvasott karakterek szamat
	call mio_writechar           ; kiirjuk a beolvasott karaktert
	jmp .olvasrb
.backspaceb:
	cmp edi, 0
	je .olvasrb

	mov al, 8
	call mio_writechar
	mov al, ' '
	call mio_writechar
	mov al, 8
	call mio_writechar
	shr ebx, 1                   ; vissza kell shiftelni a szamot, mert a backspace - el toroltunk egy szamjegyet
	
	cmp edi, 32
	jg .torolTobbMint32
	mov [esp + edi], byte 0      ; a torolt karakter helyere 0 - at irunk
.torolTobbMint32:
	dec edi                      ; csokkentjuk a beolvasott karakterek szamat
	jmp .olvasrb
.feldolgoz:
	cmp edi, 32
	jg .hibarb
	
	mov [esp + edi], byte 0      ; a lezaro 0 - at irjuk a szam vegere
	mov eax, 0                   ; a szamot eax - be szamoljuk
	mov ecx, - 1                 ; a szamjegyek szamat ecx - be
	jmp .strbolb
.strbolb:                     ; a stringbol kiveszem a karaktereket es atalakitom egy szamma
	inc ecx
	
	mov ebx, 0
	mov bl, [esp + ecx]          ; a szamjegyet kiolvasom a verembol
	
	cmp bl, byte 0               ; ha a szamjegy 0, akkor vegeztunk
	je .vegeb

	cmp bl, 48                   ; ha a szamjegy kisebb mint '0', akkor hiba
	jl .hibarb

	cmp bl, 49                   ; ha a szamjegy nagyobb mint '1', akkor hiba
	jg .hibarb

	sub bl, 48                   ; a szamjegybol kivonjuk a '0' - at, igy megkapjuk a szamjegy erteket
	
	shl eax, 1                   ; a szamot 1 - el balra shifteljuk
	add eax, ebx
	jmp .strbolb
.hibarb:
	call mio_writeln

	; base pointer es stack pointer visszaallitasa
	mov esp, ebp
	pop ebp
	
	; tobbi regiszter visszaallitasa
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	
	; hiba jelzes carry flag beallitasaval
	stc
	
	ret
.vegeb:
	call mio_writeln

	; base pointer es stack pointer visszaallitasa
	mov esp, ebp
	pop ebp
	
	; tobbi regiszter visszaallitasa
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	
	ret
ReadBin64:                    ; EDX:EAX - beolvas egy binaris szamot
	push ebx
	push ecx
	push esi
	push edi

	push ebp
	mov ebp, esp
	sub esp, 65                  ; 64 biten 64 karakter lehet + 1 a 0 karakternek
	
	mov edi, 0                   ; db beolvasott karakter
	mov ebx, 0                   ; a szamot ebx - be szamoljuk
.olvas:
	mov eax, 0                   ; eax - be olvasunk egy karaktert
	call mio_readchar
	
	;ENTER
	cmp al, 13
	je .feldolgoz

	;BACKSPACE
	cmp al, 8
	je .backspace
	
	cmp edi, 65                  ; ha a karakterek szama 64 vagy tobb, akkor nem csinalunk semmit de noveljuk a szamlalot
	jge .haTobbMint65
	mov [esp + edi], al          ; a beolvasott karaktert eltaroljuk a veremben
.haTobbMint65:
	inc edi                      ; noveljuk a beolvasott karakterek szamat
	call mio_writechar           ; kiirjuk a beolvasott karaktert
	jmp .olvas
.backspace:
	cmp edi, 0
	je .olvas

	mov al, 8
	call mio_writechar
	mov al, ' '
	call mio_writechar
	mov al, 8
	call mio_writechar
	shr ebx, 1                   ; vissza kell shiftelni a szamot, mert a backspace - el toroltunk egy szamjegyet
	
	cmp edi, 65
	jge .torolTobbMint65
	mov [esp + edi], byte 0      ; a torolt karakter helyere 0 - at irunk
.torolTobbMint65:
	dec edi                      ; csokkentjuk a beolvasott karakterek szamat
	jmp .olvas
.feldolgoz:
	cmp edi, 65
	jge .hibarb
	
	mov [esp + edi], byte 0      ; a lezaro 0 - at irjuk a szam vegee
	mov eax, 0                   
	mov edx, 0                   
	mov ecx, -1                 ; a szamjegyek szamat ecx - be
	jmp .strbol
.strbol:                      ; a stringbol kiveszem a karaktereket es atalakitom egy szamma
	inc ecx
	
	mov ebx, 0
	mov bl, [esp + ecx]          ; a szamjegyet kiolvasom a verembol
	
	cmp bl, byte 0               ; ha a szamjegy 0, akkor vegeztunk
	je .vege
	
	cmp bl, 48                   ; ha a szamjegy kisebb mint '0', akkor hiba
	jl .hibarb
	
	cmp bl, 49                   ; ha a szamjegy nagyobb mint '1', akkor hiba
	jg .hibarb

	sub bl, 48                   ; a szamjegybol kivonjuk a '0' - at, igy megkapjuk a szamjegy erteket
	shl edx, 1
	jc .hibarb

	shl eax, 1
	adc edx, 0                   ; a carry flag - et hozzaadjuk a szam magasabb 16 bitjeihez 
	
	add eax, ebx               
	
	jmp .strbol
.hibarb:
	call mio_writeln

	; base pointer es stack pointer visszaallitasa
	mov esp, ebp
	pop ebp
	
	; tobbi regiszter visszaallitasa
	pop edi
	pop esi
	pop ecx
	pop ebx
	
	; hiba jelzes carry flag beallitasaval
	stc
	
	ret
.vege:
	call mio_writeln

	; base pointer es stack pointer visszaallitasa
	mov esp, ebp
	pop ebp
	
	; tobbi regiszter visszaallitasa
	pop edi
	pop esi
	pop ecx
	pop ebx
	
	ret
WriteBin64:
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
		
	mov edi, 64                  ; 64 bitet irunk ki
.ment:

	cmp edi, 0
	je .vegewb
	
	; balra shiftelunk 1 - el, igy a legnagyobb helyierteku bit lesz a carry flag
	shl edx, 1
	
	; a carry flag - et ki kell irni karakterkent
	mov ebx, 0
	adc ebx, 48

	shl eax, 1
	adc edx, 0

	push eax
	mov eax, ebx
	call mio_writechar
	pop eax

	dec edi                      ; csokkentjuk a bitek szamat
	
	jmp .ment
.vegewb:
	call mio_writeln

	; regiszterek visszaallitasa
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	
	ret
WriteBin:                     ; binarisan kiirja eax - et
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	
	mov edx, eax
	
	mov edi, 32                  ; 32 bitet irunk ki
.ment:
	cmp edi, 0
	je .vegewb
	
	; balra shiftelunk 1 - el, igy a legnagyobb helyierteku bit lesz a carry flag
	shl edx, 1
	
	; a carry flag - et ki kell irni karakterkent
	mov eax, 0
	adc eax, 48
	call mio_writechar
	
	dec edi                      ; csokkentjuk a bitek szamat
	
	jmp .ment
.vegewb:
	; regiszterek visszaallitasa
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	call mio_writeln
	ret
	
ReadHex:                      ;eax - be olvas
	push ebx
	push ecx
	push edx
	push esi
	push edi
	
	push ebp
	mov ebp, esp
	sub esp, 9                   ; 32 biten 8 karakter lehet + 1 a 0 karakternek
	
	
	mov eax, 0                   ; a szamot eax - be szamoljuk
	mov ecx, 0                   ; a szamjegyek szamat ecx - be szamoljuk
.olvas:
	mov eax, 0
	call mio_readchar
	
	;ENTER
	cmp al, 13
	je .feldolgoz
	
	;BACKSPACE
	cmp al, 8
	je .backspace
	
	call mio_writechar           ; kiirjuk a beolvasott karaktert
	
	cmp ecx, 9                   ; ha a karakterek szama 8 vagy tobb, akkor nem csinalunk semmit de noveljuk a szamlalot
	jge .haTobbMint9
	mov [esp + ecx], al          ; a beolvasott karaktert eltaroljuk a veremben
.haTobbMint9:
	inc ecx
	jmp .olvas
.feldolgoz:
	cmp ecx, 9
	jge .hiba
	
	mov [esp + ecx], byte 0      ; a lezaro 0 - at irjuk a szam vegee
	mov ecx, - 1                 ; a szamjegyek szamat ecx - be
	mov ebx, 0                   ; a szamot ebx - be szamoljuk
	jmp .strbol
.backspace:
	cmp ecx, 0
	je .olvas
	
	mov al, 8
	call mio_writechar
	mov al, ' '
	call mio_writechar
	mov al, 8
	call mio_writechar
	
	cmp ecx, 9
	jge .torolTobbMint9
	mov [esp + ecx], byte 0      ; a torolt karakter helyere 0 - at irunk
.torolTobbMint9:
	dec ecx                      ; a szamjegyek szamat csokkentjuk
	
	jmp .olvas
.strbol:                      ; a stringbol kiveszem a karaktereket es atalakitom egy szamma
	inc ecx
	
	mov eax, 0
	mov al, [esp + ecx]          ; a szamjegyet kiolvasom a verembol
	
	cmp al, byte 0               ; ha a szamjegy 0, akkor vegeztunk
	je .vegehb
	
	call KarKonvert              ; konvertaljuk a karaktert szamma
	jc .hiba
	
	shl ebx, 4                   ; a szamot 4 - el balra shifteljuk
	add ebx, eax                 ; hozzaadjuk a szamot ebx - hez
	jmp .strbol
.vegehb:
	mov eax, ebx
	
	; base pointer es stack pointer visszaallitasa
	mov esp, ebp
	pop ebp
	
	; regiszterek visszaallitasa
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	call mio_writeln             ; uj sor
	
	clc
	
	ret
.hiba:
	call mio_writeln             ; uj sor
	
	; base pointer es stack pointer visszaallitasa
	mov esp, ebp
	pop ebp
	
	; regiszterek visszaallitasa
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	
	; hiba jelzes carry flag beallitasaval
	stc
	
	ret
ReadHex64:                    ; EDX:EAX - be olvas
	push ebx
	push ecx
	push esi
	push edi
	
	push ebp
	mov ebp, esp
	sub esp, 17                  ; 64 biten 16 karakter lehet + 1 a 0 karakternek
	
	
	mov eax, 0
	mov edx, 0
	mov ecx, 0                   ; a szamjegyek szamat ecx - be szamoljuk
.olvas:
	mov eax, 0
	call mio_readchar
	
	;ENTER
	cmp al, 13
	je .feldolgoz
	
	;BACKSPACE
	cmp al, 8
	je .backspace
	
	call mio_writechar           ; kiirjuk a beolvasott karaktert
	
	cmp ecx, 17                  ; ha a karakterek szama 8 vagy tobb, akkor nem csinalunk semmit de noveljuk a szamlalot
	jge .haTobbMint17
	mov [esp + ecx], al          ; a beolvasott karaktert eltaroljuk a veremben
.haTobbMint17:
	inc ecx
	jmp .olvas
.backspace:
	cmp ecx, 0
	je .olvas
	
	mov al, 8
	call mio_writechar
	mov al, ' '
	call mio_writechar
	mov al, 8
	call mio_writechar
	
	cmp ecx, 17
	jge .torolTobbMint17
	mov [esp + ecx], byte 0      ; a torolt karakter helyere 0 - at irunk
.torolTobbMint17:
	dec ecx                      ; a szamjegyek szamat csokkentjuk
	
	jmp .olvas
.feldolgoz:
	cmp ecx, 17
	jge .hiba
	
	mov [esp + ecx], byte 0      ; a lezaro 0 - at irjuk a szam vegee
	mov ecx, - 1                 ; a szamjegyek szamat ecx - be
	mov eax, 0
	mov edx, 0
	mov esi, 0xF0000000          ; maszk eax utolso 4 bitjenek kivagasahoz
	jmp .strbol
.strbol:                      ; a stringbol kiveszem a karaktereket es atalakitom egy szamma
	inc ecx
	
	mov ebx, 0
	mov bl, [esp + ecx]          ; a szamjegyet kiolvasom a verembol
	
	cmp bl, byte 0               ; ha a szamjegy 0, akkor vegeztunk
	je .vegehb
	
	push eax
	mov eax, ebx
	call KarKonvert              ; konvertaljuk a karaktert szamma
	mov ebx, eax                 ; a konvertalt szamot ebx - be tesszuk
	pop eax
	jc .hiba
	
	push eax
	and eax, esi                 ; a szam utolso 4 bitjet kivesszuk
	shr eax, 28                  ; a eax - ot 28 - al jobbra shifteljuk
	shl edx, 4                   ; a edx - et 4 - el balra shifteljuk
	add edx, eax                 ; hozzaadjuk az eax - et
	pop eax
	shl eax, 4                   ; az eax - ot 4 - el balra shifteljuk
	add eax, ebx                 ; hozzaadjuk a szamot
	
	jmp .strbol
.vegehb:
	call mio_writeln             ; uj sor
	
	; base pointer es stack pointer visszaallitasa
	mov esp, ebp
	pop ebp
	
	; regiszterek visszaallitasa
	pop edi
	pop esi
	pop ecx
	pop ebx
	
	clc
	
	ret
.hiba:
	call mio_writeln             ; uj sor
	
	; base pointer es stack pointer visszaallitasa
	mov esp, ebp
	pop ebp
	
	; regiszterek visszaallitasa
	pop edi
	pop esi
	pop ecx
	pop ebx
	
	; hiba jelzes carry flag beallitasaval
	stc
	
	ret
	
KarKonvert:                   ; eax: karaktereket szamma atalakito fuggveny hexadecimalis szamokhoz
	cmp al, '9'
	jle .szam
	cmp al, 'F'
	jle .nagybetu
	jmp .kisbetu
	
	ret
.szam:
	cmp al, '0'
	jl .hiba
	sub al, '0'
	
	ret
.nagybetu:
	cmp al, 'A'
	jl .hiba
	cmp al, 'F'
	jg .hiba
	sub al, 55
	
	ret
.kisbetu:
	cmp al, 'a'
	jl .hiba
	cmp al, 'f'
	jg .hiba
	sub al, 87
	
	ret
.hiba:
	stc
	
	ret
	
WriteHex64:                   ; EDX:EAX - et kiirja hexadecimalis alakban
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	
	mov edi, 16                  ; 16 karaktert kell kiirni
	mov esi, 0xF0000000          ; maszk utolso 4 bit kivagasahoz
.kiir:
	cmp edi, 0
	je .vege
	
	push edx
	and edx, esi
	mov ebx, edx                 ; ebx - be tesszuk a szam utolso 4 bitjet amit ki kell irni
	pop edx                      ; visszaallitjuk az eredeti edx - et
	shl edx, 4                   ; edx - et 4 - el balra shifteljuk
	
	push eax
	and eax, esi                 ; eax - be tesszuk a szam utolso 4 bitjet amit at kell vinni edx - be
	mov ecx, eax                 ; esi - be tesszuk a szam utolso 4 bitjet
	pop eax                      ; visszaallitjuk az eredeti eax - et
	shl eax, 4                   ; eax - et 4 - el balra shifteljuk
	
	shr ecx, 28                  ; eax - ot 28 - al jobbra shifteljuk
	add edx, ecx                 ; hozzaadjuk az ecx - et
	
	shr ebx, 28                  ; ebx - ot 28 - al jobbra shifteljuk

	cmp ebx, 9                   ; ha a szamjegy 9 - enel kisebb, akkor szam
	jle .szamh
	jg .betuh
.szamh:                       ; szamjegy karakterre konvertalasa
	add ebx, 48
	
	push eax
	mov eax, ebx
	call mio_writechar
	pop eax
	
	dec edi                      ; csokkentjuk a kiirando karakterek szamat
	jmp .kiir
	
.betuh:                       ; betu kiirasa
	add ebx, 87
	
	push eax
	mov eax, ebx
	call mio_writechar
	pop eax
	
	dec edi                      ; csokkentjuk a kiirando karakterek szamat
	jmp .kiir
.vege:
	call mio_writeln
	
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	
	ret
	
WriteHex:                     ;eax - et kiirja hexadecimalis alakban
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	
	mov ecx, eax                 ; szamot ecx - be
	
	mov eax, 0
	mov esi, 15
	mov edi, 8                   ; 8 karaktert kell kiirni
	mov edx, 8
	
.masolh:
	cmp edi, 0                   ; ha edi 0, akkor vegeztunk a beolvasassal
	je .irh
	mov eax, ecx
	and eax, esi                 ;eax - ben utolso szamjegy
	shr ecx, 4                   ;kiveszem ecx - bol az utolsot
	cmp eax, 9                   ; ha a szamjegy 9 - enel kisebb, akkor szam
	jle .szamh
	jg .betuh
	
.szamh:                       ; szamjegy karakterre konvertalasa
	add eax, 48
	push eax                     ; karaktert a verembe rakjuk
	dec edi                      ; csokkentjuk a kiirando karakterek szamat
	jmp .masolh
	
.betuh:                       ; betu kiirasa
	add eax, 87
	push eax                     ; karaktert a verembe rakjuk
	dec edi                      ; csokkentjuk a kiirando karakterek szamat
	jmp .masolh
	
.irh:                         ; kiirjuk a karaktereket a verembol
	cmp edx, 0
	je .vegeh
	pop eax
	call mio_writechar
	dec edx
	jmp .irh
	
	
.vegeh:
	call mio_writeln
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
	