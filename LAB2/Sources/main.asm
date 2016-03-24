;*******************************************************************
;*                                                                 *
;*  EELE 465													   *
;*	Date:    3/03/2016											   *
;*	Project: Lab 2, LCD Project									   *
;*	Authors: Nathan Robertus, Garrett Cornwell                     *
;*                                                                 *
;*******************************************************************

; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            

; export symbols
            XDEF _Startup, main, t, b, m
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            

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
			
keypad_write:
		
			LSL $60					; logical shift left so that the next row 
									; on keypad will be tested if key not pressed
			
			feed_watchdog
			
			; see if all the rows have been tested
			LDA #%11100000			; test $60 to see if it needs to be reinitialized
			CMP $60					; to 1110 1111
			BEQ keypad_Delay_Loop			; we will actually branch to last known LED sequence
			
			PTBDD_Upper_output		; bits 4,5,6,7 of PTBD are outputs
			
			; store the row number into $61 and clear the bottom byte.
			MOV $60, $61			; Store 1110 1111 into $61
			LDA #%11110000			; load accumulator to clear the bottom 4 bits of $61
			AND $61					; Clear bottom 4 bits
			STA $61					; Store back into $61
			
			; Write to the keypad.
			MOV $60, $64			; Store 1110 1111 into PTBD
			
			BSET 1, $64
			BCLR 0, $64				; PTBD = 1110 1110
			BCLR 2, $64				; PTBD = 1110 1010
			BCLR 3, $64				; PTBD = 1110 0010
									;   bits 7654 GCBA
									
			MOV $64, PTBD
									
			NOP						; no operation to give time before the rising clock edge
			
			BSET 3, PTBD			; Set bit three (G2A=1) for a rising edge of clock
			
			; Read from keypad.
			PTBDD_Upper_input		; Configure bits 4, 5, 6, 7 as inputs
			
			BCLR 3, PTBD			; Bring the clock back down
			BSET 0, PTBD			; Enable bus transceiver to pass data to bus
			
			MOV PTBD, $62			; Move the data from bus to $62
					
			; otherwise configure data from bus so that the column data is in the lower byte with 0's in upper byte.
			LSR $62
			LSR $62					; Logical shift right 4 times
			LSR $62					; $62 now has 0000 xxxx
			LSR $62					; where xxxx is the data from bus
			
			; combine the row (upper) and column (lower) bytes into one memory location: $63
			LDA $62					; Load accumulator with 0000 xxxx
			ORA $61					; combine the data from row (upper) and column (lower)
			STA $63					; store the data into $63
			
			; see if a button was pressed.
			LDA #%00001111				; load accumulator
			ORA $61					; Accumulator has 1110 1111
			CMP $63					; Check to see that a 0 is in column data
									; which means that a button was pressed
			
			BEQ keypad_write		; if key not pressed in row repeat for next row number
			BRA keypad_Delay_Loop
Re_read:

			; see if a button was pressed.
			LDA #%00001111			; load accumulator
			ORA $61					; Accumulator has 1110 1111
			CMP $63					; Check to see that a 0 is in column data
									; which means that a button was pressed
			BEQ keypad_done				; if key not pressed, go to keypad_done.
			
			PTBDD_Upper_input		; Configure bits 4, 5, 6, 7 as inputs
			BCLR 3, PTBD			; Bring the clock back down
			BSET 0, PTBD			; Enable bus transceiver to pass data to bus
			MOV PTBD, $6A			; Move the data from bus to $6A
			
			LSR $6A
			LSR $6A
			LSR $6A
			LSR $6A
			
			LDA $62					; load $62 into accumulator
			CMP $6A					; compare to $6A
			BNE keypad_done				; if they are not the same, go to keypad_done
			MOV $63, $70			; otherwise, update $70 with button press
			BRA keypad_done				; and go to keypad_done
keypad_done:
			RTS
