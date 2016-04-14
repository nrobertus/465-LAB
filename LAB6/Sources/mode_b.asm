			INCLUDE 'derivative.inc'
            
			XDEF mode_b, Tset
			
			XREF LCD_write, new_address, clear_display, keypad_write, XOR_Mask, i_temp, time_reset, read
            
MY_ZEROPAGE: SECTION  SHORT
			
			Tset: EQU $75
			
MyCode:     SECTION
mode_b:
			JSR clear_display
			JSR clear_display
			JSR clear_display

			MOV #$54, $83			; Write 'T'
			JSR LCD_write
			
			MOV #$61, $83			; Write 'a'
			JSR LCD_write
			
			MOV #$72, $83			; Write 'r'
			JSR LCD_write
			
			MOV #$67, $83			; Write 'g'
			JSR LCD_write
			
			MOV #$65, $83			; Write 'e'
			JSR LCD_write
			
			MOV #$74, $83			; Write 't'
			JSR LCD_write
			
			MOV #$20, $83			; Write ' '
			JSR LCD_write
			
			MOV #$54, $83			; Write 'T'
			JSR LCD_write
			
			MOV #$65, $83			; Write 'e'
			JSR LCD_write
			
			MOV #$6D, $83			; Write 'm'
			JSR LCD_write
			
			MOV #$70, $83			; Write 'p'
			JSR LCD_write
			
			MOV #$3F, $83			; Write '?'
			JSR LCD_write
			
			JSR new_address
			
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
			
			MOV #$31, $83			; Write '1'
			JSR LCD_write
			
			MOV #$30, $83			; Write '0'
			JSR LCD_write
			
			MOV #$2D, $83			; Write '-'
			JSR LCD_write
			
			MOV #$34, $83			; Write '4'
			JSR LCD_write
			
			MOV #$30, $83			; Write '0'
			JSR LCD_write
			
			MOV #$43, $83			; Write 'C'
			JSR LCD_write
			
			MOV #$20, $83			; Write ' '
			JSR LCD_write
			
			CLRX
			CLRH
			
			JMP done
			
read_keypad:

			; determine which button was pressed.			
			CLR PTBD
			BSET 3, PTBD
			BCLR 3, PTBD
			PTBDD_Upper_output
			LDA $82
			EOR #XOR_Mask			; Toggle Heartbeat LED
			STA $82
			MOV $82, PTBD
			BSET 3, PTBD			; Clock Heartbeat LED
			NOP
			BCLR 3, PTBD
			JMP decode
			
zero:
			MOV #$30, $83
			JSR LCD_write
			
			MOV #0, i_temp
			JSR write_temp
			JMP done
one:		
			MOV #$31, $83
			JSR LCD_write
			
			MOV #1, i_temp
			JSR write_temp
			JMP done
two:
			MOV #$32, $83
			JSR LCD_write
			
			MOV #2, i_temp
			JSR write_temp
			JMP done
three:
			MOV #$33, $83
			JSR LCD_write
			
			MOV #3, i_temp
			JSR write_temp
			JMP done
four:
			MOV #$34, $83
			JSR LCD_write
			
			MOV #4, i_temp
			JSR write_temp
			JMP done
			
decode:			
			LDA $70					; Load the pattern from memory
			CMP #%01110111
			BEQ one
			CMP #%10110111
			BEQ two
			CMP #%11010111
			BEQ three
			CMP #%01111011
			BEQ four
			CMP #%10111011
			BEQ five
			CMP #%11011011
			BEQ six
			CMP #%01111101
			BEQ seven
			CMP #%10111101
			BEQ eight
			CMP #%11011101
			BEQ nine
			CMP #%10111110
			BEQ zero
			CMP #%11011110
			BEQ next
			CMP #%01111110
			BEQ return
			JMP done
			
five:
			MOV #$35, $83
			JSR LCD_write
			
			MOV #5, i_temp
			JSR write_temp
			JMP done
six:
			MOV #$36, $83
			JSR LCD_write
			
			MOV #6, i_temp
			JSR write_temp
			JMP done
seven:
			MOV #$37, $83
			JSR LCD_write
			
			MOV #7, i_temp
			JSR write_temp
			JMP done
eight:
			MOV #$38, $83
			JSR LCD_write
			
			MOV #8, i_temp
			JSR write_temp
			JMP done
nine:
			MOV #$39, $83
			JSR LCD_write
			
			MOV #9, i_temp
			JSR write_temp
			JMP done
next:
			JSR time_reset
return:
			RTS
done:

			MOV #%11110111, $76		; return to reading from the keypad.
			JSR keypad_write
			JMP read_keypad
			
write_temp:
			
			TXA
			
			CMP #0
			BEQ first_write
			CMP #1
			BEQ second_write
			
			RTS
			
			first_write:
					
					MOV i_temp, Tset
					
					LSL Tset
					LSL Tset
					LSL Tset
					LSL Tset
					
					INCX
					RTS
					
			second_write:
					
					LDA i_temp
					ORA Tset
					STA Tset
					
					INCX
					RTS
			
