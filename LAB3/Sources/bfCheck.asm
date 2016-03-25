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
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF t, b, PTBDD_Upper_output, PTBDD_Upper_input, Clock_in   ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition

; code section
MyCode:     SECTION
BF_check:
			BSET 0, PTAD				; set as read from LCD
			BCLR 1, PTAD
			JSR PTBDD_Upper_input			; data direction as input
			JSR Clock_in					; clock data in
			MOV PTBD, $80				; move the data into address $80
			JSR Clock_in					; clock the second byte in
			MOV PTBD, $81				; move that into $81
			LSR $81						; LSR 4x to get into bottom byte
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
			LDA #$10 					; load with %10000111
			CMP $80						; checking to see if at end of line 1
			BEQ new_address				; then goto new_address
			LDA #$11
			CMP $80						; checking to see if at end of line 1
			BEQ new_address				; then goto new_address
			LDA #$12
			CMP $80						; checking to see if at end of line 1
			BEQ new_address				; then goto new_address
			LDA #$50					; load with %11000111
			CMP $80						; checking to see if at end of line 2
			BLS clear_display			; then goto clear_display
done1:
			JSR PTBDD_Upper_output			; set data direction back to output
			RTS							; return from subroutine
new_address:
			JSR PTBDD_Upper_output
			BCLR 1, PTAD				; set RS = 0
			BCLR 0, PTAD				; set R/W = 0
			MOV #%11001100, PTBD	
			NOP	
			NOP
			JSR Clock_in
			NOP
			NOP
			MOV #%00001100, PTBD
			JSR Clock_in					; move address to $40
			NOP
			NOP
			NOP
			JMP BF_check
clear_display:
			JSR PTBDD_Upper_output
			BCLR 1, PTAD				; set RS = 0
			BCLR 0, PTAD				; set R/W = 0
			MOV #%00001100, PTBD
			NOP
			NOP
			JSR Clock_in
			NOP
			NOP
			MOV #%00011100, PTBD
			JSR Clock_in					; Clear the display
			NOP
			NOP
			NOP
			JMP BF_check
