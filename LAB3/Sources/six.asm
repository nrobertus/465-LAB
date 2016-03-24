			INCLUDE 'derivative.inc'
            
			XDEF six

			XREF BF_check
            
MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
six:
			MOV #%01100000, PTBD
			BSET 3, PTBD
			MOV #0, $70
			BSET 0, PTADD
			BSET 1, PTADD
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			Clock_in
			MOV #%01101100, PTBD	; Write six
			Clock_in
			JSR BF_check
			RTS
