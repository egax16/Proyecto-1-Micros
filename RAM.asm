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

section .data
	cons_nueva_linea: db 0xa
	tabla: db "0123456789ABCDEF",0
  	cons_tamtotal db 'Tamano total de la RAM: 0x'
  	cons_tam_ram: equ $-cons_tamtotal
	cons_ramdisponible db 'Memoria RAM disponible: 0x'
	cons_tam_disponible: equ $-cons_ramdisponible



section .bss
	resultado: resb 64
	un_byte: resb 1

section .text
global _start

_start:
	

	nop
	mov rdi,resultado
	mov rax,0x63
	syscall

	impr_texto cons_tamtotal,cons_tam_ram

	
	mov al,0			;pone a al en 0
	mov edx,[resultado + 0x24]	;busca el segundo registro de memoria total de ram
	and edx,0x000F			;hace un and y deja solo los ultimos 4 bits del registro
	lea ebx,[tabla]			;direcciona los valores de tabla a ebx
	mov al,dl			;pone en al el valor a buscar en tabla
	xlat
	mov [un_byte],ax			;pone en la direccion de salida el valor del numero ASCII respectivo a esos 4 bits
	impr_texto un_byte,1


	mov edx,[resultado + 0x20]	;busca el primer registro de memoria total de ram
	and edx,0xF0000000		;hace un and y solo deja los 4 bits mas significativos 
	shr edx,28			;hace un corrimiento de 28 espacios a la derecha
	mov al,dl			;pone en al el valor a buscar en tabla
	xlat
	mov [un_byte],ax			;pone en la direccion de salida el valor del numero ASCII respectivo a esos 4 bits
	impr_texto un_byte,1


	mov edx,[resultado + 0x20]	;busca el primer registro de memoria total de ram
	and edx,0x0F000000		;hace un and y solo deja los bits entre [28:24]
	shr edx,24			;hace un corrimiento de 24 espacios a la derecha 
	mov al,dl			;pone en al el valor a buscar en tabla
	xlat
	mov [un_byte],ax			;pone en la direccion de salida el valor del numero ASCII respectivo a esos 4 bits
	impr_texto un_byte,1


	mov edx,[resultado + 0x20]
	and edx,0x00F00000
	shr edx,20
	mov al,dl
	xlat
	mov [un_byte],ax
	impr_texto un_byte,1


	mov edx,[resultado + 0x20]
	and edx,0x000F0000
	shr edx,16
	mov al,dl
	xlat
	mov [un_byte],ax
	impr_texto un_byte,1


	mov edx,[resultado + 0x20]
	and edx,0x0000F000
	shr edx,12
	mov al,dl
	xlat
	mov [un_byte],ax
	impr_texto un_byte,1


	mov edx,[resultado + 0x20]
	and edx,0x00000F00
	shr edx,8
	mov al,dl
	xlat
	mov [un_byte],ax
	impr_texto un_byte,1

	 
	mov edx,[resultado + 0x20]
	and edx,0x000000F0
	shr edx,4
	mov al,dl
	xlat
	mov [un_byte],ax
	impr_texto un_byte,1


	mov edx,[resultado + 0x20]
	and edx,0x0000000F
	mov al,dl
	xlat
	mov [un_byte],ax
	impr_linea un_byte,1


;-------------------------------------------------------------------
;-----Ahora se quiere imprimir el tamano disponible de memoria RAM--


	impr_texto cons_ramdisponible,cons_tam_disponible

	
	mov al,0			;pone a al en 0
	mov edx,[resultado + 0x2c]	;busca el segundo registro de memoria total de ram
	and edx,0x000F			;hace un and y deja solo los ultimos 4 bits del registro
	lea ebx,[tabla]			;direcciona los valores de tabla a ebx
	mov al,dl			;pone en al el valor a buscar en tabla
	xlat
	mov [un_byte],ax			;pone en la direccion de salida el valor del numero ASCII respectivo a esos 4 bits
	impr_texto un_byte,1


	mov edx,[resultado + 0x28]	;busca el primer registro de memoria total de ram
	and edx,0xF0000000		;hace un and y solo deja los 4 bits mas significativos 
	shr edx,28			;hace un corrimiento de 28 espacios a la derecha
	mov al,dl			;pone en al el valor a buscar en tabla
	xlat
	mov [un_byte],ax			;pone en la direccion de salida el valor del numero ASCII respectivo a esos 4 bits
	impr_texto un_byte,1


	mov edx,[resultado + 0x28]	;busca el primer registro de memoria total de ram
	and edx,0x0F000000		;hace un and y solo deja los bits entre [28:24]
	shr edx,24			;hace un corrimiento de 24 espacios a la derecha 
	mov al,dl			;pone en al el valor a buscar en tabla
	xlat
	mov [un_byte],ax			;pone en la direccion de salida el valor del numero ASCII respectivo a esos 4 bits
	impr_texto un_byte,1


	mov edx,[resultado + 0x28]
	and edx,0x00F00000
	shr edx,20
	mov al,dl
	xlat
	mov [un_byte],ax
	impr_texto un_byte,1


	mov edx,[resultado + 0x28]
	and edx,0x000F0000
	shr edx,16
	mov al,dl
	xlat
	mov [un_byte],ax
	impr_texto un_byte,1


	mov edx,[resultado + 0x28]
	and edx,0x0000F000
	shr edx,12
	mov al,dl
	xlat
	mov [un_byte],ax
	impr_texto un_byte,1


	mov edx,[resultado + 0x28]
	and edx,0x00000F00
	shr edx,8
	mov al,dl
	xlat
	mov [un_byte],ax
	impr_texto un_byte,1

	 
	mov edx,[resultado + 0x28]
	and edx,0x000000F0
	shr edx,4
	mov al,dl
	xlat
	mov [un_byte],ax
	impr_texto un_byte,1


	mov edx,[resultado + 0x28]
	and edx,0x0000000F
	mov al,dl
	xlat
	mov [un_byte],ax
	impr_linea un_byte,1


;===================================================================================
;Finalizacion del programa. Devolver condiciones para evitar un segmentation fault
	mov rax,60	;(sys_exit)
	mov rdi,0
	mov ebx,0	;exit status 0
	syscall
;===================================================================================
