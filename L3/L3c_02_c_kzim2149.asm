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
	mov ebx, kerema
	call str_kiir

	mov ebx, str_a
	call str_beolvas
	call str_kiir

	mov ebx, keremb
	call str_kiir
	
	mov ebx, str_b
	call str_beolvas
	call str_kiir
	
	; megyunk vegig a str_a - n
	mov [dbc], dword 0           ; uj string hossza = j = 0
	mov ecx, 0                   ; i = 0
	mov eax, [str_a + 0]         ; eax = str_a[0]
	cmp al, 0                    ; ha a str_a[0] = 0
	je .vege1
	push ecx                     ; i - t elmentjuk
	inc ecx                      ; i = i + 1
	mov ebx, [str_a + ecx]       ; eax = str_a[i + 1]
	pop ecx                      ; i - t visszaallitjuk
	cmp bl, 0                    ; ha a str_a[i + 1] = 0
	je .vege1
.ciklus1:
	push ecx                     ; i - t elmentjuk
	inc ecx                      ; i = i + 1
	mov ebx, [str_a + ecx]       ; eax = str_a[i + 1]
	pop ecx                      ; i - t visszaallitjuk
	cmp bl, 0                    ; ha a str_a[i + 1] = 0
	je .vege1
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
	nop
	inc al                       ; al = kovektezo karakter
	cmp al, bl                   ; ha a kovektezo karakter = str_a[i + 1]
	je .kovetkezopar             ; elertem a str_a[i + 1] karaktert => megallok
	mov edx, [dbc]               ; edx = j
	mov [str_c + edx], al        ; str_c[j] = kovektezo karakter
	inc dword [dbc]              ; uj string hossza = uj string hossza + 1
	jmp .betuciklus
.kovetkezopar:
	inc ecx                      ; i = i + 1
	jmp .ciklus1
	
.vege1:                       ; megyunk vegig a str_b - n
	mov ecx, 0                   ; i = 0
	mov eax, [str_b + 0]         ; eax = str_b[0]
	cmp al, 0                    ; ha a str_b[0] = 0
	je .vege2
	
.ciklus2:
	mov eax, [str_b + ecx]       ; eax = str_b[i]
	cmp al, 0                    ; ha a str_b[i] = 0
	je .vege2                    ; akkor vegeztunk
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
	jmp .ciklus2
	
.X:
	mov edx, [dbc]               ; edx = j
	mov [str_c + edx], byte 'X'  ; str_c[j] = 'X'
	inc dword [dbc]              ; uj string hossza = uj string hossza + 1
	inc ecx                      ; i = i + 1
	jmp .ciklus2
	
.vege2:
	; lezaro 0 karakter
	mov eax, [dbc]               ; eax = j
	mov [str_c + eax], byte 0    ; str_c[j] = 0
	
	; kiiratjuk a str_c - t
	mov ebx, eredmeny
	call str_kiir

	mov ebx, str_c
	call str_kiir
	
	ret
	
	;FUGGVENYEK
str_beolvas:                  ;ebx - el beolvas egy stringet
	push eax, 
	push ecx
	mov ecx, 0xffffffff          ; - 1
	mov eax, 0
.olvas:
	mov eax, 0
	inc ecx
	call mio_readchar
	cmp al, 13
	je .vege
	mov [ebx + ecx], al
	call mio_writechar
	jmp .olvas
.vege:
	mov [ebx + ecx], byte 0
	call mio_writeln
	pop ecx
	pop eax
	ret
str_kiir:                     ; kiirja az ebx - be tett stringet
	push eax
	push ecx
	mov eax, 0
	mov ecx, 0xffffffff
.ir:
	inc ecx
	mov al, [ebx + ecx]
	cmp al, 0
	je .vege
	call mio_writechar
	jmp .ir
.vege:
	call mio_writeln
	pop ecx
	pop eax
	ret
	
	section .data
kerema db 'Kerem az a stringet: ', 0
keremb db 'Kerem a b stringet: ', 0
eredmeny db 'Az eredmeny: ', 0
	
	section .bss
	
	str_a resb 100
	str_b resb 100
	str_c resb 200
	dbc resd 1
