
section .data
section .code
	main proc
		
		move cx, 5
		top:

			move dl, 5
			add dl, 48
			move ah, 2h
			int 21h

		loop top
	endp
	end main
