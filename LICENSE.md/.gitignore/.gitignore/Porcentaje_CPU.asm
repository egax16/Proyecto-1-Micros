
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

;-------------------------  MACRO #3  ----------------------------------
;Macro-1: hex_a_dec
;	Convierte un valor HEX de 1 digitos y lo imprime como decimal en la consola
;	Recibe 1 parametro de entrada:
;		%1 es el valor hex que se desea imprimir en la consola
;-----------------------------------------------------------------------
%macro hex_a_dec 1 	;Recibe como parametro el numero HEX
	;Limpiamos R10 y luego almacenamos el valor hex que queremos imprimir
	xor r10,r10
	mov r10,[%1]
	;Ahora limpiamos R11 y lo cargamos con un 10
	xor r11,r11
	mov r11,0xA
	;Comparamos R10 y R11
	cmp r10,r11
	;Si r10 es mayor que r11, entonces se debe imprimir 2 nibbles:
	bp01:
	jge mayor_que_10
	;Si es menor que 10, entonces simplemente lo convertimos a ASCII y se imprime
		;Primero se hace el lookup con XLAT
		lea ebx,[tabla]
		mov al,r10b
		xlat
		mov [valor_dec],ax
		;Y ahora se imprime
		impr_texto valor_dec,1
		;y salimos de la macro
		jmp final_de_macro
	mayor_que_10:
		;Si es mayor que 10, entonces el primer paso es imprimir un 1
		impr_texto cons_diez,1
		;Ahora, a r10 se le debe restar 10
		sub r10,0xA
		;Y con el valor actualizado, hacemos el lookup
		lea ebx,[tabla]
		mov al,r10b
		xlat
		mov [valor_dec],ax
		bp02:
		;Y ahora se imprime el remanente
		impr_texto valor_dec,1
		;y salimos de la macro
	final_de_macro:
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


section .bss
	resultado: resb 64
	valor_hex: resb 10
	valor_dec: resb 10
	un_byte: resb 10

section .text
global _start

_start:
	

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
	mov [un_byte],rax	

_bp0:
	impr_texto cons_CPU,cons_tam_CPU
	mov r8,[un_byte]
	mov [valor_hex],r8
	hex_a_dec valor_hex

_finalizar_programa:
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
