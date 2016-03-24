;*******************************************************************
;* 2/16/16														   *
;* Montana State University 								       *
;* EELE 465												           *
;* LAB1												               *
;* Garrett Cornwell												   *
;* Nathan Robertus                                                 *
;*******************************************************************

; Include derivative-specific definitions
            INCLUDE 'derivative.inc'


; export symbols
            XDEF _Startup, main, clear_bottom, check, b, t, m, XOR_mask_C, XOR_mask_C2, XOR_mask
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on

            XREF __SEG_END_SSTACK ; symbol defined by the linker for the end of the stack

MY_ZEROPAGE: SECTION  SHORT
			writeToKeypad:	EQU	$60		;value that will be written to keypad
			rowByte:				EQU	$61		;row byte in lower byte
			columnByte:			EQU $62		;column byte in upper byte
			rowAndColumn:		EQU $63		;row and column data combined
			writeToPTBD:		EQU	$64		;data written to PTBD while writing to the keypad

			PBUpperLED:			EQU $67		;pattern B upper LED byte
			PBLowerLED:			EQU $68		;pattern B lower LED byte

			rowAndColumnDecode:	EQU $70	;row and column data for decode, only updated on button press

			patternD0:			EQU $80		;pattern D lookup
			patternD1:			EQU $81		;pattern D lookup
			patternD2:			EQU $82		;pattern D lookup
			patternD3:			EQU $83		;pattern D lookup
			patternD4:			EQU $84		;pattern D lookup
			patternD5:			EQU $85		;pattern D lookup

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
			STA patternD0
			LDA #%11000001
			STA patternD1
			LDA #%00010000
			STA patternD2
			LDA #%11100001
			STA patternD3
			LDA #%00000000
			STA patternD4
			LDA #%11110001
			STA patternD5
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
			MOV #%00010000, XOR_mask_C ; Xor mask 1 for pattern C
			MOV #%00001000, XOR_mask_C2 ; Xor mask 2 for pattern C

			LDA SOPT1				; Reset on, watchdog off
			ORA #%00000001
			AND #%01111111
			STA SOPT1

			MOV #$FF, PTBDD			; Set PTBD direction as out
			MOV #%11100111, rowAndColumnDecode		; Begin with pattern A (default)

start:
			MOV #%11110111, writeToKeypad		; Store 1111 0111 into memory for first read
			JSR keypad_write		; Jump (w/ return) to keypad writing
			JMP decode				; After writing, decode the input
decode:
			; Fuction to return A B C or D
			LDA #%11110000
			ORA PTBDD
			STA PTBDD

			LDA rowAndColumnDecode					; Load pattern
			CMP #%11100111			; If pattern matches this
			BEQ Pattern_A			; branch to A
			CMP #%11101011			; Else if it matches this
			BEQ Pattern_B			; branch to B
			CMP #%11101101			; Else if it matches this
			BEQ Pattern_C_away		; branch to C
			CMP #%10101010
			BEQ Pattern_C_together
			CMP #%11101110          ; Else if it matches this
			BEQ Pattern_D           ; branch to D

Pattern_A:
			MOV #%10000000, $65
			MOV #%00010000, XOR_mask_C
			MOV #%00001000, XOR_mask_C2
			MOV #0, $8C

			; Load the upper nibble of PTBD with 1010 / selecting the 1st D-flip-flop
			LDA #%10100000
			STA PTBD
			BSET 3, PTBD			; rising edge clock

			; Load the upper nibble of PTBD with 1010 / select the 2nd D-flip-flop
			LDA #%10100001
			STA PTBD
			BSET 3, PTBD			; Grab the rising edge clock
			JMP start

Pattern_B:
			LDA XOR_mask
			CBEQA  #%00000000, Reset_XOR

			MOV #%00010000, XOR_mask_C
			MOV #%00001000, XOR_mask_C2
			MOV #0, $8C

			LDA $66
			EOR XOR_mask
			STA PBUpperLED
			STA PBLowerLED

			LSL PBLowerLED
			LSL PBLowerLED
			LSL PBLowerLED
			LSL PBLowerLED

			LDA #clear_bottom
			AND PBUpperLED
			STA PBUpperLED

			MOV PBUpperLED, PTBD
			BSET 3, PTBD             ; Grab the rising edge clock

			BSET 0, PBLowerLED

			MOV PBLowerLED, PTBD
			BSET 3, PTBD             ; Grab the rising edge clock

			LSR XOR_mask
			JMP start

