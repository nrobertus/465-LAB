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
            XDEF average_readings
            
            
            XREF n, convert_temp, displayx   


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition

; code section
MyCode:     SECTION
average_readings:
; clear the accumulator, move readings into $84
			CLRA
			CLR $85
			CLR $88
			CLR $70
			MOV n, $84

; BEGIN INTERNAL SENSOR		
for_loop:

; Poll internal sensor for data
			feed_watchdog
			BCLR 6, ADCSC1
			BCLR 5, ADCSC1
			BSET 4, ADCSC1
			BSET 3, ADCSC1
			BCLR 2, ADCSC1
			BSET 1, ADCSC1
			BCLR 0, ADCSC1
			
check_coco: ; self-explanatory here		
			BRSET 7, ADCSC1, check_n
			BRA check_coco
check_n:
;Take averages here
			LDA ADCRL
			CLRX
			CLRH
			LDX $84
			DIV
			ADD $85
			STA $85
			
			CLRA
			STHX $86
			LDA $88
			ADD $86
			STA $88
			DEC n
			BNE for_loop
			
			LDA $88
			CLRX
			CLRH
			LDX $84
			DIV
			ADD $85
			STA $85
			JSR convert_temp
			CLR $88
			CLR $89
			MOV $84, n
			
;END INTERNAL SENSOR

;BEGIN EXTERNAL SENSOR			
for_loopx:
;Poll external sensor
			feed_watchdog
			BCLR 2, PTADD
			BCLR 6, ADCSC1
			BCLR 5, ADCSC1
			BCLR 4, ADCSC1
			BCLR 3, ADCSC1
			BCLR 2, ADCSC1
			BSET 1, ADCSC1
			BCLR 0, ADCSC1
check_cocox: ; again, self-explanatory	
			BRSET 7, ADCSC1, check_nx
			BRA check_cocox
check_nx:
;take average
;jump away when done.
			LDA ADCRL
			CLRX
			CLRH
			LDX $84
			DIV
			STA $85
			STHX $86
			ADD $88
			STA $88
			LDA $86
			ADD $89
			STA $89
			
			DEC n
			BNE for_loopx
			
			LDA $89
			CLRX
			CLRH
			LDX $84
			DIV
			ADD $88
			STA $85
			
			LDA #144
			SUB $85
			STA $85
			
			JSR displayx
			RTS		
			

