	; Kisgyorgy Zoltan, kzim2149, 532
	; [azok a betűk, amelyek az abc - ben az A egymás utáni betűi között vannak, 
	; ha azok növekvő sorrendben vannak (pl. "aefha" => "bcdg", 
	; valamint a kis és nagy betűket nem tekintjük egymás utániaknak, 
	; tehát Ac között nincs sem B, 
	; sem BCDEFGHIJKLMOPQRSTUVWXZYab)]
	; + [annyi "X" karakter, ahány magánhangzó van B - ben]
	%include 'mio.inc'
	
	
	global main
	
	section .text
main:

	mov ebx, str_a
	call str_beolvas
	call str_kiir
	
	mov ebx, str_b
	call str_beolvas
	call str_kiir

	mov eax, [str_a + 0]
	mov [len_a], al              ; len_a = str_a hossza
	
	mov eax, [str_b + 0]
	mov [len_b], al              ; len_b = str_b hossza
	
	; megyunk vegig a str_a - n
	mov [len_c], byte 1          ; uj string hossza = j = 1 (1 byte a string hossza)
	mov ecx, 1                   ; i = 0 + 1 a pascal tipusu stringek miatt
	mov eax, [str_a + 0]
	cmp al, 2
	jl .vege1
	
	mov eax, [str_a + ecx]
	
	mov edx, 0                   ; edx = j = 0
	mov dl, [len_a]              ; edx = len_a
	dec dl                       ; edx = len_a - 1
	
.ciklus1:
	cmp dl, 0                    ; ha a string végére értünk, i <= len_a - 1
	je .vege1
	
	push ecx                     ; i - t elmentjuk
	inc ecx                      ; i = i + 1
	mov ebx, [str_a + ecx]       ; ebx = str_a[i + 1]
	pop ecx                      ; i - t visszaallitjuk
	
	mov eax, [str_a + ecx]       ; eax = str_a[i]
	cmp al, 'A'                  ; ha a str_a[i] >= 'A'
	jl .nemnagybetu
	cmp al, 'Z'                  ; ha a str_a[i] <= 'Z'
	jg .nemnagybetu
	cmp bl, 'A'                  ; ha a str_a[i + 1] >= 'A'
	jl .nemnagybetu
	cmp bl, 'Z'                  ; ha a str_a[i + 1] <= 'Z'
	jg .nemnagybetu
	jmp .novekvoe
.nemnagybetu:
	cmp al, 'a'                  ; ha a str_a[i] >= 'a'
	jl .kovetkezopar
	cmp al, 'z'                  ; ha a str_a[i] <= 'z'
	jg .kovetkezopar
	cmp bl, 'a'                  ; ha a str_a[i + 1] >= 'a'
	jl .kovetkezopar
	cmp bl, 'z'                  ; ha a str_a[i + 1] <= 'z'
	jg .kovetkezopar
.novekvoe:
	; novekvo sorrenben vannak - e a betuk
	cmp al, bl
	jge .kovetkezopar            ; ha a str_a[i] >= str_a[i + 1]
.betuciklus:
	inc al                       ; al = kovektezo karakter
	cmp al, bl                   ; ha a kovektezo karakter = str_a[i + 1]
	je .kovetkezopar             ; elertem a str_a[i + 1] karaktert => megallok
	push edx                     ; j - t elmentjuk
	mov edx, 0                   ; edx = 0
	mov dl, [len_c]              ; edx = len_c
	mov [str_c + edx], al        ; str_c[j] = kovektezo karakter
	pop edx                      ; j - t visszaallitjuk
	inc byte [len_c]             ; uj string hossza = uj string hossza + 1
	jmp .betuciklus
.kovetkezopar:
	inc ecx                      ; i = i + 1
	dec dl
	jmp .ciklus1
	
.vege1:                       ; => megyunk vegig a str_b - n
	nop
	mov ecx, 1                   ; i = 0
	mov eax, [str_b + 0]         ; eax = str_b[0]
	cmp al, 0                    ; ha a str_b[0] = 0
	je .vege2
	mov eax, [str_b + ecx]       ; eax = str_b[i]
	mov edx, 0                   ; edx = 0
	mov dl, [len_b]              ; dl = len_b
	
.ciklus2:
	cmp dl, 0                    ; ha a string végére értünk
	je .vege2                    ; akkor vegeztunk
	
	mov eax, [str_b + ecx]       ; eax = str_b[i]
	; minden maganhangzo eseten X - et irunk a str_c - be
	cmp al, 'a'
	je .X
	cmp al, 'e'
	je .X
	cmp al, 'i'
	je .X
	cmp al, 'o'
	je .X
	cmp al, 'u'
	je .X
	cmp al, 'A'
	je .X
	cmp al, 'E'
	je .X
	cmp al, 'I'
	je .X
	cmp al, 'O'
	je .X
	cmp al, 'U'
	je .X
	
	inc ecx                      ; i = i + 1
	dec dl
	jmp .ciklus2
	
.X:
	push edx                     ; j - t elmentjuk
	mov edx, 0                   ; edx = 0
	mov dl, [len_c]              ; edx = j
	mov [str_c + edx], byte 'X'  ; str_c[j] = 'X'
	pop edx                      ; j - t visszaallitjuk
	inc byte [len_c]             ; uj string hossza = uj string hossza + 1
	inc ecx                      ; i = i + 1
	dec dl
	jmp .ciklus2
	
.vege2:
	; beirjuk a string hosszat a str_c elejere
	dec byte [len_c]             ; eax = j - 1 (a string hosszat nem szamoljuk bele)
	mov eax, [len_c]             ; eax = j
	mov [str_c + 0], al
	
	; kiiratjuk a str_c - t
	mov ebx, str_c
	call str_kiir
	
	ret
	
	;FUGGVENYEK
str_beolvas:                  ;ebx - el beolvas egy stringet
	push eax
	push ecx
	mov ecx, 0
	mov eax, 0
.olvas:
	mov eax, 0
	call mio_readchar
	cmp al, 13
	je .vege
	inc ecx
	mov [ebx + ecx], al
	call mio_writechar
	jmp .olvas
.vege:
	mov [ebx + 0], cl
	call mio_writeln
	pop ecx
	pop eax
	ret
str_kiir:                     ; kiirja az ebx - be tett stringet
	push eax
	push ecx
	push edx
	mov edx, 0
	mov ecx, 0
	mov eax, 0
	mov cl, [ebx + 0]
	
.ir:
	cmp dl, cl
	je .vege
	mov al, [ebx + edx + 1]
	call mio_writechar
	inc dl
	jmp .ir
.vege:
	call mio_writeln
	pop edx
	pop ecx
	pop eax
	ret

	section .bss
	str_a resb 100
	str_b resb 100
	str_c resb 200
	len_a resb 1
	len_b resb 1
	len_c resb 1
