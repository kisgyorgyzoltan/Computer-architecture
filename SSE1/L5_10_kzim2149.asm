; Kisgyorgy Zoltan, 532, Lab5-10
;Lebegőpontos műveletek
%include 'mio.inc'

global main 

section .text
main:
	; 10. E(a,b,c,d) = 2*b - c^4 + 2.1 * a^3 - 3.2 * c^2 + 5 * d - 1.3
	call	beolvas_h	;	a-t
	movss	xmm7,xmm0	;	xmm7-be
	call	beolvas_e	;	b-t
	movss	xmm6,xmm0	;	xmm6-ba
	call	beolvas_h	;	c-t
	movss	xmm5,xmm0	;	xmm5-be
	call	beolvas_e	;	d-t
	movss	xmm4,xmm0	;	xmm4-be

    movss	xmm0,xmm6    ;	xmm0-ba b
    mulss	xmm0,[ketto] ;	xmm0-ba 2*b
    movss	xmm1,xmm5    ;	xmm1-ba c
    mulss	xmm1,xmm1    ;	xmm1-ba c^2
    mulss	xmm1,xmm1    ;	xmm1-ba c^4
    subss	xmm0,xmm1    ;	xmm0-ba 2*b - c^4
    movss    xmm1,xmm7    ;	xmm1-ba a
    mulss    xmm1,xmm1    ;	xmm1-ba a^2
    mulss    xmm1,xmm7    ;	xmm1-ba a^3
    mulss    xmm1,[kettopontegy] ;	xmm1-ba 2.1 * a^3
    addss    xmm0,xmm1    ;	xmm0-ba 2*b - c^4 + 2.1 * a^3
    movss    xmm1,xmm5    ;	xmm1-ba c
    mulss    xmm1,xmm1    ;	xmm1-ba c^2
    mulss    xmm1,[harompontketto] ;	xmm1-ba 3.2 * c^2
    subss    xmm0,xmm1    ;	xmm0-ba 2*b - c^4 + 2.1 * a^3 - 3.2 * c^2
    movss    xmm1,xmm4    ;	xmm1-ba d
    mulss    xmm1,[ot]    ;	xmm1-ba 5 * d
    addss    xmm0,xmm1    ;	xmm0-ba 2*b - c^4 + 2.1 * a^3 - 3.2 * c^2 + 5 * d
    subss    xmm0,[egypontharom] ;	xmm0-ba 2*b - c^4 + 2.1 * a^3 - 3.2 * c^2 + 5 * d - 1.3

    call	kiir_h		; eredmeny kiirasa
    call    kiir_e      ; eredmeny kiirasa

    ret
;;;;FUGGVENYEK;;;;
	
WriteStr:		; kiirja az esi-be tett stringet
		push	eax
		push	ebx
		push	ecx
		push	edx
		push	esi
		push	edi
		mov		ebx,esi
		mov		eax,0
		mov		ecx,0xffffffff
		.irsk:
			inc		ecx
			mov		al,[ebx+ecx]
			cmp		al,0
			je		.vegesk
			call	mio_writechar
			jmp		.irsk
		.vegesk:
			pop		edi
			pop		esi
			pop		edx
			pop		ecx
			pop		ebx
			pop		eax
			ret
WriteInt: ;eax-et irja ki
		push	eax
		push	ebx
		push	ecx
		push	edx
		push	esi
		push	edi
		
		mov		ebx,eax

		mov esi,0
		cmp	ebx,dword 0
		je	.nullaaa
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
			ret
		.nullaaa:
			mov		eax,0
			mov		al,48
			call	mio_writechar
			pop		edi
			pop		esi
			pop		edx
			pop		ecx
			pop		ebx
			pop		eax

			ret
		ret
		
beolvas_h:	;XMM0-ba olvas
	mov		ebx,0 ; pont elotti szam
	mov		edx,0 ; pont utani szam
	mov		ecx,0 ; pont utan hany db szamjegy van
	mov		edi,1 ; minuszhoz
	mov		esi,kerekbh
	call	WriteStr
	call	mio_writeln
	
	.olvaspontigh:	;beolvasom az egesz reszt
		mov		eax,0
		call	mio_readchar
		;ENTER
		cmp		al,byte 13
		je		.alakith
		;PONT
		cmp		al,byte '.'
		je		.ponth
		;MINUSZ
		cmp		al,byte '-'
		je		.minuszh
		;SZAM-E?
		cmp		al,byte '0'
		jl		.hibabh
		cmp		al,byte '9'
		jg		.hibabh
		call	mio_writechar
		sub		al,byte '0'
		imul	ebx,10
		add		ebx,eax
		jmp		.olvaspontigh
	.ponth:					;kiirom a '.' karaktert es olvasom a tizedes reszt
		call	mio_writechar
		jmp		.olvaspontutanh
	.olvaspontutanh:		; tizedes resz
		mov		eax,0
		call	mio_readchar
		;ENTER
		cmp		al,byte 13
		je		.alakith
		;SZAM-E?
		cmp		al,byte '0'
		jl		.hibabh
		cmp		al,byte '9'
		jg		.hibabh
		call	mio_writechar
		inc		ecx
		sub		al,byte '0'
		imul	edx,10
		add		edx,eax
		jmp		.olvaspontutanh
		
	.alakith:		; egesz es tizedes reszt lebegopontos szamma alakitom
		cvtsi2ss	xmm0,ebx
		cvtsi2ss	xmm1,edx
		
	.ciklusbh:		; tizedes reszt alakitom megfeleloen
		cmp		ecx,0
		je		.kilepbh
		divss	xmm1,[tiz]
		dec		ecx
		jmp		.ciklusbh
		
	.minuszh:		; '-' eseten megjegyzem hogy negativ a szam
		mov		edi,-1
		call	mio_writechar
		jmp		.olvaspontigh
		
	.kilepbh:
		addss	xmm0,xmm1
		cmp		edi,-1
		jg		.vegebh
		mulss	xmm0,[minuszegy]
		
	.vegebh:
		call	mio_writeln
		ret
		
	.hibabh:
		mov		esi,hibastr
		call	WriteStr
		call	mio_writeln
		
		ret
		
