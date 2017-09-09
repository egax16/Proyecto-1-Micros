;######################## SEGMENTO DE MACROS ###########################
;Las macros, son funciones que reciben parametros de entrada y ejecutan
;acciones sobre esos parametros.
;Se debe indicar el numero de parametros de entrada y ejecutar las
;operaciones en la macro. Luego, se puede llamar la macro desde el
;programa principal

;Ejemplos de Macros:

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
;section .bss
section .data
	cons_nueva_linea: db 0xa
  	tabla: db "0123456789ABCDEF",0
  	cons_hex_header: db ' 0x'
  	cons_tam_hex_header: equ $-cons_hex_header
	nombre_archivo: db '/sys/block/sda/size',0
	cons_nombres_archivo: equ $-nombre_archivo
  	cons_header: db ' 0x'
  	cons_tam_header: equ $-cons_hex_header
	cons_discoduro db 'Tamano total disco duro en GB: 0x'
	cons_tam_discoduro: equ $-cons_discoduro

section .bss

	contenido_archivo: resb 32
	dos_byte: resb 1
	result: resb 32

section .text
global _start

_start:
	mov ebx, nombre_archivo
	mov eax, 5
	mov ecx, 0
	mov edx, 0
	int 80h
	mov eax,3
	mov ebx,3
	mov ecx,contenido_archivo
	mov edx, 200
	int 80h



;-------------------------------------------------------------------
;-----Ahora se quiere imprimir el tamano disponible del disco duro--


	impr_texto cons_discoduro,cons_tam_discoduro
	
	mov edx,[contenido_archivo + 4]	;busca el segundo registro de memoria total de ram
	and edx,0x0F000000			;hace un and y deja solo los ultimos 4 bits del registro
	shr edx, 24
	mov eax,edx			;pone en la direccion de salida el valor del numero ASCII respectivo a esos 4 bits

	mov edx,[contenido_archivo + 4]
	and edx,0x000F0000
	shr edx,12
	or eax,edx

	mov edx,[contenido_archivo + 4]
	and edx,0x00000F00
	or eax,edx

	mov edx,[contenido_archivo + 4]
	and edx,0x0000000F
	shl edx,12
	or eax,edx

	mov edx,[contenido_archivo]
	and edx,0x0F000000
	shr edx,8
	or eax,edx

	mov edx,[contenido_archivo]
	and edx,0x000F0000
	shl edx,4
	or eax,edx

	mov edx,[contenido_archivo]
	and edx,0x00000F00
	shl edx,16
	or eax,edx

	mov edx,[contenido_archivo]
	and edx,0x0000000F
	shl edx,28
	or eax,edx

	mov r8,0x512
	mov r9,0x1000000000
	mul r8
	div r9


	mov [result],eax
_prueba:	
	lea ebx,[tabla]	
	mov edx,[result]
	and edx,0xF00
	shr edx,8
	mov al,dl
	xlat
	mov [dos_byte],ax
	impr_texto dos_byte,1

	 
	mov edx,[result]
	and edx,0x0F0
	shr edx,4
	mov al,dl
	xlat
	mov [dos_byte],ax
	impr_texto dos_byte,1


	mov edx,[result]
	and edx,0x00F
	mov al,dl
	xlat
	mov [dos_byte],ax
	impr_linea dos_byte,1


;===================================================================================
;Finalizacion del programa. Devolver condiciones para evitar un segmentation fault
	mov	eax,1	;(sys_exit)
	mov	ebx,0	;exit status 0
	int	0x80	;llamar al sistema
	syscall
;===================================================================================
