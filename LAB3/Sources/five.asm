			INCLUDE 'derivative.inc'
            
			XDEF five

			XREF BF_check
            
MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
five:
			MOV #%01010000, PTBD
			BSET 3, PTBD
			MOV #0, $70
			BSET 0, PTADD
			BSET 1, PTADD
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			Clock_in
			MOV #%01011100, PTBD	; Write five
			Clock_in
			JSR BF_check
			RTS