kiir_h:		;XMM0 tartalmat irja ki
	movss		xmm3,xmm0	; az eredeti szamot eltarolom
	movss		xmm1,[nulla]
	comiss		xmm0,[nulla]
	jae			.kh		; pozitiv vagy negativ-e a szam amit ki akarok iratni
	mov			eax,0
	mov			al,'-'
	call		mio_writechar
	mulss		xmm0,[minuszegy]
	.kh:
	cvttss2si	eax,xmm0	;kiirom az egesz reszt es a pontot
	call		WriteInt
	mov			eax,0
	mov			al,'.'
	call		mio_writechar
	roundss		xmm1,xmm0,1
	subss		xmm0,xmm1
	mov			ecx,4
	mov			eax,0
	.cikluskh:				; egyenkent kiirom a tizedes resz szamjegyeit
		mulss		xmm0,[tiz]
		cvttss2si	eax,xmm0
		call		WriteInt
		roundss		xmm1,xmm0,1
		subss		xmm0,xmm1
		dec			ecx		
		cmp			ecx,dword 0
		jg			.cikluskh
	call		mio_writeln
	movss		xmm0,xmm3 ; vissza teszem xmm0-ba az eredeti szamot
	ret
	
beolvas_e:	;XMM0-ba olvas
	mov		ebx,0 ; pont elotti szam
	mov		edx,0 ; pont utani szam
	mov		ecx,0 ; pont utan hany db szamjegy van
	mov		edi,1 ; minuszhoz
	mov		esi,kerekbe
	call	WriteStr
	call	mio_writeln
	
	.olvaspontige:		; beolvassa a pont elotti reszt
		mov		eax,0
		call	mio_readchar
		;ENTER
		cmp		al,byte 13
		je		.vegee
		;PONT
		cmp		al,byte '.'
		je		.ponte
		;MINUSZ
		cmp		al,byte '-'
		je		.minusze
		;SZAM-E?
		cmp		al,byte '0'
		jl		.hibabe
		cmp		al,byte '9'
		jg		.hibabe
		call	mio_writechar
		sub		al,byte '0'
		imul	ebx,10
		add		ebx,eax
		inc		ecx
		cmp		ecx,2
		jg		.hibabe
		jmp		.olvaspontige
		
	.ponte:
		cmp		ecx,1	; megnezi hogy a pont utan hany szam karakter volt
		jne		.hibabe
		call	mio_writechar
		mov		ecx,0
		jmp		.olvaspontutane
		
	.olvaspontutane:	; edx-be felepiti a tizedes reszt
		mov		eax,0
		call	mio_readchar
		;e KARAKTER
		cmp		al,byte 'e'
		je		.evolt
		;E KARAKTER
		cmp		al,byte 'E'
		je		.evolt
		;SZAM-E?
		cmp		al,byte '0'
		jl		.hibabe
		cmp		al,byte '9'
		jg		.hibabe
		call	mio_writechar
		sub		al,byte '0'
		imul	edx,10
		add		edx,eax
		inc		ecx
		jmp		.olvaspontutane
		
	.evolt:		; 'e' vagy 'E' karakter eseten tovabb lep
		call	mio_writechar
		push	edi
		push	ecx
		mov		esi,0
		mov		ecx,0
		mov		edi,1
		jmp		.eutan
		
	.eutan:		; az 'e' utan levo szam ecx-be
		mov		eax,0
		call	mio_readchar
		inc		esi
		;e+
		cmp		al,byte '+'
		je		.plusze
		;e-
		cmp		al,byte '-'
		je		.minuszeutan
		;ENTER
		cmp		al,byte 13
		je		.feldolgozase
		;SZAM-E?
		cmp		al,byte '0'
		jl		.hibabe
		cmp		al,byte '9'
		jg		.hibabe
		call	mio_writechar
		
		sub		al,byte '0'
		imul	ecx,dword 10
		add		ecx,eax
		jmp		.eutan
		
	.plusze:	; 'e' karakter utan ha '+' karaktert irok be
		cmp		esi,1	; ellenorzi hogy az elejere olvastam-e be a pluszt
		jne		.hibabe
		call	mio_writechar
		jmp		.eutan
		
	.minuszeutan:	; 'e' karakter utan ha '-' karaktert irok be
		cmp		esi,1	;szabad-e minusz ott legyen
		jne		.hibabe
		mov		edi,-1
		call	mio_writechar
		jmp		.eutan
		
	.feldolgozase:
		
		imul		ecx,edi
		mov			edi,ecx
		pop			ecx		; ecx = a pont utan beolvasott szamok szama
		cvtsi2ss	xmm0,ebx ;pl 1 --> 1.0 egesz resz
		cvtsi2ss	xmm1,edx ;pl 4664 --> 4664.0 tizedes resz
	.tizedese:
		cmp			ecx,dword 0
		je			.mivolte
		divss		xmm1,[tiz]
		dec			ecx
		jmp			.tizedese
		
	.mivolte:		; pozitiv vagy negativ volt-e az e utani szam
		addss		xmm0,xmm1 ;pl 1.554545 ( me`g meg kell szorozni 10^ecx-el)
		cmp			edi,0
		je			.kilepbe
		jg			.pluszvolte
		imul		edi,-1
		jmp			.minuszvolte
		
		.pluszvolte:	; *10-el edi-szer
			cmp		edi,0
			je		.kilepbe
			mulss	xmm0,[tiz]
			dec		edi
			jmp		.pluszvolte
			
		.minuszvolte:	; ; /10-el edi-szer
			cmp		edi,0
			je		.kilepbe
			divss	xmm0,[tiz]
			dec		edi
			jmp		.minuszvolte
		
	.minusze:	; a szam elejen ha '-'-at olvasok be
		cmp		ecx,0
		jne		.hibabe
		call	mio_writechar
		imul	edi,dword -1
		jmp		.olvaspontige
		
	.kilepbe:
		pop		edi
		cmp		edi,dword 0
		jg		.vegee
	.negativszame:	; ha negativ szamot olvastam be szoroz -1 -el
		mulss	xmm0,[minuszegy]
	.vegee:
		call	mio_writeln
		ret
	.hibabe:
		call	mio_writeln
		mov		esi,hibastr
		call	WriteStr
		call	mio_writeln
		ret
		
kiir_e: ;XMM0-t irja ki exponencialis formaban
	movss		xmm3,xmm0	;az eredeti szamot eltarolom
	movss		xmm1,[nulla]
	mov			esi,0	;tiz hatvanyait szamolom (- is lehet)
	comiss		xmm0,[nulla] ; pozitiv vagy negativ-e a szam
	jae			.nagykicsi
	mov			eax,0
	mov			al,'-'
	call		mio_writechar
	mulss		xmm0,[minuszegy]
	.nagykicsi:
		comiss		xmm0,[egy]
		jb			.kisebbmintegy
	.egytizedes:	; addig osztom a szamot amig az egesz resz <=9 lesz
		cvttss2si	edx,xmm0
		cmp			edx,9
		jle			.tovabbke
		divss		xmm0,[tiz]
		inc			esi
		jmp			.egytizedes
		
	.kisebbmintegy:	; addig szorzom a szamot amig az egesz resz <=9 lesz
		cvttss2si	edx,xmm0
		cmp			edx,1
		jge			.tovabbke
		mulss		xmm0,[tiz]
		dec			esi
		jmp			.kisebbmintegy
		
	.tovabbke:
		mov			eax,edx
		call		WriteInt ;kiirom a pont elotti szamjegyet
		mov			eax,0
		mov			al,byte '.' ; pont
		call		mio_writechar
		cvtsi2ss 	xmm1,edx
		subss		xmm0,xmm1 ; csak a tizedes resz marad
		mov			ecx,6
		
	.irke:
		mulss		xmm0,[tiz] ; kiirom a tizedes resz szamjegyeit
		cvttss2si	eax,xmm0
		call		WriteInt
		roundss		xmm1,xmm0,1
		subss		xmm0,xmm1
		dec			ecx
		cmp			ecx,0
		jg			.irke
		
	mov		eax,0
	mov		al,byte 'e' ; 'e'-t kiirom
	call	mio_writechar
	mov		eax,esi
	call	WriteInt	; kiirom az e utani szamot
	call	mio_writeln
	movss	xmm0,xmm3
	ret
	
section .data
	hibastr db "Hiba", 0
	kerekbh  db "Kerek egy klasszikus float-ot!", 0
	kerekbe  db "Kerek egy e-s float-ot!", 0
    egy    dd 1.0
    ketto dd 2.0
    negy dd 4.0
    kettopontegy dd 2.1
    harom dd 3.0
    harompontketto dd 3.2
    ot dd 5.0
    egypontharom dd 1.3
	nulla  dd 0.0
	tiz	   dd 10.0
	minuszegy dd -1.0
