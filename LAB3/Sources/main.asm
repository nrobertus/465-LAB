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
            XDEF _Startup, main, t, b, m, n
                   
            XREF ADC_init, PTBDD_Upper_output, LCD_init, Clock_in, BF_check, Delay, keypad_write, clear_display, average_readings, one, two, three, four, five, six, seven, eight, nine   ; symbol defined by the linker for the end of the stack

MY_ZEROPAGE: SECTION  SHORT 
			n: EQU $83
			t: EQU $71
			m: EQU $72
			b: EQU $73
			XOR_Mask: EQU %00010000

MyCode:     SECTION
main:
_Startup:
			BSET 0, PTADD            ; enable port a and AtoD
			BSET 1, PTADD
			BCLR 2, PTADD
			BCLR 2, PTAD
			BCLR 3, PTAD
			BCLR 4, PTAD
			BCLR 5, PTAD
			MOV #$FF, PTBDD
			MOV #%00000001, $82
			
			LDA SOPT1				; Turn on reset
			ORA #%00000001			; turn off watchdog too
			AND #%01111111
			STA SOPT1
			
initializations:
	JSR LCD_init
	JSR ADC_init
			
display_text:
; print "Enter n:" 		
			BSET 0, PTADD
			BSET 1, PTADD
			
			BSET 1, PTAD
			BCLR 0, PTAD
			
			MOV #%01001100, PTBD
			JSR Clock_in
			MOV #%01011100, PTBD	;  'E'
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01101100, PTBD
			JSR Clock_in
			MOV #%11101100, PTBD	;  'n'
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01111100, PTBD
			JSR Clock_in
			MOV #%01001100, PTBD	;  't'
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01101100, PTBD
			JSR Clock_in
			MOV #%01011100, PTBD	;  'e'
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01111100, PTBD
			JSR Clock_in
			MOV #%00101100, PTBD	;  'r'
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00101100, PTBD
			JSR Clock_in
			MOV #%00001100, PTBD	;  ' '
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%01101100, PTBD
			JSR Clock_in
			MOV #%11101100, PTBD	;  'n'
			JSR Clock_in
			
			JSR BF_check
			
			BSET 1, PTAD
			BCLR 0, PTAD
			MOV #%00111100, PTBD
			JSR Clock_in
			MOV #%10101100, PTBD	;  ':'
			JSR Clock_in
			
			JSR BF_check
			JMP done
decode:
; toggles the heartbeat LED on/off
			JSR PTBDD_Upper_output
			LDA $82
			EOR #XOR_Mask
			STA $82
			MOV $82, PTBD
			BSET 3, PTBD
			MOV #255, t
			MOV #255, b
			JMP decode1
			
E_write:
; clears the display, print "Enter n:" 
			JSR clear_display
			JMP display_text	
decode1:			
;load pattern from memory and jump to proper subroutine.
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

one_write:
			JSR one
			JSR Delay				; wait 15 ms
			MOV #1, n
			JSR average_readings
			JMP done
two_write:
			JSR two
			JSR Delay				; wait 15 ms
			MOV #2, n
			JSR average_readings
			JMP done
three_write:
			JSR three
			JSR Delay				; wait 15 ms
			MOV #3, n
			JSR average_readings
			JMP done
four_write:
			JSR four
			JSR Delay				; wait 15 ms
			MOV #4, n
			JSR average_readings
			JMP done
five_write:
			JSR five
			JSR Delay				; wait 15 ms
			MOV #5, n
			JSR average_readings
			JMP done
six_write:
			JSR six
			JSR Delay				; wait 15 ms
			MOV #6, n
			JSR average_readings
			JMP done
seven_write:
			JSR seven
			JSR Delay				; wait 15 ms
			MOV #7, n
			JSR average_readings
			JMP done
eight_write:
			JSR eight
			JSR Delay				; wait 15 ms
			MOV #8, n
			JSR average_readings
			JMP done
nine_write:
			JSR nine
			JSR Delay				; wait 15 ms
			MOV #9, n
			JSR average_readings
			JMP done
			
done:
;move to keypad write, then decode.
			MOV #%11110111, $60
			JSR keypad_write
			JMP decode


