INCLUDE 'derivative.inc'
            
XDEF PTBDD_Upper_output, PTBDD_Upper_input, Clock_in
XREF BF_check
			
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
Clock_in:
	BCLR 3, PTBD        ; Bring the clock back down
	NOP
	NOP
	NOP
	BSET 3, PTBD        ; Set bit three (G2A=1) for a rising edge of clock
	RTS