Reset_XOR:
			MOV #%10000000, XOR_mask
			JMP Pattern_B

Pattern_C_away:
			JSR pattern_c_away
			JMP start

Pattern_C_together:
			JSR pattern_c_together
			JMP start

Pattern_D:
			JSR pattern_d
			JMP start

keypad_write:
			LSL writeToKeypad		; Left shift to test next row
			LDA #%11100000			; Check to see if renitialized
			CMP writeToKeypad		; to 1110 1111
			BEQ Delay_Loop			; Branch to the delay loop (and then last known pattern)

			LDA #%11110000
			ORA PTBDD
			STA PTBDD				; Set bits 4,5,6,7 of PTBD to out

			; store the row number into rowByte and clear the bottom byte.
			MOV writeToKeypad, rowByte	; Store 1110 1111 into rowByte
			LDA #%11110000		    	; load accumulator to clear the bottom 4 bits of rowByte
			AND rowByte					; Clear bottom 4 bits
			STA rowByte					; Store back into rowByte

			; Write to the keypad.
			MOV writeToKeypad, writeToPTBD			; Store 1110 1111 into PTBD

			BSET 1, writeToPTBD
			BCLR 0, writeToPTBD				; PTBD = 1110 1110
			BCLR 2, writeToPTBD				; PTBD = 1110 1010
			BCLR 3, writeToPTBD				; PTBD = 1110 0010
											;   bits 7654 GCBA
			MOV writeToPTBD, PTBD
			NOP						; no operation to give time before the rising clock edge
			BSET 3, PTBD			; Set bit three (G2A=1) for a rising edge of clock

			; Read from keypad.
			LDA #%00001111
			AND PTBDD
			STA PTBDD		; Configure bits 4, 5, 6, 7 as inputs

			BCLR 3, PTBD			; Bring the clock back down
			BSET 0, PTBD			; Enable bus transceiver to pass data to bus

			MOV PTBD, columnByte			; Move data from bus to columnByte
			LSR columnByte
			LSR columnByte					; Shift right 4x
			LSR columnByte					
			LSR columnByte					; where xxxx is the data from bus
			; combine the row (upper) and column (lower) bytes into one memory location: rowAndColumn
			LDA columnByte					; Load accumulator with 0000 xxxx
			ORA rowByte					; combine the data from row (upper) and column (lower)
			STA rowAndColumn					; store the data into rowAndColumn
			; see if a button was pressed.
			LDA #%00001111				
			ORA rowByte					; Accumulator has 1110 1111
			CMP rowAndColumn					; Check to see that a 0 is in column data
									
			BEQ keypad_write		; if key not pressed in row repeat for next row number
			BRA Delay_Loop

Re_read:
			; see if a button was pressed.
			LDA #%00001111			; load accumulator
			ORA rowByte					; Accumulator has 1110 1111
			CMP rowAndColumn					; Check to see that a 0 is in column data
									; which means that a button was pressed
			BEQ done
			LDA #%00001111
			AND PTBDD
			STA PTBDD				; Configure bits 4, 5, 6, 7 as inputs
			BCLR 3, PTBD			; Bring the clock back down
			BSET 0, PTBD			; Enable bus transceiver to pass data to bus
			MOV PTBD, $6A			; Move the data from bus to $6A
			LSR $6A
			LSR $6A
			LSR $6A
			LSR $6A

			LDA columnByte			; load columnByte into accumulator
			CMP $6A					; compare to $6A
			BNE done				; if they are not the same, go to done
			MOV rowAndColumn, rowAndColumnDecode	; otherwise, update rowAndColumnDecode with button press
			BRA done				; and go to done

done:
			RTS

