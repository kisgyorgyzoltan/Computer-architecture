; Kisgyorgy Zoltan, kzim2149, 532
; B. feladat

%include 'mio.inc'


global main

section .text
main:
	;A
	mov		eax,ka
	call	mio_writestr
	call	hex_beolvas		
	mov		[A],ecx
	
	;B
	mov		eax,kb
	call	mio_writestr
	call	hex_beolvas		
	mov		[B],ecx
	
	;C
	mov		eax,kc
	call	mio_writestr
	call	hex_beolvas		
	mov		[C],ecx
	
	; szabaly kiirasa
	mov		eax,szabaly
	call	mio_writestr
	call	mio_writeln
	
	mov		eax,ka
	call	mio_writestr
	mov		ecx,[A]
	call	bin_kiir
	call	mio_writeln
	
	mov		eax,kb
	call	mio_writestr
	mov		ecx,[B]
	call	bin_kiir
	call	mio_writeln
	
	mov		eax,kc
	call	mio_writestr
	mov		ecx,[C]
	call	bin_kiir
	call	mio_writeln

	mov		[ER],dword 0 ; eredmeny
	
	; C[18:15] OR B[21:18]
	mov		ecx,[C]
	and 	ecx, 0x00078000
	shr		ecx,15
	mov		edx,[B]
	and		edx, 0x003C0000
	shr		edx,18
	or		ecx,edx
	; eredmeny 31-28 bitjei
	shl 	ecx,28
	add 	[ER],ecx


	; B[27:26] OR C[21:20]
	mov		ecx,[B]
	and 	ecx, 0x0C000000
	shr		ecx,26
	mov		edx,[C]
	and 	edx, 0x00300000
	shr		edx,20
	or		ecx,edx
	; eredmeny 27-26 bitjei
	shl 	ecx,26
	add 	[ER],ecx

	; B[10:5] XOR 111011
	mov		ecx,[B]
	and 	ecx, 0x000007E0
	shr		ecx,5
	xor		ecx,0x0000003B
	; eredmeny 25-20 bitjei
	shl 	ecx,20
	add 	[ER],ecx

	; 01101
	mov		ecx,0x0000000D
	; eredmeny 19-15 bitjei
	shl 	ecx,15
	add 	[ER],ecx

	; A[16:4]
	mov		ecx,[A]
	and 	ecx, 0x0001FFF0
	shr		ecx,4
	; eredmeny 14-2 bitjei
	shl 	ecx,2
	add 	[ER],ecx

	; C[24:23]
	mov		ecx,[C]
	and 	ecx, 0x01800000
	shr		ecx,23
	; eredmeny 1-0 bitjei
	add 	[ER],ecx
	
	mov		ecx,[ER]
	call 	bin_kiir
	
	
	ret

	;FUGGVENYEK

	kar_konvert:
		cmp		al,'9'
		jle		.szam
		cmp		al,'F'
		jle		.nagybetu
		jmp		.kisbetu

		ret

		.szam:
			cmp al,'0'
			jl .hiba
			sub al,'0'
			ret

		.nagybetu:
			cmp		al,'A'
			jl		.hiba
			;cmp		al,'F'
			;jg		.hiba
			sub		al,55
			ret

		.kisbetu:
			cmp		al,'a'
			jl		.hiba
			cmp		al,'f'
			jg		.hiba
			sub		al,87
			ret

		.hiba:
			call	mio_writeln
			push	eax
			mov		eax,hiba
			call	mio_writestr
			call	mio_writeln
			pop		eax
			jmp		hex_beolvas
			ret
		ret

	hex_beolvas: ;ecx-be olvas
		mov		eax,0
		mov		ecx,0
		.olvash:
			mov		eax,0
			call	mio_readchar
			call	mio_writechar

			;ENTER
			cmp     al, 13
    		je      .endh

			call	kar_konvert ;al-ben
			shl		ecx,4
			add		ecx,eax
			jmp		.olvash

		.endh:
			call    mio_writeln
			ret
		ret

		bin_kiir: ; binarisan kiirja ecx tartalmat
			pusha
			mov		edx,ecx
			mov		edi,32
			mov		esi,4

			.ment:
				cmp		edi,0
				je		.vege
				cmp		esi,0
				je		.space
				
				shl		edx,1
				mov		eax,0
				adc		eax,48
				call	mio_writechar
				dec		edi
				dec		esi
				jmp		.ment

			.nulla:
				mov		al,'0'
				call	mio_writechar
				jmp		.ment

			.space:
				mov		al,' '
				call	mio_writechar
				mov		esi,4
				jmp		.ment

			.vege:
				popa
				ret

section .data
	ka db "A=", 0
	kb db "B=", 0
	kc db "C=", 0
	hiba db "Hiba", 0
	szabaly db "C[18:15] OR B[21:18], B[27:26] OR C[21:20], B[10:5] XOR 111011, 01101, A[16:4], C[24:23]", 0
section	.bss
	A resd 1
	B resd 1
	C resd 1
	ER resd 1