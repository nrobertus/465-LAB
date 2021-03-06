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
            XDEF display_char
     
            XREF char_1, char_2, n, clear_display, BF_check, new_address, DAA_decode, PTBDD_Upper_output, Clock_in   ; symbol defined by the linker for the end of the stack

MY_ZEROPAGE: SECTION  SHORT 

MyCode:     SECTION
display_char:

			BSET 1, PTAD
			BCLR 0, PTAD
			MOV char_1, PTBD
			JSR Clock_in
			MOV char_2, PTBD
			JSR Clock_in
			JSR BF_check
			RTS
