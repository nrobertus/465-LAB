; Include derivative-specific definitions
INCLUDE 'derivative.inc'

; export symbols
XDEF ADC_init

; code section
MyCode:     SECTION

ADC_init:
; initializes the analog to digital converter to use 8-bit mode
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