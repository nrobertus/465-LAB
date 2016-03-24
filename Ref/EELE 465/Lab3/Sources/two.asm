			INCLUDE 'derivative.inc'
            
			XDEF two

			XREF BF_check
            
MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
two:
			MOV #%00100000, PTBD
			BSET 3, PTBD
			MOV #0, $70
			BSET 0, PTADD
			BSET 1, PTADD
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			Clock_in
			MOV #%00101100, PTBD	; Write two
			Clock_in
			JSR BF_check
			RTS
