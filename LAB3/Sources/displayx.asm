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
            XDEF displayx
            
            
            XREF n, clear_display, BF_check, new_address, DAA_decode, PTBDD_Upper_output, Clock_in   ; symbol defined by the linker for the end of the stack


MY_ZEROPAGE: SECTION  SHORT         

MyCode:     SECTION
displayx:
			MOV $85, $88
			BSET 0, PTADD
			BSET 1, PTADD
			
			BCLR 0, PTAD
			BCLR 1, PTAD
			
			MOV #%00001100, PTBD
			JSR Clock_in
			MOV #%00111100, PTBD	;return 
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
; print "T,C:" 		
			MOV #%01011100, PTBD
			JSR Clock_in
			MOV #%01001100, PTBD	; 'T'
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00101100, PTBD
			JSR Clock_in
			MOV #%11001100, PTBD	;  ','
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01001100, PTBD
			JSR Clock_in
			MOV #%00111100, PTBD	;  'C'
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			JSR Clock_in
			MOV #%10101100, PTBD	;  ':'
			JSR Clock_in
			
			JSR BF_check
			
celsius_display:
;convert hex, return		
			LDA $85
			CLRH
			LDX #10
			DIV
			STHX $85
			STA $86
			JSR DAA_decode
			MOV $85, $86
			JSR DAA_decode
; print ' '			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00101100, PTBD
			JSR Clock_in
			MOV #%00001100, PTBD	;  ' '
			JSR Clock_in
			JSR BF_check

kelvin_display:
; Print "T,K:" 
			feed_watchdog
			JSR PTBDD_Upper_output
			BCLR 1, PTAD				; RS <= 0
			BCLR 0, PTAD				; R/W <= 0
			
			BSET 0, PTADD
			BSET 1, PTADD
			BSET 1, PTAD
			BCLR 0, PTAD
			
			MOV #%01011100, PTBD
			JSR Clock_in
			MOV #%01001100, PTBD	;  'T'
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00101100, PTBD
			JSR Clock_in
			MOV #%11001100, PTBD	;  ','
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01001100, PTBD
			JSR Clock_in
			MOV #%10111100, PTBD	;  'K'
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			JSR Clock_in
			MOV #%10101100, PTBD	;  ':'
			JSR Clock_in
			
			JSR BF_check
;check for 2 or 3		
			LDA #73
			ADD $88
			STA $88
			LDA #100
			CMP $88
			BLS write_3
			BRA write_2
			
write_3:
; Print '3'
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			JSR Clock_in
			MOV #%00111100, PTBD	;  '3'
			JSR Clock_in
			JSR BF_check
;Convert hex and decode			
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
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00101100, PTBD
			JSR Clock_in
			MOV #%00001100, PTBD	;  ' '
			JSR Clock_in
			JSR BF_check
			
			RTS
write_2:
; Print '2'
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			JSR Clock_in
			MOV #%00101100, PTBD	;  '2'
			JSR Clock_in
;conver hex and decode		
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
; Print ' ' 		
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00101100, PTBD
			JSR Clock_in
			MOV #%00001100, PTBD	;  ' '
			JSR Clock_in
			JSR BF_check
			
			RTS