keypad_Delay_Loop:
			LDA #50					; Load A with 65
			STA t					; store A into t, m, and b
			STA m
			STA b
			
		Top:
			feed_watchdog
			LDA t					
			SUB #1					; decrement A
			BEQ Re_read				; go to reread if A equals 0
			STA t					; store back into memory
			LDA #50					
			STA m					; store 65 into middle if not equal to zero and go to middle
		Middle:
			feed_watchdog
			LDA m
			SUB #1					; decrement
			STA m					; store back into m
			BEQ Top					; if equal to 0 go to top
			LDA #50
			STA b					; store 65 into b and go to bottom
		bottom: 
			feed_watchdog	
			LDA b
			SUB #1					; decrement
			STA b					; store back into b 
			BEQ Middle				; if equal to 0 branch to middle
			BRA bottom				; if not 0 branch to bottom

Delay:
	MOV b, m
	top:
			DEC t
			BEQ last
			MOV m, b
	delay_bottom:
			DEC b
			BEQ top
			BRA delay_bottom
	last:
			RTS
			
BF_check:
			feed_watchdog
			BSET 0, PTAD				; set as read from LCD
			BCLR 1, PTAD
			PTBDD_Upper_input			; data direction as input
			Clock_in					; clock data in
			MOV PTBD, $80				; move the data into address $80
			Clock_in					; clock the second byte in
			MOV PTBD, $81				; move that into $81
			LSR $81						; LSR 4x to get into bottom byte
			LSR $81
			LSR $81
			LSR $81
			
			LDA $80
			AND #%11110000
			STA $80
			LDA $81						; load $81
			ORA $80						; combine $81 and $80
			STA $80
			
			BRCLR 7, $80, bf_done
			BRSET 7, $80, BF_check
bf_done:
			LDA #$10 					; load with %10000111
			CMP $80						; checking to see if at end of line 1
			BEQ bf_new_address				; then goto new_address
			LDA #$11
			CMP $80						; checking to see if at end of line 1
			BEQ bf_new_address				; then goto new_address
			LDA #$12
			CMP $80						; checking to see if at end of line 1
			BEQ bf_new_address				; then goto new_address
			LDA #$50					; load with %11000111
			CMP $80						; checking to see if at end of line 2
			BLS bf_clear_display			; then goto clear_display
bf_done1:
			PTBDD_Upper_output			; set data direction back to output
			RTS							; return from subroutine
bf_new_address:
			PTBDD_Upper_output
			BCLR 1, PTAD				; set RS = 0
			BCLR 0, PTAD				; set R/W = 0
			MOV #%11001100, PTBD	
			NOP	
			NOP
			Clock_in
			NOP
			NOP
			MOV #%00001100, PTBD
			Clock_in					; move address to $40
			NOP
			NOP
			NOP
			JMP BF_check
bf_clear_display:
			PTBDD_Upper_output
			BCLR 1, PTAD				; set RS = 0
			BCLR 0, PTAD				; set R/W = 0
			MOV #%00001100, PTBD
			NOP
			NOP
			Clock_in
			NOP
			NOP
			MOV #%00011100, PTBD
			Clock_in					; Clear the display
			NOP
			NOP
			NOP
			JMP BF_check
			
Awrite:
			MOV #%10100000, PTBD    ; Write 1010 to the LED's 
			BSET 3, PTBD            ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70             ; Reset the button press to zero
			BSET 0, PTADD           ; Sets PTA Data Direction to an output
			BSET 1, PTADD
			BSET 1, PTAD            ; set RS = 1
			BCLR 0, PTAD            ; set R/W = 0
			MOV #%01001100, PTBD    ; Write A to the LCD display
			Clock_in
			MOV #%00011100, PTBD	
			Clock_in
			JSR BF_check            ; Jump to BF_check
			RTS                     ; Return to main

Bwrite:
			MOV #%10110000, PTBD     ; Write 1011 to the LED's 
			BSET 3, PTBD             ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70              ; Reset the button press to zero
			BSET 0, PTADD            ; Sets PTA Data Direction to an output
			BSET 1, PTADD 
			BSET 1, PTAD             ; set RS = 1
			BCLR 0, PTAD             ; set R/W = 0
			MOV #%01001100, PTBD     ; Write B to the LCD display
			Clock_in
			MOV #%00101100, PTBD	
			Clock_in
			JSR BF_check             ; Jump to BF_check
			RTS                      ; Return to main

