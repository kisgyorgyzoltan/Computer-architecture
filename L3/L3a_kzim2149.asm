; Kisgyorgy Zoltan, kzim2149, 532
; A. feladat – bináris szám írása
; Írjunk assembly eljárást (NASM), amely egy 32 bites, előjel nélküli egész számot ír ki a képernyőre bináris formában, kötelezően mindig 32 bináris számjegy formájában (akkor is, ha 0-val kezdődik, pl: 0111 1011 0101 0100 1101 0010 1010 1011). A kiírás során csoportosítsuk négyesével a biteket. Készítsünk el egy, a függvényeket alkalmazó rövid példaprogramot is, amely az előző laborfeladatban szereplő hexadecimális pozitív egészet olvasó eljárást használva beolvas két számot, majd kiírja a beolvasott két számot és az összegüket is binárisan.%include 'mio.inc'
%include 'mio.inc'

global main


section .text
main:
	;Feladat: binaris szam irasa
	call	hex_beolvas	
	call	bin_kiir
	mov		ebx,ecx
	call	mio_writeln
	call	hex_beolvas	
	call	bin_kiir
	call	mio_writeln
	add		ecx,ebx
	mov		eax,osszeg
	call	mio_writestr
	call	bin_kiir

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

	hex_kiir: ;ecx-bol
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

		bin_kiir: ; binarisan kiirja ecx tartalmat
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
				ret

section .data
	kerem2 db "Kerem a szamot: ", 0
	hexalak db "Hexadecimalis alakban: ", 0
	hiba db "Hiba", 0
	prefix db "0x", 0
	osszeg db "A+B= ", 0