;*******************************************************************
;* This stationery serves as the framework for a user application. *
;* For a more comprehensive program that demonstrates the more     *
;* advanced functionality of this processor, please see the        *
;* demonstration applications, located in the examples             *
;* subdirectory of the "Freescale CodeWarrior for HC08" program    *
;* directory.                                                      *
;*******************************************************************

; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            

; export symbols
            XDEF display
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF n, clear_display, BF_check, new_address, DAA_decode, PTBDD_Upper_output, Clock_in   ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition

; code section
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
			JSR Clock_in
			MOV #%01001100, PTBD	; Write 'T'
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00101100, PTBD
			JSR Clock_in
			MOV #%11001100, PTBD	; Write ','
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01001100, PTBD
			JSR Clock_in
			MOV #%00111100, PTBD	; Write 'C'
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			JSR Clock_in
			MOV #%10101100, PTBD	; Write ':'
			JSR Clock_in
			
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
			JSR Clock_in
			MOV #%00001100, PTBD	; Write ' '
			JSR Clock_in
			JSR BF_check

kelvin_display:
; Writes "T,K:" onto the LCD display.	
			feed_watchdog
			JSR PTBDD_Upper_output
			BCLR 1, PTAD				; set RS = 0
			BCLR 0, PTAD				; set R/W = 0
			
			BSET 0, PTADD
			BSET 1, PTADD
			BSET 1, PTAD
			BCLR 0, PTAD
			
			MOV #%01011100, PTBD
			JSR Clock_in
			MOV #%01001100, PTBD	; Write 'T'
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00101100, PTBD
			JSR Clock_in
			MOV #%11001100, PTBD	; Write ','
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01001100, PTBD
			JSR Clock_in
			MOV #%10111100, PTBD	; Write 'K'
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			JSR Clock_in
			MOV #%10101100, PTBD	; Write ':'
			JSR Clock_in
			
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
			JSR Clock_in
			MOV #%00111100, PTBD	; Write '3'
			JSR Clock_in
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
			JSR Clock_in
			MOV #%00001100, PTBD	; Write ' '
			JSR Clock_in
			JSR BF_check
			
			RTS
write_2:
; Writes '2' to the LCD display
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			JSR Clock_in
			MOV #%00101100, PTBD	; Write '2'
			JSR Clock_in
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
			JSR Clock_in
			MOV #%00001100, PTBD	; Write ' '
			JSR Clock_in
			JSR BF_check
			
			RTS