Cwrite:
			MOV #%11000000, PTBD     ; Write 1100 to the LED's 
			BSET 3, PTBD             ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70              ; Reset the button press to zero
			BSET 0, PTADD            ; Sets PTA Data Direction to an output
			BSET 1, PTADD
			BSET 1, PTAD             ; set RS = 1
			BCLR 0, PTAD             ; set R/W = 0
			MOV #%01001100, PTBD     ; Write C to the LCD display
			Clock_in
			MOV #%00111100, PTBD	
			Clock_in
			JSR BF_check             ; Jump to BF_check
			RTS                      ; Return to main
			
Dwrite:
			MOV #%11010000, PTBD    ; Write 1101 to the LED's 
			BSET 3, PTBD            ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70             ; Reset the button press to zero
			BSET 0, PTADD           ; Sets PTA Data Direction to an output
			BSET 1, PTADD
			BSET 1, PTAD            ; set RS = 1
			BCLR 0, PTAD            ; set R/W = 0
			MOV #%01001100, PTBD    ; Write D to the LCD display
			Clock_in
			MOV #%01001100, PTBD	
			Clock_in
			JSR BF_check            ; Jump to BF_check
			RTS                     ; Return to main

Ewrite:
			MOV #%11100000, PTBD     ; Write 1110 to the LED's 
			BSET 3, PTBD             ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70              ; Reset the button press to zero
			BSET 0, PTADD            ; Sets PTA Data Direction to an output
			BSET 1, PTADD
			BSET 1, PTAD             ; set RS = 1
			BCLR 0, PTAD             ; set R/W = 0
			MOV #%01001100, PTBD     ; Write E to the LCD display
			Clock_in
			MOV #%01011100, PTBD	
			Clock_in
			JSR BF_check             ; Jump to BF_check
			RTS                      ; Return to main

Fwrite:
			MOV #%11110000, PTBD     ; Write 1111 to the LED's 
			BSET 3, PTBD             ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70              ; Reset the button press to zero
			BSET 0, PTADD            ; Sets PTA Data Direction to an output
			BSET 1, PTADD
			BSET 1, PTAD             ; set RS = 1
			BCLR 0, PTAD             ; set R/W = 0
			MOV #%01001100, PTBD     ; Write F to the LCD display
			Clock_in
			MOV #%01101100, PTBD	
			Clock_in
			JSR BF_check             ; Jump to BF_check
			RTS                      ; Return to main

zero:
			MOV #%00000000, PTBD    ; Write 0000 to the LED's 
			BSET 3, PTBD            ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70             ; Reset the button press to zero
			BSET 0, PTADD           ; Sets PTA Data Direction to an output
			BSET 1, PTADD
			BSET 1, PTAD            ; set RS = 1
			BCLR 0, PTAD            ; set R/W = 0
			MOV #%00111100, PTBD    ; Write zero to the LCD display
			Clock_in
			MOV #%00001100, PTBD	
			Clock_in
			JSR BF_check            ; Jump to BF_check
			RTS                     ; Return to main

one:
			MOV #%00010000, PTBD    ; Write 0001 to the LED's 
			BSET 3, PTBD            ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70             ; Reset the button press to zero
			BSET 0, PTADD           ; Sets PTA Data Direction to an output
			BSET 1, PTADD
			BSET 1, PTAD            ; set RS = 1
			BCLR 0, PTAD            ; set R/W = 0
			MOV #%00111100, PTBD    ; Write one to the LCD display
			Clock_in
			MOV #%00011100, PTBD	
			Clock_in
			JSR BF_check            ; Jump to BF_check
			RTS                     ; Return to main

two:
			MOV #%00100000, PTBD    ; Write 0010 to the LED's 
			BSET 3, PTBD            ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70             ; Reset the button press to zero
			BSET 0, PTADD           ; Sets PTA Data Direction to an output
			BSET 1, PTADD
			BSET 1, PTAD            ; set RS = 1
			BCLR 0, PTAD            ; set R/W = 0
			MOV #%00111100, PTBD    ; Write two to the LCD display
			Clock_in
			MOV #%00101100, PTBD	
			Clock_in
			JSR BF_check            ; Jump to BF_check
			RTS                     ; Return to main