Delay_Loop:
			LDA #55					; Load A with 65
			STA t					; store A into t, m, and b
			STA m
			STA b
		Top:
			LDA t
			SUB #1					; decrement A
			BEQ Re_read				; go to reread if A EQUals 0
			STA t					; store back into memory
			LDA #55
			STA m					; store 65 into middle if not EQUal to zero and go to middle
		Middle:
			LDA m
			SUB #1					; decrement
			STA m					; store back into m
			BEQ Top					; if EQUal to 0 go to top
			LDA #55
			STA b					
		bottom:
			LDA b
			SUB #1					; decrement
			STA b					; store back into b
			BEQ Middle				; if EQUal to 0 branch to middle
			BRA bottom				; if not 0 branch to bottom

pattern_c_away:
			MOV #%11101101, rowAndColumnDecode

			LDA XOR_mask_C
			CMP #%10000000
			BEQ pattern_c_together

			MOV #%10000000, XOR_mask
			MOV #0, $8C

			LDA $6B
			EOR XOR_mask_C
			EOR XOR_mask_C2
			STA PBUpperLED
			STA PBLowerLED

			LSL PBLowerLED
			LSL PBLowerLED
			LSL PBLowerLED
			LSL PBLowerLED

			LDA #clear_bottom
			AND PBUpperLED
			STA PBUpperLED

			MOV PBUpperLED, PTBD
			BSET 3, PTBD

			BSET 0, PBLowerLED

			MOV PBLowerLED, PTBD
			BSET 3, PTBD

			LSL XOR_mask_C
			LSR XOR_mask_C2
			RTS
pattern_c_together:
			MOV #%10101010, rowAndColumnDecode

			LDA XOR_mask_C
			CMP #%00010000
			BEQ pattern_c_away

			LDA $6B
			EOR XOR_mask_C
			EOR XOR_mask_C2
			STA PBUpperLED
			STA PBLowerLED

			LSL PBLowerLED
			LSL PBLowerLED
			LSL PBLowerLED
			LSL PBLowerLED

			LDA #clear_bottom
			AND PBUpperLED
			STA PBUpperLED

			MOV PBUpperLED, PTBD
			BSET 3, PTBD

			BSET 0, PBLowerLED

			MOV PBLowerLED, PTBD
			BSET 3, PTBD

			LSR XOR_mask_C
			LSL XOR_mask_C2
			RTS

reset:
		  MOV #1, $8C
		  JMP pattern_d
pattern_d:
		  MOV #%10000000, $65
		  MOV #%00010000, XOR_mask_C
		  MOV #%00001000, XOR_mask_C2
          LDA $8C
          CMP #11
          BEQ reset
          CMP #0
          BEQ one
          CMP #1
          BEQ two
          CMP #2
          BEQ three
          CMP #3
          BEQ four
          CMP #4
          BEQ five
          CMP #5
          BEQ six
          CMP #6
          BEQ five
          CMP #7
          BEQ four
          CMP #8
          BEQ three
          CMP #9
          BEQ two
          CMP #10
          BEQ one
one:
			MOV patternD0, PTBD
			BSET 3, PTBD
			MOV patternD1, PTBD
			BSET 3, PTBD
			LDA $8C
          ADD #1
          STA $8C
          RTS

two:
			MOV patternD2, PTBD
			BSET 3, PTBD
			MOV patternD3, PTBD
			BSET 3, PTBD
          LDA $8C
          ADD #1
          STA $8C
          RTS
three:
			MOV patternD4, PTBD
			BSET 3, PTBD
			MOV patternD5, PTBD
			BSET 3, PTBD
          LDA $8C
          ADD #1
          STA $8C
          RTS
four:
			MOV $86, PTBD
			BSET 3, PTBD
			MOV $87, PTBD
			BSET 3, PTBD
          LDA $8C
          ADD #1
          STA $8C
          RTS
five:
			MOV $88, PTBD
			BSET 3, PTBD
			MOV $89, PTBD
			BSET 3, PTBD
          LDA $8C
          ADD #1
          STA $8C
          RTS
six:
			MOV $8A, PTBD
			BSET 3, PTBD
			MOV $8B, PTBD
			BSET 3, PTBD
          LDA $8C
          ADD #1
          STA $8C
          RTS
