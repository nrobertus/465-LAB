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
Clock_in: MACRO
			BCLR 3, PTBD        ; Bring the clock back down
			NOP
			NOP
			NOP
			BSET 3, PTBD        ; Set bit three (G2A=1) for a rising edge of clock
		ENDM