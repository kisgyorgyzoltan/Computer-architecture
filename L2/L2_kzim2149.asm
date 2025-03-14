; Kisgyorgy Zoltan, kzim2149, 532
; L2
; Írjunk meg egy-egy ASM alprogramot (függvényt, eljárást) 32 bites, előjeles egész (decimális), illetve 32 bites, pozitív hexa számok beolvasására és kiírására.
%include 'mio.inc'


global main

section .text
main:
	;beolvas egy szamot decimalis egeszkent
	call	dec_beolvas
	
	;kiiratja decimalis (elojeles egesz) alakban
	call	dec_kiir	
	mov		ecx,ebx		
	
	;kiiratja hexadecimalis alakban
	call	hex_kiir	
	
	;beolvas egy masik szamot hexadecimalis egeszkent 
	call	hex_beolvas	
	call	mio_writeln	
	xchg	ebx,ecx		
	
	;kiiratja decimalis alakban
	call	dec_kiir	
	xchg	ebx,ecx		
	
	;kiiratja hexadecimalis alakban
	call	hex_kiir	
	call	mio_writeln	
	mov		eax,osszeg
	call	mio_writestr
	call	mio_writeln
	add		ebx,ecx
	call	dec_kiir
	mov		ecx,ebx
	call	hex_kiir


	ret

	;ebx-be lesz a szam decimalis alakban
	dec_beolvas: 
		mov	eax,kerem1
		call	mio_writestr
		mov		eax,0
		mov		ebx,0
		mov		ecx,1
		.olvasd:
			mov	eax,0
			call mio_readchar
			call mio_writechar

			; ENTER karakter
			cmp     al, 13
    		je      .endd



			;MINUSZ -
			cmp		al,'-'
			je		.minusz


			;HIBA NEM SZAM
			cmp		al,'0'
			jl		.hiba
			cmp		al,'9'
			jg		.hiba


			sub		al,'0'
			imul	ebx,10
			add		ebx,eax
			jmp .olvasd
		.endd:
			imul	ebx,ecx
			call    mio_writeln
			ret
		.minusz:
			imul	ecx,-1
			jmp		.olvasd
		.hiba:
			call	mio_writeln
			push	eax
			mov		eax,hiba
			call	mio_writestr
			call	mio_writeln
			pop		eax
			jmp		dec_beolvas
			ret
		ret

	dec_kiir: ;ebx-et irja ki
		push	eax
		push	ebx
		push	ecx
		push	edx
		push	esi
		push	edi

		mov		eax,decalak
		call	mio_writestr

		mov esi,0
		cmp ebx,0
		jl .negativ

		.mentd:		
			cmp		ebx,0
			je		.kiirasd
			mov		eax,ebx
			mov		ecx,10
			cdq
			idiv	ecx
			mov		ebx,eax
			add		edx,'0'
			push	edx

			inc		esi
			jmp		.mentd

		.kiirasd:
			cmp		esi,0
			je		.veged
			pop		eax
			call	mio_writechar
			dec		esi
			jmp		.kiirasd

		.negativ:
			mov		eax,'-'
			call	mio_writechar
			imul	ebx,-1
			jmp		.mentd

		.veged:
			pop		edi
			pop		esi
			pop		edx
			pop		ecx
			pop		ebx
			pop		eax
			call	mio_writeln
			ret
		ret

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

	;ecx-be olvas
	hex_beolvas: 
		mov	eax,kerem2
		call	mio_writestr
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

	;ecx-bol
	hex_kiir: 
		push	eax
		push	ebx
		push	ecx
		push	edx
		push	esi
		push	edi

		mov		eax,hexalak
		call	mio_writestr
		mov		eax,prefix
		call	mio_writestr
		mov		eax,0
		mov		esi,15
		mov		edi,8
		mov		edx,8


		.masolh:
			cmp		edi,0
			je		.irh
			mov		eax,ecx
			and		eax,esi ;eax-ben utolso szamjegy
			shr		ecx,4 ;kiveszem ecx-bol az utolsot
			cmp		eax,9
			jle		.szamh	
			jg		.betuh

		.szamh:
			add		eax,48
			push	eax
			dec		edi
			jmp		.masolh

		.betuh:
			;add		eax,55
			add		eax,87
			push	eax
			dec		edi
			jmp		.masolh

		.irh:
			cmp		edx,0
			je		.vegeh
			pop		eax
			call	mio_writechar
			dec		edx
			jmp		.irh


		.vegeh:
			call	mio_writeln
			pop		edi
			pop		esi
			pop		edx
			pop		ecx
			pop		ebx
			pop		eax
			ret
		ret
	kilep:
		ret
section .data
	kerem1 db "Kerem az elso szamot A= ", 0
	kerem2 db "Kerem a masodik szamot B=", 0
	decalak db "Decimalis alakban: ", 0
	hexalak db "Hexadecimalis alakban: ", 0
	hiba db "Hiba: karaktereknel", 0
	prefix db "0x", 0
	osszeg db "A+B", 0 