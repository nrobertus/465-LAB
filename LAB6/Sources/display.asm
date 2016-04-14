			INCLUDE 'derivative.inc'
            
			XDEF display

			XREF BF_check, clear_display, new_address, LCD_write, Seconds, Delay, t, b
            
MY_ZEROPAGE: SECTION  SHORT
			
			seconds: EQU $84
			temp: EQU $85
			tempread: EQU $91
			Temp: EQU $86
			
MyCode:     SECTION
display:

			LDA Seconds
			ADD $95
			DAA
			
			STA Seconds
			STA seconds
			STA $94
			
			CMP #$00
			BEQ one_hundred
			JMP rest
			
one_hundred:

			LDA $96
			ADD #1
			DAA
			AND #%00001111
			STA $96
			
			ADD #$30
			STA $97
			
			MOV #0, t				; 4 us delay
			MOV #0, b
			JSR Delay
			
			MOV #0, t				; 4 us delay
			MOV #0, b
			JSR Delay
			
			MOV #200, t				; 4 us delay
			MOV #200, b
			JSR Delay
rest:
			
			LSR seconds
			LSR seconds
			LSR seconds
			LSR seconds
			LDA seconds
			ADD #$30
			STA seconds
			
			LDA Seconds
			AND #%00001111
			ADD #$30
			STA Seconds
			
			LDA $75
			STA temp
			STA Temp
			
			LSR temp
			LSR temp
			LSR temp
			LSR temp
			LDA temp
			ADD #$30
			STA temp
			
			LDA Temp
			AND #%00001111
			ADD #$30
			STA Temp
			
			CLRH
			CLRX
			LDX #10
			
			LDA $92
			DIV
			STHX $90
			STA tempread
			
			LDA tempread
			ADD #$30
			STA tempread
			
			LDA $90
			ADD #$30
			STA $90

			JSR clear_display			; clear display
			
			MOV #$54, $83				; 'T'
			JSR LCD_write
			
			MOV #$45, $83				; 'E'
			JSR LCD_write
			
			MOV #$43, $83				; 'C'
			JSR LCD_write
			
			MOV #$20, $83				; ' '
			JSR LCD_write
			
			MOV #$73, $83				; 's'
			JSR LCD_write
			
			MOV #$74, $83				; 't'
			JSR LCD_write
			
			MOV #$61, $83				; 'a'
			JSR LCD_write
			
			MOV #$74, $83				; 't'
			JSR LCD_write
			
			MOV #$65, $83				; 'e'
			JSR LCD_write
			
			MOV #$3A, $83				; ':'
			JSR LCD_write
			
			BRSET 4, $93, hot			; if heating, go to heat
			BRSET 5, $93, cold			; if cooling, to to cool
			BRA hold
hot:
			MOV #$48, $83				; 'H'
			JSR LCD_write
			
			MOV #$65, $83				; 'e'
			JSR LCD_write
			
			MOV #$61, $83				; 'a'
			JSR LCD_write
			
			MOV #$74, $83				; 't'
			JSR LCD_write
			
			JMP next
cold:
			MOV #$43, $83				; 'C'
			JSR LCD_write
			
			MOV #$6F, $83				; 'o'
			JSR LCD_write
			
			MOV #$6F, $83				; 'o'
			JSR LCD_write
			
			MOV #$6C, $83				; 'l'
			JSR LCD_write
			
			JMP next
hold:
			MOV #$48, $83				; 'H'
			JSR LCD_write
			
			MOV #$6F, $83				; 'o'
			JSR LCD_write
			
			MOV #$6C, $83				; 'l'
			JSR LCD_write
			
			MOV #$64, $83				; 'd'
			JSR LCD_write
			
			JMP next
next:
			MOV temp, $83				; write top digit
			JSR LCD_write
			
			MOV Temp, $83				; write bottom digit
			JSR LCD_write
			
			JSR new_address				; go to bottom line
			
			MOV #$54, $83				; 'T'
			JSR LCD_write
			
			MOV #$39, $83				; '9'
			JSR LCD_write
			
			MOV #$32, $83				; '2'
			JSR LCD_write
			
			MOV #$3A, $83				; ':'
			JSR LCD_write
			
			MOV tempread, $83			; write top digit
			JSR LCD_write
			
			MOV $90, $83				; write bottom digit
			JSR LCD_write
			
			MOV #$43, $83				; 'C'
			JSR LCD_write
			
			MOV #$40, $83				; '@'
			JSR LCD_write
			
			MOV #$54, $83				; 'T'
			JSR LCD_write
			
			MOV #$3D, $83				; '='
			JSR LCD_write
			
			MOV $97, $83				; write one-hundred's place
			JSR LCD_write
			
			MOV seconds, $83			; write top digit
			JSR LCD_write
			
			MOV Seconds, $83			; write bottom digit
			JSR LCD_write
			
			MOV #$73, $83				; 's'
			JSR LCD_write
			
			RTS
