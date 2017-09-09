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

;-------------------------   MACRO #3   --------------------------------	
;Macro IMPRIMIR HEXA
;----------------------------------------------------------------------	
%macro impr_hexa 1 ;recibe 1 parametro	
	mov rdx,%1
	lea ebx,[tabla]	
	mov al,dl	
	xlat	
	mov [byte_uno],ax
	impr_texto byte_uno,1
%endmacro
;-----------------------  FIN DE MACRO  --------------------------------	

;Segmento de datos
;Declaracion de variables estaticas (ubicadas en memoria)
;section .bss
section .data
	
	cons_cache: db 'Memoria Cache: ',0xa ;Texto cache
	cons_num_cache: equ $-cons_cache     ;Tamano texto cache
	cons_esp: db 0xa
	dcache: db 'D'
	dospuntos: db ': '
	tabla: db "0123456789ABCDEF",0
	
section .bss
	
	reg_copia: resb 8
	byte_uno: resb 1
	
	
;===================================================================================
;Segmento de codigo
section .text
    global _start

_start:
	
	impr_texto cons_cache, cons_num_cache ;Se imprime el texto MEmoria Cache
	mov eax,2                             ;Parametro para cache en CPUID
	cpuid 
	
_datacache:

;--------Guardar informacion-----
	
	mov [reg_copia],eax ;Los datos de eax se guardan en reg_copia
	mov r9,[reg_copia]  ;Los datos de reg_copiar se guardan en r9
	
_datacachebackup:
	
;---------Ciclo recorrer registro---
	
	mov r8,0x4 ;Es el numero de repeticiones en r8
	mov r10,1  ;Es un contador para numero de dato a consultar
	
loopcache: ;Inicio del ciclo
		
;--------Numero dato-------
	
	impr_texto dcache,1    ;Se imprime D
	impr_hexa r10          ;Se imprime numero de dato
	impr_texto dospuntos,2 ;Se imprimen :
	
;--Variables y mascaras--
	
	mov r12,r9   ;Los datos de la cache se guardan en r12
	mov r13,r9   ;Tambien se guardan en r13
	shr r12,4    ;Se mueve 4 veces a la derecha para dividir en bloques de dos bytes
	and r12,0x0F ;Mascara para r12
	and r13,0x0F ;Mascara para r13
		
;------Impresion datos------
	
	impr_hexa r12         ;Se imprime el primer byte	
	impr_hexa r13         ;Se imprime el segundo byte
	impr_texto cons_esp,1 ;Se imprime un espacio para el siguiente ciclo
	
;--Datos ciclo siguiente---
	
	add r10,1     ;Se suma 1 al contador
	shr r9,8      ;Se mueven 2 bytes a la derecha con el fin de preparar el siguiente bloque
	dec r8        ;Se resta 1 al contador de las repeticiones restantes
	jnz loopcache ;Salto al ciclo
	
;===================================================================================
;Finalizacion del programa. Devolver condiciones para evitar un segmentation fault
	mov	eax,1	;(sys_exit)
	mov	ebx,0	;exit status 0
	int	0x80	;llamar al sistema
;===================================================================================
