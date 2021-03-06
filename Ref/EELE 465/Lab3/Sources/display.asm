            INCLUDE 'derivative.inc'
            
            XDEF display   
            
			XREF n, clear_display, BF_check, new_address, DAA_decode   ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition
MyCode:     SECTION
display:
; clear the LCD display and jump to the second line of the LCD display.
			feed_watchdog
			MOV $86, $88
			JSR clear_display
			JSR new_address
			
			BSET 0, PTADD
			BSET 1, PTADD
			BSET 1, PTAD
			BCLR 0, PTAD
; Writes "T,C:" onto the LCD display.				
			MOV #%01011100, PTBD
			Clock_in
			MOV #%01001100, PTBD	; Write 'T'
			Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00101100, PTBD
			Clock_in
			MOV #%11001100, PTBD	; Write ','
			Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01001100, PTBD
			Clock_in
			MOV #%00111100, PTBD	; Write 'C'
			Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			Clock_in
			MOV #%10101100, PTBD	; Write ':'
			Clock_in
			
			JSR BF_check
			
celsius_display:
; convert the hex value of temperature into BCD and branch to DAA_decode			
			LDA $86
			CLRH
			LDX #10
			DIV
			STHX $85
			STA $86
			JSR DAA_decode
			MOV $85, $86
			JSR DAA_decode
; Write ' ' to the LCD display.			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00101100, PTBD
			Clock_in
			MOV #%00001100, PTBD	; Write ' '
			Clock_in
			JSR BF_check

kelvin_display:
; Writes "T,K:" onto the LCD display.	
			feed_watchdog
			PTBDD_Upper_output
			BCLR 1, PTAD				; set RS = 0
			BCLR 0, PTAD				; set R/W = 0
			
			BSET 0, PTADD
			BSET 1, PTADD
			BSET 1, PTAD
			BCLR 0, PTAD
			
			MOV #%01011100, PTBD
			Clock_in
			MOV #%01001100, PTBD	; Write 'T'
			Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00101100, PTBD
			Clock_in
			MOV #%11001100, PTBD	; Write ','
			Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01001100, PTBD
			Clock_in
			MOV #%10111100, PTBD	; Write 'K'
			Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			Clock_in
			MOV #%10101100, PTBD	; Write ':'
			Clock_in
			
			JSR BF_check
; checks to see if the the conversion to kelvin causes on over flow if it does branch to write_3 else branch to to write_2.			
			LDA #73
			ADD $88
			STA $88
			LDA #100
			CMP $88
			BLS write_3
			BRA write_2
			
write_3:
; Writes '3' to the LCD display
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			Clock_in
			MOV #%00111100, PTBD	; Write '3'
			Clock_in
			JSR BF_check
; convert the hex value of temperature into BCD and branch to DAA_decode				
			LDA $88
			SUB #100
			CLRH
			LDX #10
			DIV
			STHX $85
			STA $86
			JSR DAA_decode
			MOV $85, $86
			JSR DAA_decode
; Write ' ' to the LCD display.				
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00101100, PTBD
			Clock_in
			MOV #%00001100, PTBD	; Write ' '
			Clock_in
			JSR BF_check
			
			RTS
write_2:
; Writes '2' to the LCD display
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			Clock_in
			MOV #%00101100, PTBD	; Write '2'
			Clock_in
; convert the hex value of temperature into BCD and branch to DAA_decode			
			JSR BF_check
			LDA $88
			CLRH
			LDX #10
			DIV
			STHX $85
			STA $86
			JSR DAA_decode
			MOV $85, $86
			JSR DAA_decode
; Write ' ' to the LCD display.					
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00101100, PTBD
			Clock_in
			MOV #%00001100, PTBD	; Write ' '
			Clock_in
			JSR BF_check
			
			RTS
