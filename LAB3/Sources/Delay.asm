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
            XDEF Delay

            XREF t, b, m 

MY_ZEROPAGE: SECTION  SHORT         

MyCode:     SECTION
Delay: ; Yep, a straign up delay loop
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
