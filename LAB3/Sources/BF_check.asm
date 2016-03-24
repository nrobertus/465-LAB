INCLUDE 'derivative.inc'
            
XDEF BF_check, clear_display, new_address
XREF t, b
			
MyCode:     SECTION
BF_check:
			feed_watchdog
			BSET 0, PTAD				; set as read from LCD
			BCLR 1, PTAD
			PTBDD_Upper_input			; data direction as input
			Clock_in					; clock data in
			MOV PTBD, $80				; move the data into address $80
			Clock_in					; clock the second byte in
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
			PTBDD_Upper_output			; set data direction back to output
			RTS							; return from subroutine
new_address:
			PTBDD_Upper_output
			BCLR 1, PTAD				; set RS = 0
			BCLR 0, PTAD				; set R/W = 0
			MOV #%11001100, PTBD	
			NOP	
			NOP
			Clock_in
			NOP
			NOP
			MOV #%00001100, PTBD
			Clock_in					; move address to $40
			NOP
			NOP
			NOP
			JMP BF_check
clear_display:
			PTBDD_Upper_output
			BCLR 1, PTAD				; set RS = 0
			BCLR 0, PTAD				; set R/W = 0
			MOV #%00001100, PTBD
			NOP
			NOP
			Clock_in
			NOP
			NOP
			MOV #%00011100, PTBD
			Clock_in					; Clear the display
			NOP
			NOP
			NOP
			JMP BF_check
