	; Kisgyorgy Zoltan, 532, kzim2149
	%include 'mio.inc'
	
	
	global ReadStr, WriteStr, WriteLnStr, NewLine
	
	section .text
ReadStr:                      ; esi - be beolvas egy stringet
	
	push eax
	push ebx
	push ecx
	push edx
	push edi
	
	mov edi, ecx                 ; edi - be a max hossz
	inc edi						 ;edi - be a max hossz + 1 a '0' miatt
	mov ebx, esi                 ; ebx - be a string cime
	mov ecx, 0
	mov eax, 0
.olvas:
	; karakter beolvasasa eax - be
	mov eax, 0
	call mio_readchar

	;ENTER
	cmp al, 13
	je .vege

	;BACKSPACE
	cmp al, 8
	je .backspacers

	cmp ecx, edi
	jge .haTobbMintMax
	mov [ebx + ecx], al
.haTobbMintMax:
	inc ecx
	call mio_writechar
	jmp .olvas
.backspacers:                 ;backspace kezeles
	cmp ecx, 0 				; ha ures a string
	je .olvas
	
	mov al, 8
	call mio_writechar
	mov al, ' '
	call mio_writechar
	mov al, 8
	call mio_writechar
	
	cmp ecx, edi
	jge .torolTobbMintMax
	mov [ebx + ecx], byte 0
.torolTobbMintMax:
	dec ecx
	jmp .olvas
	
.vege:
	cmp ecx, edi
	jge .hibars

	mov [ebx + ecx], byte 0
	call NewLine
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax

	clc

	ret
.hibars:
	call NewLine 				 ; ujsorba lep
	; regiszterek visszaallitasa
	pop edi
	pop edx
	pop ecx
	pop ebx
	pop eax
	; hiba jelzes
	stc

	ret
WriteStr:                     ; kiirja az esi - be tett stringet
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	mov ebx, esi
	mov eax, 0
	mov ecx, 0xffffffff
.irsk:
	inc ecx
	mov al, [ebx + ecx]
	cmp al, 0
	je .vegesk
	call mio_writechar
	jmp .irsk
.vegesk:
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
WriteLnStr:                   ; kiirja az esi - be tett stringet es ujsorba lep
	push eax
	push ebx
	push ecx
	push edx
	push esi
	push edi
	mov ebx, esi
	mov eax, 0
	mov ecx, 0xffffffff
.irsk:
	inc ecx
	mov al, [ebx + ecx]
	cmp al, 0
	je .vegesk
	call mio_writechar
	jmp .irsk
.vegesk:
	call NewLine
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret
	
NewLine:                      ;ujsorba lep
	push eax
	mov eax, 13
	call mio_writechar
	mov eax, 10
	call mio_writechar
	pop eax
	ret
	
	