three:
			MOV #%00110000, PTBD	; Write 0011 to the LED's 
			BSET 3, PTBD			; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70 			; Reset the button press to zero
			BSET 0, PTADD 			; Sets PTA Data Direction to an output
			BSET 1, PTADD
			BSET 1, PTAD			; set RS = 1
			BCLR 0, PTAD 			; set R/W = 0
			MOV #%00111100, PTBD    ; Write three to the LCD display
			Clock_in
			MOV #%00111100, PTBD	
			Clock_in
			JSR BF_check            ; Jump to BF_check
			RTS                     ; Return to main

four:
			MOV #%01000000, PTBD    ; Write 0100 to the LED's 
			BSET 3, PTBD            ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70             ; Reset the button press to zero
			BSET 0, PTADD           ; Sets PTA Data Direction to an output
			BSET 1, PTADD 
			BSET 1, PTAD            ; set RS = 1
			BCLR 0, PTAD            ; set R/W = 0
			MOV #%00111100, PTBD    ; Write four to the LCD display 
			Clock_in
			MOV #%01001100, PTBD	
			Clock_in
			JSR BF_check            ; Jump to BF_check
			RTS                     ; Return to main

five:
			MOV #%01010000, PTBD     ; Write 0101 to the LED's 
			BSET 3, PTBD             ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70              ; Reset the button press to zero
			BSET 0, PTADD            ; Sets PTA Data Direction to an output
			BSET 1, PTADD
			BSET 1, PTAD             ; set RS = 1
			BCLR 0, PTAD             ; set R/W = 0
			MOV #%00111100, PTBD     ; Write five to the LCD display 
			Clock_in
			MOV #%01011100, PTBD	
			Clock_in
			JSR BF_check             ; Jump to BF_check
			RTS                      ; Return to main

six:
			MOV #%01100000, PTBD       ; Write 0110 to the LED's 
			BSET 3, PTBD               ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70                ; Reset the button press to zero
			BSET 0, PTADD              ; Sets PTA Data Direction to an output
			BSET 1, PTADD
			BSET 1, PTAD               ; set RS = 1
			BCLR 0, PTAD               ; set R/W = 0
			MOV #%00111100, PTBD       ; Write six to the LCD display
			Clock_in
			MOV #%01101100, PTBD	
			Clock_in
			JSR BF_check               ; Jump to BF_check
			RTS                        ; Return to main

seven:
			MOV #%01110000, PTBD 	  ; Write 0111 to the LED's 
			BSET 3, PTBD              ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70               ; Reset the button press to zero
			BSET 0, PTADD             ; Sets PTA Data Direction to an output
			BSET 1, PTADD
			BSET 1, PTAD              ; set RS = 1
			BCLR 0, PTAD              ; set R/W = 0
			MOV #%00111100, PTBD      ; Write seven to the LCD display
			Clock_in
			MOV #%01111100, PTBD	
			Clock_in
			JSR BF_check              ; Jump to BF_check
			RTS                       ; Return to main

			
eight:
			MOV #%10000000, PTBD     ; Write 1000 to the LED's 
			BSET 3, PTBD             ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70              ; Reset the button press to zero
			BSET 0, PTADD            ; Sets PTA Data Direction to an output
			BSET 1, PTADD
			BSET 1, PTAD             ; set RS = 1
			BCLR 0, PTAD             ; set R/W = 0
			MOV #%00111100, PTBD     ; Write eight to the LCD display
			Clock_in
			MOV #%10001100, PTBD	
			Clock_in
			JSR BF_check             ; Jump to BF_check
			RTS                      ; Return to main
			
nine:
			MOV #%10010000, PTBD 	  ; Write 1001 to the LED's 
			BSET 3, PTBD              ; Set bit three (G2A=1) for a rising edge of clock
			MOV #0, $70               ; Reset the button press to zero
			BSET 0, PTADD             ; Sets PTA Data Direction to an output
			BSET 1, PTADD
			BSET 1, PTAD              ; set RS = 1
			BCLR 0, PTAD              ; set R/W = 0
			MOV #%00111100, PTBD      ; Write nine to the LCD display
			Clock_in
			MOV #%10011100, PTBD	
			Clock_in
			JSR BF_check              ; Jump to BF_check
			RTS                       ; Return to main
			


