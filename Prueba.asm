section .data

	cons_nueva_linea: db 0xa
  	tabla: db "0123456789ABCDEF",0
  	cons_hex_header: db ' 0x'
  	cons_tam_hex_header: equ $-cons_hex_header
  	cons_fabricante: db 'Fabricante: '
  	cons_tam_fabricante: equ $-cons_fabricante
	cons_stepping: db 'Stepping - Numero revision: '
	cons_tam_stepping: equ $-cons_stepping
  	cons_familia: db 'Familia: '
  	cons_modelo: db 'Modelo: '
  	cons_tam_modelo: equ $-cons_modelo
	cons_tam_familia: equ $-cons_familia
  	cons_tipo_cpu: db 'Tipo de procesador: '
	cons_tam_tipo_cpu: equ $-cons_tipo_cpu
  	cons_modelo_ext: db 'Modelo extendido: '
	cons_tam_modelo_ext: equ $-cons_modelo_ext
  	cons_tamtotal db 'Tamano total de la RAM: 0x'
  	cons_tam_ram: equ $-cons_tamtotal
	cons_ramdisponible db 'Memoria RAM disponible: 0x'
	cons_tam_disponible: equ $-cons_ramdisponible
	cons_numnucleos db 'Numero de Nucleos: '
	cons_tam_numnucleos: equ $-cons_numnucleos

section .bss

tres_byte: resb 2

section .text
global _start

_start:

;-------------------------------------------------------------------
;-------Ahora se quiere imprimir el numero de nucleos---------------
_bp0:
	mov eax,4
	mov ebx,0
	mov ecx,0
	mov edx,0
	cpuid
_bp1:
	mov ecx,eax

	mov al,0
	mov edx,ecx	;busca el primer registro de memoria total de ram
	and edx,0xFF000000		;hace un and y solo deja los bits entre [28:24]
	shr edx,26
	add edx,0x1
_prueba:
	lea ebx,[tabla]			;hace un corrimiento de 24 espacios a la derecha 
	mov al,dl			;pone en al el valor a buscar en tabla
_bp2:	
	xlat
	mov [tres_byte],ax			;pone en la direccion de salida el valor del numero ASCII respectivo a esos 4 bits
	impr_linea tres_byte,1

mov eax,1
mov ebx,0
int 0x80
