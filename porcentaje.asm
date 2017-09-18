;-------------------------  MACRO #1  ----------------------------------
;Macro-1: impr_texto.
;	Imprime un mensaje que se pasa como parametro
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
%macro impr_texto 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
%endmacro
;------------------------- FIN DE MACRO --------------------------------

;-------------------------  MACRO #2  ----------------------------------
;Macro-2: impr_linea.
;	Imprime un mensaje que se pasa como parametro y un salto de linea
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
%macro impr_linea 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
  	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,cons_nueva_linea	;primer parametro: Texto
	mov rdx,1	;segundo parametro: Tamano texto
	syscall
%endmacro
;------------------------- FIN DE MACRO --------------------------------


;===================================================================================
;Segmento de datos
;Declaracion de variables estaticas (ubicadas en memoria)

section .data
	cons_nueva_linea: db 0xa
	cons_diez: db '1'
	tabla: db "0123456789ABCDEF",0
  	cons_CPU db 'Porcentaje utilizacion del CPU: '
  	cons_tam_CPU: equ $-cons_CPU
	
	cons_header: db 'Cuanto tiempo desea evaluar el rendimiento (mmss) <luego presione enter>:'
  	cons_tam_header: equ $-cons_header
	cons_retro_1: db 'Esperando hasta: '
	cons_tam_retro_1: equ $-cons_retro_1
	cons_retro_2: db 'Programa terminado: '
	cons_tam_retro_2: equ $-cons_retro_2
	;cons_nueva_linea: db 0xa
	variable: db'' 

section .bss
	resultado: resb 64
	valor_hex: resb 10
	valor_dec: resb 10
	un_byte: resb 10
	dos_byte: resb 10
	valor_max: resb 3

		;Estructura para hacer una espera
		tiempo_espera:
			tv_sec: resq 1 ;Cantidad de espera en segundos
			tv_nsec: resq 9 ;cantidad de espera en nanosegundos


section .text
global _start

_start:

impr_texto cons_header,cons_tam_header
mov rax,0
mov rdi,0
mov rbp,0
mov rsi,variable
mov rdx,4
_break:
syscall
impr_texto cons_retro_1,cons_tam_retro_1
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,cons_nueva_linea	;0xa
	mov rdx,1	;1 byte
	syscall

	mov rax,1							;rax = "sys_write"
	mov rdi,1							;rdi = 1 (standard output = pantalla)
	mov rsi,variable					;rsi = mensaje a imprimir	
	mov rdx,4							;rdx=solo se imprime 1 byte
	syscall	
	mov rax,1							;rax = "sys_write"
	mov rdi,1							;rdi = 1 (standard output = pantalla)
	mov rsi,cons_nueva_linea
	mov rdx,1	
	syscall		
	mov r8,[variable]
	and r8,0x000000ff
	mov r9,[variable]
	and r9,0x0000ff00
	shr r9,8
	mov r10,[variable]
	and r10,0x00ff0000
	shr r10,16	
	mov r12,[variable]
	shr r12,24					;Llamar al sistema
	sub r8,0x30
	sub r9,0x30	
	sub r10,0x30
	sub r12,0x30
	mov rax,10
	mul r8
	mov r8, rax	
	add r8,r9
	mov rax, 60
	mul r8
	mov r8, rax
	mov rax, 10
	mul r10
	mov r10,rax	
	add r10,r12
	add r8,r10
	mov [variable],r8
	mov r14,0
	;cmp r8,0
	;je .end

esperar:
		.wait:			
		add r14,1		
		xor r11,r11
		mov r11,1
		mov [tv_sec],r11b
		xor r10,r10
		mov r10,200000000
		mov [tv_nsec],r10
		mov rax,35 ;syscall
		mov rdi,tiempo_espera
		syscall
		xor rsi,rsi			
	
	;mov r13,60
	;cmp r8,r13
	;je .end
	cmp r8,r14
	jne .wait

.end:
	
	impr_texto cons_CPU,cons_tam_CPU

	nop
	mov rax,0x63
	mov rdi,resultado
	mov rdx, resultado+8
	syscall
	mov rsi,[rdx]

_mul:
	mov rdx,0x0
	mov rax,rsi
	mov r8,0x64
	mul r8

_div:
	mov r9,0xffff
	div r9
	mov [dos_byte],rax	

_bp0:

	mov al,0
	lea ebx,[tabla]
	mov edx,[dos_byte]
	and edx,0x00F0
	shr edx,4
	mov al,dl
	xlat
	mov [un_byte],ax
	impr_texto un_byte,1


	mov edx,[dos_byte]
	and edx,0x000F
	mov al,dl
	xlat
	mov [un_byte],ax
	impr_linea un_byte,1	

	

fin:
	;Primero se imprime una linea en blanco para aclarar la consola
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,cons_nueva_linea	;0xa
	mov rdx,1	;1 byte
	syscall
	;Luego se retorna el control al sistema y se termina el programa
  	
	mov rax,60
  	mov rdi,0
  	syscall
