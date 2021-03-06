
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
     
            XREF char_1, char_2, n, clear_display, BF_check, new_address, DAA_decode, PTBDD_Upper_output, Clock_in, display_char   ; symbol defined by the linker for the end of the stack

MY_ZEROPAGE: SECTION  SHORT 

MyCode:     SECTION
display:
; clear LCD and move to the next line of display
			MOV $86, $88
			JSR clear_display
			JSR new_address
			
			BSET 2, PTADD
			BSET 3, PTADD
				
			MOV #%01011100, char_1
			MOV #%01001100, char_2	;  'T'
			JSR display_char

			MOV #%00101100, char_1
			MOV #%11001100, char_2	;  ','
			JSR display_char

			MOV #%01001100, char_1
			MOV #%00111100, char_2	;  'C'
			JSR display_char

			MOV #%00111100, char_1
			MOV #%10101100, char_2	;  ':'
			JSR display_char
			
celsius_display:
; convert hex and decode		
			LDA $86
			CLRH
			LDX #10
			DIV
			STHX $85
			STA $86
			JSR DAA_decode
			MOV $85, $86
			JSR DAA_decode
;print a space		
			BSET 3, PTAD
			BCLR 2, PTAD
			MOV #%00101100, PTBD
			JSR Clock_in
			MOV #%00001100, PTBD	;  ' '
			JSR Clock_in
			JSR BF_check

kelvin_display:
; print "T,K:" 	
			JSR PTBDD_Upper_output
			BCLR 3, PTAD				; RS <= 0
			BCLR 2, PTAD				; R/W <= 0
			
			BSET 2, PTADD
			BSET 3, PTADD
			
			MOV #%01011100, char_1
			MOV #%01001100, char_2	; 'T'
			JSR display_char

			MOV #%00101100, char_1
			MOV #%11001100, char_2	; ','
			JSR display_char

			MOV #%01001100, char_1
			MOV #%10111100, char_2	; 'K'
			JSR display_char

			MOV #%00111100, char_1
			MOV #%10101100, char_2	; ':'
			JSR display_char

;check overflow, to write 2 or 3		
			LDA #73
			ADD $88
			STA $88
			LDA #100
			CMP $88
			BLS write_3
			BRA write_2
			
write_3:
; print '3' 
			MOV #%00111100, char_1
			MOV #%00111100, char_2	; '3'
			JSR display_char
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
; Print ' '			
			MOV #%00101100, char_1
			MOV #%00001100, char_2	;  ' '
			JSR display_char
	
			RTS
write_2:
; Print '2' 
			MOV #%00111100, char_1
			MOV #%00101100, char_2	;  '2'
			JSR display_char
;convert hex and decode			
			LDA $88
			CLRH
			LDX #10
			DIV
			STHX $85
			STA $86
			JSR DAA_decode
			MOV $85, $86
			JSR DAA_decode
; print ' ' 			
			MOV #%00101100, char_1
			MOV #%00001100, char_2	;  ' '
			JSR display_char
			
			RTS
