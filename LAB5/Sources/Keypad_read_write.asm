			INCLUDE 'derivative.inc'
			XDEF keypad_write
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF b, t, m   ; symbol defined by the linker for the end of the stack

MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
keypad_write:
		
			LSL $60					; logical shift left so that the next row 
									; on keypad will be tested if key not pressed
			
			feed_watchdog
			
			; see if all the rows have been tested
			LDA #%11100000			; test $60 to see if it needs to be reinitialized
			CMP $60					; to 1110 1111
			BEQ Delay_Loop			; we will actually branch to last known LED sequence
			
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
			BRA Delay_Loop
Re_read:

			; see if a button was pressed.
			LDA #%00001111			; load accumulator
			ORA $61					; Accumulator has 1110 1111
			CMP $63					; Check to see that a 0 is in column data
									; which means that a button was pressed
			BEQ done				; if key not pressed, go to done.
			
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
			BNE done				; if they are not the same, go to done
			MOV $63, $70			; otherwise, update $70 with button press
			BRA done				; and go to done
done:
			RTS
Delay_Loop:
			LDA #40					; Load A with 65
			STA t					; store A into t, m, and b
			STA m
			STA b
			
		Top:
			feed_watchdog
			LDA t					
			SUB #1					; decrement A
			BEQ Re_read				; go to reread if A equals 0
			STA t					; store back into memory
			LDA #40					
			STA m					; store 65 into middle if not equal to zero and go to middle
		Middle:
			feed_watchdog
			LDA m
			SUB #1					; decrement
			STA m					; store back into m
			BEQ Top					; if equal to 0 go to top
			LDA #40
			STA b					; store 65 into b and go to bottom
		bottom: 
			feed_watchdog	
			LDA b
			SUB #1					; decrement
			STA b					; store back into b 
			BEQ Middle				; if equal to 0 branch to middle
			BRA bottom				; if not 0 branch to bottom
