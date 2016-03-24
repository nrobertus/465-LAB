			INCLUDE 'derivative.inc'
            
			XDEF four

			XREF BF_check
            
MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
four:
			MOV #%01000000, PTBD    ; Write 0100 to the LED's 
			BSET 3, PTBD            ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70             ; Reset the button press to zero
			BSET 0, PTADD           ; Sets PTA Data Direction to an output
			BSET 1, PTADD 
			BSET 1, PTAD            ; set RS = 1
			BCLR 0, PTAD            ; set R/W = 0
			MOV #%00111100, PTBD    ; Write four to the LCD display 
			Clock_in
			MOV #%01001100, PTBD	
			Clock_in
			JSR BF_check            ; Jump to BF_check
			RTS                     ; Return to main
			
