;*******************************************************************
;*                                                                 *
;*  EELE 465													   *
;*	Date:    3/05/2015											   *
;*	Project: Lab 2, LCD Project									   *
;*	Authors: Levi Hartman, Erik Andersen                           *
;*                                                                 *
;*******************************************************************

; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            

; export symbols
            XDEF _Startup, main, t, b, m
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
			XREF __SEG_END_SSTACK, BF_check, Delay, keypad_write, Awrite, Bwrite, Cwrite, Dwrite, Ewrite, Fwrite, one, two, three, four, five, six, seven, eight, nine, zero   ; symbol defined by the linker for the end of the stack

            ; Address $60 is where the zero will be written to the keypad. It will LSR every time through the keypad_read_write subroutine.
			; Address $61 is the row byte in the lower byte.
			; Address $62 is the column byte in the upper byte.
			; Address $63 is the row and column bytes combined.
			; Address $64 is the data written to PTBD while writing to the keypad.
  
  
            ; Address $70 has the same thing as $63 but it will only be updated when a button is pressed.
			; Address $70 is used in the decoding subroutine.
			
			; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition

			t: EQU $71              ; Equate memory location used for delay loop
			m: EQU $72
			b: EQU $73
			XOR_Mask: EQU %00010000 ; Xor mask memory location used too toggle the heartbeat LED

; code section
MyCode:     SECTION
main:
_Startup:
			BSET 0, PTADD           ; Enables Port A data direction as an output
			BSET 1, PTADD
			MOV #0, PTAD
			MOV #$FF, PTBDD         ; Configure PTBD as an output
			MOV #%00000001, $82
			
			LDA SOPT1				; Enable the reset switch.
			ORA #%00000001
			STA SOPT1
			
LCD_initialization:
			feed_watchdog
			MOV #30, t
			MOV #255, b
			JSR Delay				; wait for 15 ms
			
			BCLR 0, PTAD			; function set command
			BCLR 1, PTAD
			MOV #%00111100, PTBD
			Clock_in
			
			MOV #8, t
			MOV #255, b
			JSR Delay				; wait for 4.1 ms
			
			BCLR 0, PTAD			; function set command
			BCLR 1, PTAD
			MOV #%00111100, PTBD	; function set command
			Clock_in
			
			MOV #2, t
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
			
			JMP done
decode:

		    ;enables the heartbeat LED
			PTBDD_Upper_output
			LDA $82
			EOR #XOR_Mask
			STA $82
			MOV $82, PTBD
			BSET 3, PTBD
			
		    ; determine which button was pressed.
			LDA $70					; Load the button press from memory
			CMP #%11100111			; If it is the same button press
			BEQ A_write				; then branch to button A
			CMP #%11101011			; If this
			BEQ B_write				; branch to button B
			CMP #%11101101			; if this
			BEQ C_write				; branch to button C
			CMP #%11101110          ; if this
			BEQ D_write				; branch to button D
			CMP #%01111110          ; if this
			BEQ E_write        		; branch to button E
			CMP #%11011110          ; if this
			BEQ F_write				; branch to button F
			CMP #%01110111			; if this
			BEQ one_write           ; branch to button one
			CMP #%10110111			; if this
			BEQ two_write           ; branch to button two
			CMP #%11010111			; if this
			BEQ three_write         ; branch to button three
			CMP #%01111011			; if this
			BEQ four_write          ; branch to button four
			CMP #%10111011			; if this
			BEQ five_write          ; branch to button five
			CMP #%11011011			; if this
			BEQ six_write           ; branch to button six
			CMP #%01111101			; if this
			BEQ seven_write         ; branch to button seven
			CMP #%10111101			; if this
			BEQ eight_write         ; branch to button eight
			CMP #%11011101			; if this
			BEQ nine_write          ; branch to button nine
			CMP #%10111110			; if this
			BEQ zero_write          ; branch to button zero
			
			
			
			
done:
			MOV #%11110111, $60   ; Store 1111 0111 into memory for first read
			JSR keypad_write      ; apparently use JSR instead of BSR...
			JMP decode
        ;list of subroutines that jump to the appropriate subroutine
A_write:
			JSR Awrite			
			JMP done
B_write:
			JSR Bwrite			
			JMP done
C_write:
			JSR Cwrite			
			JMP done
D_write:
			JSR Dwrite			
			JMP done
E_write:
			JSR Ewrite			
			JMP done
F_write:
			JSR Fwrite			
			JMP done
one_write:
			JSR one
			JMP done
two_write:
			JSR two
			JMP done
three_write:
			JSR three
			JMP done
four_write:
			JSR four
			JMP done
five_write:
			JSR five
			JMP done
six_write:
			JSR six
			JMP done
seven_write:
			JSR seven
			JMP done
eight_write:
			JSR eight
			JMP done
nine_write:
			JSR nine
			JMP done
zero_write:
			JSR zero
			JMP done

