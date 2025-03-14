	; Kisgyorgy Zoltan, 532, kzim2149
	%include 'mio.inc'
	%include 'ionum.inc'
	
	global main
	
	%macro print 1
	push eax
	mov eax, %1
	call mio_writestr
	pop eax
	%endmacro
	
	%macro println 1
	push eax
	mov eax, %1
	call mio_writestr
	call mio_writeln
	pop eax
	%endmacro
	
	section .text
main:
.32bitolvas1:
	println kerem1
	call ReadInt
	
	jc .32bithiba1
	
	println decalak
	call WriteInt
	
	println hexalak
	print prefix
	call WriteHex
	
	println binalak
	call WriteBin
	
	mov ebx, eax                 ; elso szam
	jmp .32bitolvas2
.32bithiba1:
	println hiba
	jmp .32bitolvas1
.32bitolvas2:
	println kerem2
	call ReadHex
	jc .32bithiba2
	
	println decalak
	call WriteInt
	
	println hexalak
	print prefix
	call WriteHex
	
	println binalak
	call WriteBin
	
	mov ecx, eax                 ; masodik szam
	jmp .32bitolvas3
.32bithiba2:
	println hiba
	jmp .32bitolvas2
.32bitolvas3:
	print kerem3
	call ReadBin
	
	jc .32bithiba3
	
	println decalak
	call WriteInt
	
	println hexalak
	print prefix
	call WriteHex
	
	println binalak
	call WriteBin                ; eax - ben a harmadik szam
	jmp .32bitosszeg
.32bithiba3:
	println hiba
	jmp .32bitolvas3
.32bitosszeg:
	add eax, ecx
	add eax, ebx
	
	println eredmeny
	
	println decalak
	call WriteInt
	
	println hexalak
	print prefix
	call WriteHex
	
	println binalak
	call WriteBin
	jmp .64bit
.64bit:
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	call mio_writeln
	println hatvannegy
.64bitolvas1:
	print kerem1
	call ReadInt64
	
	jc .64bithiba1
	
	println decalak
	call WriteInt64
	
	println hexalak
	print prefix
	call WriteHex64
	
	println binalak
	call WriteBin64
	
	mov esi, edx
	mov edi, eax                 ; elso szam esi:edi - ben
	jmp .64bitolvas2
.64bithiba1:
	println hiba
	jmp .64bitolvas1
.64bitolvas2:
	print kerem2
	call ReadHex64
	jc .64bithiba2
	
	println decalak
	call WriteInt64
	
	println hexalak
	print prefix
	call WriteHex64
	
	println binalak
	call WriteBin64
	
	mov ebx, edx
	mov ecx, eax                 ; masodik szam ebx:ecx - ben
	jmp .64bitolvas3
.64bithiba2:
	println hiba
	jmp .64bitolvas2
.64bitolvas3:
	print kerem3
	call ReadBin64
	
	jc .64bithiba3
	
	println decalak
	call WriteInt64
	
	println hexalak
	print prefix
	call WriteHex64
	
	println binalak
	call WriteBin64          ; harmadik szam edx:eax - ben    
	jmp .64bitosszeg
.64bithiba3:
	println hiba
	jmp .64bitolvas3
.64bitosszeg:
	; esi:edi + ebx:ecx
	add edi, ecx
	adc esi, ebx

	; eddigi 64bitosszeg (esi:edi) + edx:eax
	add edi, eax
	adc esi, edx
	
	mov edx, esi
	mov eax, edi

	print eredmeny
	
	println decalak
	call WriteInt64
	
	println hexalak
	print prefix
	call WriteHex64
	
	println binalak
	call WriteBin64
	
	ret
	
	section .data
kerem1 db "Kerek egy decimalis szamot: ", 0
kerem2 db "Kerek egy hexadecimalis szamot: ", 0
kerem3 db "Kerek egy binaris szamot: ", 0
decalak db "Decimalis alakban: ", 0
hexalak db "Hexadecimalis alakban: ", 0
binalak db "Binarisan: ", 0
eredmeny db "Az osszeg: ", 0
hiba db "Hiba", 0
prefix db "0x", 0
hatvannegy db "Hatvannegy bites resz: ", 0