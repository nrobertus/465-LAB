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
            XDEF ADC_init
            
            
            
            XREF __SEG_END_SSTACK   ; symbol defined by the linker for the end of the stack


MY_ZEROPAGE: SECTION  SHORT        

MyCode:     SECTION
ADC_init:
; initializes the ADC into eight bit mode
	MOV #%00000000, ADCCFG
			
	BCLR 6, ADCSC2
	BCLR 5, ADCSC2
	BCLR 4, ADCSC2
			
	BCLR 6, ADCSC1
	BCLR 5, ADCSC1
	BSET 4, ADCSC1
	BSET 3, ADCSC1
	BCLR 2, ADCSC1
	BSET 1, ADCSC1
	BCLR 0, ADCSC1
	RTS


