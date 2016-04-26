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
            XDEF PTBDD_Upper_output, PTBDD_Upper_input, toggle_clock, delay

            XREF __SEG_END_SSTACK, n, t, b, m

MY_ZEROPAGE: SECTION  SHORT

MyCode:     SECTION
PTBDD_Upper_output:
	LDA #%11110000
	ORA PTBDD
	STA PTBDD
	RTS
PTBDD_Upper_input:
	LDA #%00001111
	AND PTBDD
	STA PTBDD
	RTS
toggle_clock:
	BCLR 3, PTBD        ; Clear clock bit
	NOP
	NOP
	NOP
	BSET 3, PTBD        ; set bit for rising clock
	RTS

delay:
	MOV b, m
	top:
			DEC t
			BEQ last
			MOV m, b
	bottom:
			DEC b
			BEQ top
			BRA bottom

	last:

			RTS

; 20 ms delay $60 30, $61 255
; 4.75 ms delay $60 8, $61 255
; 116 us delay $60 2, $61 40
