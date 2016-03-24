			INCLUDE 'derivative.inc'
            
			XDEF two

			XREF BF_check
            
MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
two:
			MOV #%00100000, PTBD    ; Write 0010 to the LED's 
			BSET 3, PTBD            ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70             ; Reset the button press to zero
			BSET 0, PTADD           ; Sets PTA Data Direction to an output
			BSET 1, PTADD
			BSET 1, PTAD            ; set RS = 1
			BCLR 0, PTAD            ; set R/W = 0
			MOV #%00111100, PTBD    ; Write two to the LCD display
			Clock_in
			MOV #%00101100, PTBD	
			Clock_in
			JSR BF_check            ; Jump to BF_check
			RTS                     ; Return to main
