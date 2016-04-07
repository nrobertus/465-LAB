			INCLUDE 'derivative.inc'
            
			XDEF ask_date, ask_time, done

			XREF LCD_write, new_address, keypad_write, decode
            
MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
ask_date:			
			MOV #$45, $83			; Write 'E'
			JSR LCD_write
			
			MOV #$6E, $83			; Write 'n'
			JSR LCD_write
			
			MOV #$74, $83			; Write 't'
			JSR LCD_write
			
			MOV #$65, $83			; Write 'e'
			JSR LCD_write
			
			MOV #$72, $83			; Write 'r'
			JSR LCD_write
			
			MOV #$20, $83			; Write ' '
			JSR LCD_write
			
			MOV #$4D, $83			; Write 'M'
			JSR LCD_write
			
			MOV #$4D, $83			; Write 'M'
			JSR LCD_write
			
			MOV #$2F, $83			; Write '/'
			JSR LCD_write
			
			MOV #$44, $83			; Write 'D'
			JSR LCD_write
			
			MOV #$44, $83			; Write 'D'
			JSR LCD_write
			
			MOV #$2F, $83			; Write '/'
			JSR LCD_write
			
			MOV #$59, $83			; Write 'Y'
			JSR LCD_write
			
			MOV #$59, $83			; Write 'Y'
			JSR LCD_write
			
			MOV #$3A, $83			; Write ':'
			JSR LCD_write
			
			JSR new_address
			CLRX
			JMP done
ask_time:
			JSR clear_display
			MOV #$45, $83			; Write 'E'
			JSR LCD_write
			
			MOV #$6E, $83			; Write 'n'
			JSR LCD_write
			
			MOV #$74, $83			; Write 't'
			JSR LCD_write
			
			MOV #$65, $83			; Write 'e'
			JSR LCD_write
			
			MOV #$72, $83			; Write 'r'
			JSR LCD_write
			
			MOV #$20, $83			; Write ' '
			JSR LCD_write
			
			MOV #$68, $83			; Write 'h'
			JSR LCD_write
			
			MOV #$68, $83			; Write 'h'
			JSR LCD_write
			
			MOV #$2F, $83			; Write '/'
			JSR LCD_write
			
			MOV #$6D, $83			; Write 'm'
			JSR LCD_write
			
			MOV #$6D, $83			; Write 'm'
			JSR LCD_write
			
			MOV #$2F, $83			; Write '/'
			JSR LCD_write
			
			MOV #$73, $83			; Write 's'
			JSR LCD_write
			
			MOV #$73, $83			; Write 's'
			JSR LCD_write
			
			MOV #$3A, $83			; Write ':'
			JSR LCD_write
			
			JSR new_address
			INCX
			JMP done
			
done:
			MOV #%11110111, $60		; return to reading from the keypad.
			JSR keypad_write
			JMP decode	