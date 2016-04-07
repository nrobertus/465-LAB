			INCLUDE 'derivative.inc'
            
			XDEF LCD_write

			XREF BF_check, clock
            
MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
LCD_write:
			BSET 0, PTADD			; set PTADD[0,1] as output.
			BSET 1, PTADD
			BSET 1, PTAD			; RS = 1
			BCLR 0, PTAD			; R/W = 0 which means input.
			
			MOV $83, $7F
			
			LSL $7F
			LSL $7F
			LSL $7F
			LSL $7F
			
			LDA $83
			AND #11110000
			STA $83
			
			BSET 3, $83
			BSET 2, $83
			
			BSET 3, $7F
			BSET 2, $7F
			
			MOV $83, PTBD
			JSR clock
			MOV $7F, PTBD
			JSR clock
			
			JSR BF_check
			
			CLR $70
			
			RTS
