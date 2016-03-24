	INCLUDE 'derivative.inc'
            
			XDEF four

			XREF BF_check
            
MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
four:
			MOV #%01000000, PTBD
			BSET 3, PTBD
			MOV #0, $70
			BSET 0, PTADD
			BSET 1, PTADD
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			Clock_in
			MOV #%01001100, PTBD	; Write four
			Clock_in
			JSR BF_check
			RTS
