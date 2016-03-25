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
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF __SEG_END_SSTACK   ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition

; code section
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
