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
            XDEF keypad_write
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF b, t, m, PTBDD_Upper_output, PTBDD_Upper_input   ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition

; code section
MyCode:     SECTION
keypad_write:
		
			LSL $60					; Left shift to test next row
			
			;check to see if all the rows have been tested
			LDA #%11100000			; Check to see if renitialized
			CMP $60					; to 1110 1111
			BEQ Delay_Loop			; Branch to the delay loop (and then last known pattern)
			
			JSR PTBDD_Upper_output		; Set bits 4,5,6,7 of PTBD to out
			
			MOV $60, $61			; Store 1110 1111 to $61
			LDA #%11110000			; now we load the accumulator to clear the bottom 4 bits of $61
			AND $61					; ^ said bit clearing
			STA $61					; And put it back in $61 now. 
			
			MOV $60, $64			; We store 1110 1111 into PTBD
			
			BSET 1, $64
			BCLR 0, $64				; PTBD <= 1110 1110
			BCLR 2, $64				; PTBD <= 1110 1010
			BCLR 3, $64				; PTBD <= 1110 0010
									
			MOV $64, PTBD
									
			NOP						; Wait for the clock to rise
			
			BSET 3, PTBD			; G2A = 1 for clock rising edge
			
			JSR PTBDD_Upper_input		; set bits 4, 5, 6, 7 as inputs
			
			BCLR 3, PTBD			; clear clock bit
			BSET 0, PTBD			; Enable bus
			
			MOV PTBD, $62			; get data from bus and put it in $62
					
			
			LSR $62
			LSR $62					; Logical shift right 4 times
			LSR $62					; so that $62 now has 0000 and 4 bits of bus data
			LSR $62					
			
			
			LDA $62					; Load accumulator with 0000 + BUS data
			ORA $61					; combine the data from the row and column
			STA $63					; and finally store the data into $63
			
			LDA #%00001111			
			ORA $61					; Accumulator should have 1110 1111
			CMP $63					; verify a button press
									
			
			BEQ keypad_write		; else, branch to check for an input
			BRA Delay_Loop
Re_read:

			LDA #%00001111			; load accumulator
			ORA $61					; Accumulator should have 1110 1111
			CMP $63					; Check if a button was pressed
								
			BEQ done				; else, end.
			
			JSR PTBDD_Upper_input	; set bits 4, 5, 6, 7 as inputs
			BCLR 3, PTBD			; clear clock bit
			BSET 0, PTBD			; Enable bus
			MOV PTBD, $6A			; move data into $6A
			
			LSR $6A
			LSR $6A
			LSR $6A
			LSR $6A
			
			LDA $62					; load $62 into accumulator
			CMP $6A					; compare to $6A
			BNE done				; If not equal, done.
			MOV $63, $70			; else, go to button press
			BRA done				; and finish
done:
			RTS
Delay_Loop:
			LDA #50					; Load A with 65
			STA t					; store it into t, m, and b
			STA m
			STA b
			
		Top:
			LDA t					
			SUB #1					; decrease A
			BEQ Re_read				; if A = 0, reread
			STA t					; store in memeory
			LDA #50					
			STA m					; store in middle and go back
		Middle:
			LDA m
			SUB #1					; decrement
			STA m					; store back into m
			BEQ Top					; if equal to 0 go to top
			LDA #50
			STA b					; store 65 into b and go to bottom
		bottom: 
			LDA b
			SUB #1					; decrement
			STA b					; store into b 
			BEQ Middle				; go to middle if 0
			BRA bottom				; go to bottom else.
