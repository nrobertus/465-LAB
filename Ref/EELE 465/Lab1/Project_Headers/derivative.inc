; Note: This file is recreated by the project wizard whenever the MCU is
;       changed and should not be edited by hand

; include derivative specific macros
            INCLUDE 'MC9S08QG8.inc'


; RAM/ROM definitions


; Watchdog feed macro
feed_watchdog: MACRO
            STA SRS              ; feed the watchdog
          ENDM

PTBDD_Upper_output: MACRO
			LDA #%11110000
			ORA PTBDD
			STA PTBDD
		ENDM
		
PTBDD_Upper_input: MACRO
			LDA #%00001111
			AND PTBDD
			STA PTBDD
		ENDM
Pattern_A: MACRO

			MOV #%10000000, $65
			MOV #%00010000, XOR_mask_C 
			MOV #%00001000, XOR_mask_C2
			MOV #0, $8C
			
			; Load the upper byte of PTBD with 1010 while selecting the upper D-flip-flop
			LDA #%10100000
			STA PTBD
			BSET 3, PTBD			; rising edge clock
	
			; Load the upper byte of PTBD with 1010 while selecting the lower D-flip-flop
			LDA #%10100001
			STA PTBD
			BSET 3, PTBD			; rising edge clock
		ENDM
Pattern_B: MACRO

			MOV #%00010000, XOR_mask_C 
			MOV #%00001000, XOR_mask_C2
			MOV #0, $8C
			
			LDA $66
			EOR XOR_mask
			STA $67
			STA $68
			
			LSL $68
			LSL $68
			LSL $68
			LSL $68
			
			LDA #clear_bottom
			AND $67
			STA $67
			
			MOV $67, PTBD
			BSET 3, PTBD             ; rising edge clock
			
			BSET 0, $68
			
			MOV $68, PTBD
			BSET 3, PTBD             ; rising edge clock
			
			LSR XOR_mask
		ENDM
Pattern_C_away: MACRO

			MOV #%10000000, XOR_mask
			MOV #0, $8C

			LDA $6B
			EOR XOR_mask_C
			EOR XOR_mask_C2
			STA $67
			STA $68
			
			LSL $68
			LSL $68
			LSL $68
			LSL $68
			
			LDA #clear_bottom
			AND $67
			STA $67
			
			MOV $67, PTBD
			BSET 3, PTBD
			
			BSET 0, $68
			
			MOV $68, PTBD
			BSET 3, PTBD
			
			LSL XOR_mask_C
			LSR XOR_mask_C2
		ENDM
Pattern_C_together: MACRO
			LDA $6B
			EOR XOR_mask_C
			EOR XOR_mask_C2
			STA $67
			STA $68
			
			LSL $68
			LSL $68
			LSL $68
			LSL $68
			
			LDA #clear_bottom
			AND $67
			STA $67
			
			MOV $67, PTBD
			BSET 3, PTBD
			
			BSET 0, $68
			
			MOV $68, PTBD
			BSET 3, PTBD
			
			LSR XOR_mask_C
			LSL XOR_mask_C2
		ENDM
Pattern_D1: MACRO
           MOV $80, PTBD
           BSET 3, PTBD
           MOV $81, PTBD
           BSET 3, PTBD
        ENDM
Pattern_D2: MACRO
           MOV $82, PTBD
           BSET 3, PTBD
           MOV $83, PTBD
           BSET 3, PTBD
        ENDM
Pattern_D3: MACRO
           MOV $84, PTBD
           BSET 3, PTBD
           MOV $85, PTBD
           BSET 3, PTBD
        ENDM
Pattern_D4: MACRO
           MOV $86, PTBD
           BSET 3, PTBD
           MOV $87, PTBD
           BSET 3, PTBD
        ENDM
Pattern_D5: MACRO
           MOV $88, PTBD
           BSET 3, PTBD
           MOV $89, PTBD
           BSET 3, PTBD
        ENDM
Pattern_D6: MACRO
           MOV $8A, PTBD
           BSET 3, PTBD
           MOV $8B, PTBD
           BSET 3, PTBD
        ENDM
      