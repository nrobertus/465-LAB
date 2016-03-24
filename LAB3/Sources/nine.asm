			INCLUDE 'derivative.inc'
            
			XDEF nine

			XREF BF_check
            
MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
nine:
			MOV #%10010000, PTBD
			BSET 3, PTBD
			MOV #0, $70
			BSET 0, PTADD
			BSET 1, PTADD
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			Clock_in
			MOV #%10011100, PTBD	; Write nine
			Clock_in
			JSR BF_check
			RTS
