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
            XDEF _Startup, main, t, b, m, n, char_1, char_2
                   
            XREF readPWM, new_address, actual_print, request_print, ADC_init, PTBDD_Upper_output, LCD_init, Clock_in, BF_check, Delay, keypad_write, clear_display, average_readings, zero, one, two, three, four, five, six, seven, eight, nine, display_char   ; symbol defined by the linker for the end of the stack

MY_ZEROPAGE: SECTION  SHORT 
			n: EQU $83
			t: EQU $71
			m: EQU $72
			b: EQU $73
			XOR_Mask: EQU %00010000
			char_1: EQU $74
			char_2: EQU $75

MyCode:     SECTION
main:
_Startup:
			BSET 0, PTADD            ; enable port a and AtoD
			BSET 1, PTADD
			BSET 2, PTADD
			BSET 3, PTADD
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
			
display_request:
			JSR clear_display;
			JSR request_print
			JMP done
			
display_actual:
			JSR new_address
			JSR actual_print
			JSR readPWM
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
			
decode1:			
;load pattern from memory and jump to proper subroutine.
			LDA $70				
			CMP #%01111110
			BEQ display_request
			CMP #%10111110
			BEQ zero_write
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
zero_write:
			JSR zero
			JSR Delay				; wait 15 ms
			MOV #0, n
			JMP display_actual
one_write:
			JSR one
			JSR Delay				; wait 15 ms
			MOV #1, n
			JMP display_actual
two_write:
			JSR two
			JSR Delay				; wait 15 ms
			MOV #2, n
			JMP display_actual
three_write:
			JSR three
			JSR Delay				; wait 15 ms
			MOV #3, n
			JMP display_actual
four_write:
			JSR four
			JSR Delay				; wait 15 ms
			MOV #4, n
			JMP display_actual
five_write:
			JMP display_request
			;JSR five
			;JSR Delay				; wait 15 ms
			;MOV #5, n
			;JMP display_actual
six_write:
			JMP display_request
			;JSR six
			;JSR Delay				; wait 15 ms
			;MOV #6, n
			;JMP display_actual
seven_write:
			JMP display_request
			;JSR seven
			;JSR Delay				; wait 15 ms
			;MOV #7, n
			;JMP display_actual
eight_write:
			JMP display_request
			;JSR eight
			;JSR Delay				; wait 15 ms
			;MOV #8, n
			;JMP display_actual
nine_write:
			JMP display_request
			;JSR nine
			;JSR Delay				; wait 15 ms
			;MOV #9, n
			;JMP display_actual
			
done:
;move to keypad write, then decode.
			MOV #%11110111, $60
			JSR keypad_write
			JMP decode


