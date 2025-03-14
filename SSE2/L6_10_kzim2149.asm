; Kisgyorgy Zoltan, kzim2149, 532, Lab6-10 SSE vektorizálás
%include 'io.inc'

global main 

section .text
main:
	mov		eax,thossz
	call	io_writestr
	call	io_writeln
	call	io_readint
	mov		edi,eax
	mov		ebx,eax
	mov		ecx,eax
	mov		esi,0
	mov		edx,0
	mov		eax,bea
	call	io_writestr
	.beolvas_a:
		call	io_readflt
		movups	[A+esi],xmm0
		add		esi,4
		dec		ecx
		cmp		ecx,0
		jnle	.beolvas_a
	mov		esi,0
	mov		ecx,ebx
	mov		eax,beb
	call	io_writestr
	.beolvas_b:
		call	io_readflt
		movups	[B+esi],xmm0
		add		esi,4
		dec		ebx
		cmp		ebx,0
		jnle	.beolvas_b
		
	mov		eax,edi
	mov		ebx,4
	div		ebx
	mov		ebx,eax
	mov		eax,0
	
	.szamol:
		imul		eax,16
		movups		xmm0,[A+eax] ; a
		movups		xmm1,[B+eax] ; b

		;  2.7 * a * b xmm7
		movups		xmm7,[kettoponthet]
		mulps		xmm7,xmm0
		mulps		xmm7,xmm1
		
		; sqrt(a / 3) xmm6
		movups		xmm6,xmm0
		movups		xmm5,[harom]
		divps		xmm6,xmm5
		sqrtps		xmm6,xmm6

		; 2.7 * a * b - sqrt(a / 3) xmm7
		subps		xmm7,xmm6

		; max(a, b) xmm6
		movups		xmm6,xmm0
		maxps		xmm6,xmm1

		; 2.7 * a * b - sqrt(a / 3) + max(a, b)
		addps		xmm7,xmm6
		
		movups		[C+eax],xmm7 ; c
		
		xorps		xmm7,xmm7
		push		ecx
		mov			ecx,16
		idiv		ecx
		pop			ecx
		
		inc		eax
		cmp		eax,ebx
		jne		.szamol
		
	mov		eax,kic
	call	io_writestr
	call	io_writeln
	mov		eax,0
	mov		esi,0
	.kiir_c:
		movups	xmm0,[C+eax]
		add		eax,4
		call	io_writeflt
		call	io_writeln
		inc		esi
		cmp		esi,edi
		jne		.kiir_c
    ret
section .data
thossz db "Kerem a tombok hosszat!", 0
bea db "A elemei: ", 0
beb db "B elemei: ", 0
kic db "C elemei: ", 0
ketto dd 2.0,2.0,2.0,2.0
negy dd 4.0,4.0,4.0,4.0
harom dd 3.0,3.0,3.0,3.0
kettoponthet dd 2.7,2.7,2.7,2.7
section .bss
A resd 256
B resd 256
C resd 256