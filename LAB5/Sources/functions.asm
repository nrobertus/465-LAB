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
            XDEF PTBDD_Upper_output, PTBDD_Upper_input, Clock_in

            XREF __SEG_END_SSTACK   

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
Clock_in:
	BCLR 3, PTBD        ; Clear clock bit
	NOP
	NOP
	NOP
	BSET 3, PTBD        ; set bit for rising clock
	RTS