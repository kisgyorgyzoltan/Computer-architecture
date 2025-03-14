	; Kisgyorgy Zoltan, 532, kzim2149
	%include 'mio.inc'
	%include 'ionum.inc'
	%include 'iostr.inc'
	%include 'strings.inc'
	
	global main
	
	%macro print 1
	push esi
	mov esi, %1
	call WriteStr
	pop esi
	%endmacro
	
	%macro println 1
	push esi
	mov esi, %1
	call WriteLnStr
	pop esi
	%endmacro
	
	section .text
main:
	; 5. feladat
.olvas1:
	mov esi, str_a
	mov edi, str_seged
	mov ecx, 50
	
	println keremstr1
	call ReadStr
	jc .olvas1_hiba
	
	call StrLen
	print hosszstr
	call WriteInt
	
	
	call StrCompact              ; A - str_a - ben kompaktalas utan str_segedben
	push esi
	mov esi, edi
	println kompaktstr
	call WriteLnStr
	
	call StrLower
	println kisstr
	call WriteLnStr
	
	
	call StrUpper
	println nagystr
	call WriteLnStr
	pop esi
	
	call StrUpper
	mov edi, str_c
	call StrCat
	mov esi, str_c               ; az elso nagybetus valtozata str_c - ben
	jmp .olvas2
.olvas1_hiba:
	mov esi, hiba
	call WriteLnStr
	jmp .olvas1
.olvas2:
	mov esi, str_b
	mov edi, str_seged
	println keremstr2
	call ReadStr
	jc .olvas2_hiba
	
	call StrLen
	print hosszstr
	call WriteInt
	
	println kompaktstr
	call StrCompact
	push esi
	mov esi, edi
	call WriteLnStr
	call StrLower
	println kisstr
	call WriteLnStr
	println nagystr
	call StrUpper
	call WriteLnStr
	pop esi
	
	jmp .eredmeny
.olvas2_hiba:
	mov esi, hiba
	call WriteLnStr
	jmp .olvas2
.eredmeny:
	mov esi, str_b
	call StrLower
	mov edi, str_c
	call StrCat
	mov esi, edi
	
	println eredmenystr
	call WriteLnStr
	
	println hosszstr
	call StrLen
	call WriteInt
	
	ret
	
	section .data
eredmenystr db "Az eredmeny: ", 0
	keremstr1 db "Kerem az elso stringet!", 0
	keremstr2 db "Kerem a masodik stringet!", 0
	hiba db "Hiba a beolvasas kozben!", 0
kompaktstr db "A kompakt string: ", 0
hosszstr db "A string hossza: ", 0
nagystr db "A nagybetus string: ", 0
kisstr db "A kisbetus string: ", 0
	section .bss
	str_a resb 50
	str_b resb 50
	str_c resb 50
	str_seged resb 50
