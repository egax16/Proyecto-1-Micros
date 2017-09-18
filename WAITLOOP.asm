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


section .data
  cons_header: db 'Cuantos segundos desea esperar (0-9)? <luego presione enter>:'
  cons_tam_header: equ $-cons_header
	cons_retro_1: db 'Esperando (en segundos) hasta: '
	cons_tam_retro_1: equ $-cons_retro_1
	cons_retro_2: db 'Programa terminado: '
	cons_tam_retro_2: equ $-cons_retro_2
	cons_nueva_linea: db 0xa
	cuenta_ascii: db''
	cons_tam_cuenta_ascii: equ $-cuenta_ascii

	;Estructura para hacer una espera
	;tiempo_espera:
	;	tv_sec dq 5 ;Cantidad de espera en segundos
	;	tv_nsec dq 200000000 ;cantidad de espera en nanosegundos

section .bss
		valor_max: resb 3

		;Estructura para hacer una espera
		tiempo_espera:
			tv_sec: resq 1 ;Cantidad de espera en segundos
			tv_nsec: resq 9 ;cantidad de espera en nanosegundos


section .text
  global _start

_start:
	;Primero se imprime el encabezado
	impr_texto cons_header,cons_tam_header
	;Ahora se captura 1 teclazo
	mov rax,0
	mov rdi,0
	mov rsi,valor_max
	mov rdx,2 ;Solamente se captura un teclazo
	syscall
	;Se retorna al usuario el valor ingresado
	impr_texto cons_retro_1,cons_tam_retro_1
	impr_texto valor_max,2

	;El valor capturado es el que se va a esperar (en segundos)
	esperar:
		xor r11,r11
		mov r11,1
		;sub r11,0x30 ;ajuste para bajar de ASCII a decimal. Este ajuste funciona solo con 1 teclazo
		mov [tv_sec],r11b
		xor r10,r10
		mov r10,200000000
		mov [tv_nsec],r10
		bp00:
		mov rax,35 ;syscall
		mov rdi,tiempo_espera
		xor rsi,rsi
		syscall

_finalizar_programa:
	;Primero se imprime una linea en blanco para aclarar la consola
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,cons_nueva_linea	;0xa
	mov rdx,1	;1 byte
	syscall


	;Luego se retorna el control al sistema y se termina el programa
	impr_linea cons_retro_2,cons_tam_retro_2
  mov rax,60
  mov rdi,0
  syscall
