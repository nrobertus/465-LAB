;*******************************************************************
;* This stationery serves as the framework for a user application. *
;* For a more comprehensive program that demonstrates the more     *
;* advanced functionality of this processor, please see the        *
;* demonstration applications, located in the examples             *
;* subdirectory of the "Freescale CodeWarrior for HC08" program    *
;* directory.                                                      *
;*																   *
;*			Authors: Erik Andersen, Levi Hartman				   *
;*			Project: Lab 1, Keypad LED Project					   *
;*			Date: 2/17/2015										   *
;*																   *
;*******************************************************************

; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            

; export symbols
            XDEF _Startup, main, clear_bottom, check, b, t, m, XOR_mask_C, XOR_mask_C2, XOR_mask
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF __SEG_END_SSTACK, keypad_write, pattern_a, pattern_b, pattern_c_away, pattern_c_together, pattern_d   ; symbol defined by the linker for the end of the stack


			; Address $60 is where the zero will be written to the keypad. It will LSR every time through the keypad_read_write subroutine.
			; Address $61 is the row byte in the lower byte.
			; Address $62 is the column byte in the upper byte.
			; Address $63 is the row and column bytes combined.
			; Address $64 is the data written to PTBD while writing to the keypad.
			
			; Address $67 is the upper byte of LED array for pattern B
			; Address $68 is the lower byte of LED array for pattern B
			
			; Address $70 has the same thing as $63 but it will only be updated when a button is pressed.
			; Address $70 is used in the decoding subroutine.
			; Address $80-$85 is used to store the look-up table for pattern D
			
MY_ZEROPAGE: SECTION  SHORT
			
			t: EQU $71
			m: EQU $72
			b: EQU $73
			XOR_mask: EQU $65				; Xor mask memory location
			XOR_mask_C: EQU $69				; XOR mask pattern C memory location
			XOR_mask_C2: EQU $6C			; second XOR mask pattern for C
			clear_bottom: EQU %11110000		; Bit mask used to clear the bottom 4 bits
			check: EQU %00001111			; Bit mask used to check if button was pressed
			
MyCode:     SECTION
main:
_Startup:
			;Pattern D lookup table
			LDA #%00110000
			STA $80
			LDA #%11000001
			STA $81
			LDA #%00010000
			STA $82
			LDA #%11100001
			STA $83
			LDA #%00000000
			STA $84
			LDA #%11110001
			STA $85
			LDA #%00000000
			STA $86
			LDA #%01110001
			STA $87
			LDA #%00000000
			STA $88
			LDA #%00110001
			STA $89
			LDA #%00000000
			STA $8A
			LDA #%00010001
			STA $8B
		    MOV #0, $8C
		    
			MOV #%00000000, $6B		; Pattern C
			MOV #%11111111, $66		; Pattern B
			MOV #%10000000, XOR_mask; XOR_Mask
			MOV #%00010000, XOR_mask_C ; Xor mask for pattern C
			MOV #%00001000, XOR_mask_C2 ; second xor mask for pattern C
			
			LDA SOPT1				; Enable the reset switch.
			ORA #%00000001
			STA SOPT1
			
			MOV #$FF, PTBDD			; Configure PTBD as an output
			MOV #%11100111, $70		; $70 is the pattern address, initially load it with pattern A on start-up

start:
			MOV #%11110111, $60		; Store 1111 0111 into memory for first read
			JSR keypad_write		; apparently use JSR instead of BSR...
			JMP decode
decode:

			; determine which button was pressed.
			PTBDD_Upper_output
			
			
			LDA $70					; Load the pattern from memory
			CMP #%11100111			; If it is the same pattern
			BEQ Pattern_A			; then branch to pattern A
			CMP #%11101011			; If this
			BEQ Pattern_B			; branch to pattern B
			CMP #%11101101			; if this
			BEQ Pattern_C_away		; branch to pattern C
			CMP #%10101010
			BEQ Pattern_C_together
			CMP #%11101110          ; if this 
			BEQ Pattern_D           ; branch to pattern D
			;D => 11101110
			;3 => 11010111
			;6 => 11011011
			;9 => 11011101
			;# => 11011110
			;2 => 10110111
			;5 => 10111011
			;8 => 10111101
			;0 => 10111110
			;1 => 01110111
			;4 => 01111011
			;7 => 01111101
			;* => 01111110
Pattern_A:
			JSR pattern_a
			JMP start
Pattern_B:
			
			JSR pattern_b			
			JMP start

Pattern_C_away:
			JSR pattern_c_away
			JMP start
Pattern_C_together:
			JSR pattern_c_together
			JMP start
Pattern_D:
			JSR pattern_d
			JMP start

