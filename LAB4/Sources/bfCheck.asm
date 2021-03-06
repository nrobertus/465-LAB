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
            XDEF BF_check, clear_display, new_address
        
            XREF t, b, PTBDD_Upper_output, PTBDD_Upper_input, Clock_in   

MY_ZEROPAGE: SECTION  SHORT         

MyCode:     SECTION
BF_check:
			BSET 2, PTAD				; set read 
			BCLR 3, PTAD
			JSR PTBDD_Upper_input			; input direction
			JSR Clock_in
			MOV PTBD, $80				; move data to $80
			JSR Clock_in					
			MOV PTBD, $81				; move data into $81
			LSR $81						
			LSR $81
			LSR $81
			LSR $81
			
			LDA $80
			AND #%11110000
			STA $80
			LDA $81						; load $81
			ORA $80						; combine $81 and $80
			STA $80
			
			BRCLR 7, $80, done
			BRSET 7, $80, BF_check
done:
			LDA #$10 					; load %10000111
			CMP $80						; checking to see if we have hit the end of line 1
			BEQ new_address				
			LDA #$11
			CMP $80						; checking to see if we have hit the end of line 1
			BEQ new_address				
			LDA #$12
			CMP $80						; checking to see if we have hit the end of line 1
			BEQ new_address				
			LDA #$50					; load %11000111
			CMP $80						; checking to see if we have hit the end of line 2
			BLS clear_display			
done1:
			JSR PTBDD_Upper_output			; set data direction as output
			RTS							; return
new_address:
			JSR PTBDD_Upper_output
			BCLR 3, PTAD				; RS <= 0
			BCLR 2, PTAD				; R/W <= 0
			MOV #%11001100, PTBD	
			NOP	
			NOP
			JSR Clock_in
			NOP
			NOP
			MOV #%00001100, PTBD
			JSR Clock_in					;  $40 <= address
			NOP
			NOP
			NOP
			JMP BF_check
clear_display:
			JSR PTBDD_Upper_output
			BCLR 3, PTAD				; RS <= 0
			BCLR 2, PTAD				; R/W <= 0
			MOV #%00001100, PTBD
			NOP
			NOP
			JSR Clock_in
			NOP
			NOP
			MOV #%00011100, PTBD
			JSR Clock_in					; Clear display
			NOP
			NOP
			NOP
			JMP BF_check
