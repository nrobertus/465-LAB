			INCLUDE 'derivative.inc'
            
			XDEF display

			XREF BF_check, Month, Day, Year, Hour, Minutes, Seconds, Delay, t, b, n, clear_display, new_address, LCD_write
            
MY_ZEROPAGE: SECTION  SHORT

			month: DS.B 2
			day: DS.B 2
			year: DS.B 2
			hour: DS.B 2
			minutes: DS.B 2
			seconds: DS.B 2

MyCode:     SECTION
display:
			LDA Month
			STA month
			
			LSR month
			LSR month
			LSR month
			LSR month
			LDA month
			ADD #$30
			STA month
			
			LDA Month
			AND #%00001111
			ADD #$30
			STA Month
			
			LDA Day
			STA day
			
			LSR day
			LSR day
			LSR day
			LSR day
			LDA day
			ADD #$30
			STA day
			
			LDA Day
			AND #%00001111
			ADD #$30
			STA Day
			
			LDA Year
			STA year

			LSR year
			LSR year
			LSR year
			LSR year
			LDA year
			ADD #$30
			STA year
			
			LDA Year
			AND #%00001111
			ADD #$30
			STA Year
			
			LDA Hour
			STA hour
			
			LSR hour
			LSR hour
			LSR hour
			LSR hour
			LDA hour
			ADD #$30
			STA hour
			
			LDA Hour
			AND #%00001111
			ADD #$30
			STA Hour
			
			LDA Minutes
			STA minutes
			
			LSR minutes
			LSR minutes
			LSR minutes
			LSR minutes
			LDA minutes
			ADD #$30
			STA minutes
			
			LDA Minutes
			AND #%00001111
			ADD #$30
			STA Minutes
			
			LDA Seconds
			STA seconds
			
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
			
			JSR clear_display
			
			MOV #$44, $83				; 'D'
			JSR LCD_write
			
			MOV #$61, $83				; 'a'
			JSR LCD_write
			
			MOV #$74, $83				; 't'
			JSR LCD_write
			
			MOV #$65, $83				; 'e'
			JSR LCD_write
			
			MOV #$20, $83				; ' '
			JSR LCD_write
			
			MOV #$69, $83				; 'i'
			JSR LCD_write
			
			MOV #$73, $83				; 's'
			JSR LCD_write
			
			MOV #$20, $83				; ' '
			JSR LCD_write
			
			LDA month					; write month
			STA $83
			JSR LCD_write
			LDA Month
			STA $83
			JSR LCD_write
			
			MOV #$2F, $83				; '/'
			JSR LCD_write
			
			LDA day						; write day
			STA $83
			JSR LCD_write
			LDA Day
			STA $83
			JSR LCD_write
			
			MOV #$2F, $83				; '/'
			JSR LCD_write
			
			LDA year					; write year
			STA $83
			JSR LCD_write
			LDA Year
			STA $83
			JSR LCD_write
			
			JSR new_address				; next line
			
			MOV #$54, $83				; 'T'
			JSR LCD_write
			
			MOV #$69, $83				; 'i'
			JSR LCD_write
			
			MOV #$6D, $83				; 'm'
			JSR LCD_write
			
			MOV #$65, $83				; 'e'
			JSR LCD_write
			
			MOV #$20, $83				; ' '
			JSR LCD_write
			
			MOV #$69, $83				; 'i'
			JSR LCD_write
			
			MOV #$73, $83				; 's'
			JSR LCD_write
			
			MOV #$20, $83				; ' '
			JSR LCD_write
			
			LDA hour					; write hour
			STA $83
			JSR LCD_write
			LDA Hour
			STA $83
			JSR LCD_write
			
			MOV #$3A, $83				; ':'
			JSR LCD_write
			
			LDA minutes					; write minutes
			STA $83
			JSR LCD_write
			LDA Minutes
			STA $83
			JSR LCD_write
			
			MOV #$3A, $83				; ':'
			JSR LCD_write
			
			LDA seconds					; write seconds
			STA $83
			JSR LCD_write
			LDA Seconds
			STA $83
			JSR LCD_write
			
			RTS
			
