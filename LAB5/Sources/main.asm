;**********************************************************************
;*																      *
;* Authors: Levi Hartman, Erik Andersen							      *
;* Project: Lab 5, Real-Time Clock with I2C Serial Two-Wire Interface *
;* Date: 4/16/2015												      *
;*																      *
;*																      *
;**********************************************************************

; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            

; export symbols
            XDEF _Startup, main, t, b, m, n, Month, temp_num, Day, Year, Hour, Minutes, Seconds

			XREF PTBDD_Upper_output, BF_check, Delay, keypad_write, clear_display, new_address, write_to_time, LCD_write  ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition

			n: EQU $8D
			temp_num: EQU $8C
			Month: EQU $85
			Day: EQU $86
			Year: EQU $87
			Hour: EQU $89
			Minutes: EQU $8A
			Seconds: EQU $8B
			t: EQU $71
			m: EQU $72
			b: EQU $73
			XOR_Mask: EQU %00010000
			
; Me write code here
MyCode:     SECTION
main:
_Startup:							; literally... this happens on Startup. Nothing exciting...
			BSET 0, PTADD			; Set data direction for port A to outputs.
			BSET 1, PTADD
			BSET 2, PTADD
			BSET 3, PTADD
			BCLR 2, PTADD
			BCLR 2, PTAD			; Clear all of port A
			BCLR 3, PTAD
			BCLR 4, PTAD
			BCLR 5, PTAD
			MOV #$FF, PTBDD			; set data direction for port B
			MOV #%00000001, $82		; initial heartbeat LED.
			
			LDA SOPT1				; Enable the reset switch.
			ORA #%00000001
			AND #%01111111			; disable watchdog
			STA SOPT1			
			
			MOV #0, n
			JSR LCD_init
			

decode:

			; determine which button was pressed.
			TXA
			CMP #3
			BEQ ask_time
			
			JSR PTBDD_Upper_output
			LDA $82
			EOR #XOR_Mask			; Toggle Heartbeat LED
			STA $82
			MOV $82, PTBD
			BSET 3, PTBD			; Clock Heartbeat LED
			JMP decode1
			
zero:
			MOV #$30, $83
			JSR LCD_write
			
			MOV #0, temp_num
			JSR write_to_time
			JMP done
one:		
			MOV #$31, $83
			JSR LCD_write
			
			MOV #1, temp_num
			JSR write_to_time
			JMP done
two:
			MOV #$32, $83
			JSR LCD_write
			
			MOV #2, temp_num
			JSR write_to_time
			JMP done
three:
			MOV #$33, $83
			JSR LCD_write
			
			MOV #3, temp_num
			JSR write_to_time
			JMP done
four:
			MOV #$34, $83
			JSR LCD_write
			
			MOV #4, temp_num
			JSR write_to_time
			JMP done
			
decode1:			
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
			JMP done
			
five:
			MOV #$35, $83
			JSR LCD_write
			
			MOV #5, temp_num
			JSR write_to_time
			JMP done
six:
			MOV #$36, $83
			JSR LCD_write
			
			MOV #6, temp_num
			JSR write_to_time
			JMP done
seven:
			MOV #$37, $83
			JSR LCD_write
			
			MOV #7, temp_num
			JSR write_to_time
			JMP done
eight:
			MOV #$38, $83
			JSR LCD_write
			
			MOV #8, temp_num
			JSR write_to_time
			JMP done
nine:
			MOV #$39, $83
			JSR LCD_write
			
			MOV #9, temp_num
			JSR write_to_time
			JMP done

done:
			MOV #%11110111, $60		; return to reading from the keypad.
			JSR keypad_write
			JMP decode	
