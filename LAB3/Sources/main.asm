; Include derivative-specific definitions
INCLUDE 'derivative.inc'

; export symbols
XDEF _Startup, main, t, b, m, n

; imports
XREF __SEG_END_SSTACK, BF_check, Delay, keypad_write, clear_display, average_readings, one, two, three, four, five, six, seven, eight, nine   ; symbol defined by the linker for the end of the stack

; variable/data section
MY_ZEROPAGE: SECTION  SHORT
; equates used for the delay subroutine and storing how many times a temperature sensor is read from.
			n: EQU $83
			t: EQU $71
			m: EQU $72
			b: EQU $73
			XOR_Mask: EQU %00010000

; code section
MyCode:     SECTION
main:
_Startup:
			BSET 0, PTADD            ; Enables Port A data direction as an output and the Port A bits used for the A to D converter
			BSET 1, PTADD
			BCLR 2, PTADD
			BCLR 2, PTAD
			BCLR 3, PTAD
			BCLR 4, PTAD
			BCLR 5, PTAD
			MOV #$FF, PTBDD
			MOV #%00000001, $82
			
			LDA SOPT1				; Reset on, watchdog off
			ORA #%1000001
			STA SOPT1
			
LCD_initialization:
			MOV #40, t
			MOV #255, b
			JSR Delay				; wait for 15 ms
			
			BCLR 0, PTAD			; function set command
			BCLR 1, PTAD
			MOV #%00111100, PTBD
			Clock_in
			
			MOV #20, t
			MOV #255, b
			JSR Delay				; wait for 4.1 ms
			
			BCLR 0, PTAD			; function set command
			BCLR 1, PTAD
			MOV #%00111100, PTBD	; function set command
			Clock_in
			
			MOV #10, t
			MOV #40, b
			JSR Delay				; wait for 100 us
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00111100, PTBD	; function set command
			Clock_in
			
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00101100, PTBD	; function set
			Clock_in
			
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00101100, PTBD	; function set
			Clock_in
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%10101100, PTBD	; set N and F here
			Clock_in
				
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00001100, PTBD
			Clock_in
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%10001100, PTBD	; Display off command
			Clock_in
			
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00001100, PTBD
			Clock_in
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00011100, PTBD	; Clear Display command
			Clock_in
			
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00001100, PTBD
			Clock_in
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%01101100, PTBD	; Entry Mode Set
			Clock_in
			
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00001100, PTBD
			Clock_in
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%11111100, PTBD	; Display On
			Clock_in
			
			JSR BF_check
			
ADC_initialization:
; initializes the analog to digital converter to use 8-bit mode
			MOV #%00000000, ADCCFG
			
			BCLR 6, ADCSC2
			BCLR 5, ADCSC2
			BCLR 4, ADCSC2
			
			BCLR 6, ADCSC1
			BCLR 5, ADCSC1
			BSET 4, ADCSC1
			BSET 3, ADCSC1
			BCLR 2, ADCSC1
			BSET 1, ADCSC1
			BCLR 0, ADCSC1
			
display_text:
; Writes "Enter n:" onto the LCD display.			
			BSET 0, PTADD
			BSET 1, PTADD
			
			BSET 1, PTAD
			BCLR 0, PTAD
			
			MOV #%01001100, PTBD
			Clock_in
			MOV #%01011100, PTBD	; Write 'E'
			Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01101100, PTBD
			Clock_in
			MOV #%11101100, PTBD	; Write 'n'
			Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01111100, PTBD
			Clock_in
			MOV #%01001100, PTBD	; Write 't'
			Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01101100, PTBD
			Clock_in
			MOV #%01011100, PTBD	; Write 'e'
			Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01111100, PTBD
			Clock_in
			MOV #%00101100, PTBD	; Write 'r'
			Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00101100, PTBD
			Clock_in
			MOV #%00001100, PTBD	; Write ' '
			Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01101100, PTBD
			Clock_in
			MOV #%11101100, PTBD	; Write 'n'
			Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			Clock_in
			MOV #%10101100, PTBD	; Write ':'
			Clock_in
			
			JSR BF_check
			JMP done
decode:
; toggles the heartbeat LED on/off
			PTBDD_Upper_output
			LDA $82
			EOR #XOR_Mask
			STA $82
			MOV $82, PTBD
			BSET 3, PTBD
			MOV #255, t
			MOV #255, b
			JMP decode1
			
E_write:
; clears the display and writes "Enter n:" onto the LCD display.
			JSR clear_display
			JMP display_text	
decode1:			
; load the pattern from memory and based on the pattern jump to one_write through nine_write and E_write.			
			LDA $70				
			CMP #%01111110
			BEQ E_write
			CMP #%01110111
			BEQ one_write
			CMP #%10110111
			BEQ two_write
			CMP #%11010111
			BEQ three_write
			CMP #%01111011
			BEQ four_write
			CMP #%10111011
			BEQ five_write
			CMP #%11011011
			BEQ six_write
			CMP #%01111101
			BEQ seven_write
			CMP #%10111101
			BEQ eight_write
			CMP #%11011101
			BEQ nine_write
			JMP done

; the following nine subroutines display a number onto the display, wait for 15ms, store the correct number of readings into memory, jump to average readings subroutine and jump to done subroutine.  			
one_write:
			JSR one
			JSR Delay				; wait for 15 ms
			MOV #1, n
			JSR average_readings
			JMP done
two_write:
			JSR two
			JSR Delay				; wait for 15 ms
			MOV #2, n
			JSR average_readings
			JMP done
three_write:
			JSR three
			JSR Delay				; wait for 15 ms
			MOV #3, n
			JSR average_readings
			JMP done
four_write:
			JSR four
			JSR Delay				; wait for 15 ms
			MOV #4, n
			JSR average_readings
			JMP done
five_write:
			JSR five
			JSR Delay				; wait for 15 ms
			MOV #5, n
			JSR average_readings
			JMP done
six_write:
			JSR six
			JSR Delay				; wait for 15 ms
			MOV #6, n
			JSR average_readings
			JMP done
seven_write:
			JSR seven
			JSR Delay				; wait for 15 ms
			MOV #7, n
			JSR average_readings
			JMP done
eight_write:
			JSR eight
			JSR Delay				; wait for 15 ms
			MOV #8, n
			JSR average_readings
			JMP done
nine_write:
			JSR nine
			JSR Delay				; wait for 15 ms
			MOV #9, n
			JSR average_readings
			JMP done
			
done:
; move the first buttone of the kepad to be scanned into address $60 then jump to keypad_write and jump to decode which toggles the heartbeat LED. 
			MOV #%11110111, $60
			JSR keypad_write
			JMP decode	
			
