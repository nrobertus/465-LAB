INCLUDE 'derivative.inc'
            
XDEF average_readings  
XREF n, convert_temp, displayx   ; symbol defined by the linker for the end of the stack

MyCode:     SECTION
; All math is done with counts 
average_readings:
; clears the accumulator, the following memory addresses listed below and moves the number of readings into address $84 in memory.
			CLRA
			CLR $85
			CLR $88
			CLR $70
			MOV n, $84
			
for_loop:
; internal sensor
; asks for a temperature reading from the internal temperature sensor.
			feed_watchdog
			BCLR 6, ADCSC1
			BCLR 5, ADCSC1
			BSET 4, ADCSC1
			BSET 3, ADCSC1
			BCLR 2, ADCSC1
			BSET 1, ADCSC1
			BCLR 0, ADCSC1
			
check_coco:
; internal sensor
; checks the coco bit and if it is set branch to check_n else branch to check_coco again. 			
			BRSET 7, ADCSC1, check_n
			BRA check_coco
check_n:
;internal sensor
;averages each reading with the number of readings, averages the remainder of each reading with the number of readings,
;combines the remainder with the reading and jump to convert_temp. Then reinitialize the memory address where the number of readings are stored in memory to zero.
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
			
for_loopx:
; external sensor
; asks for a temperature reading from the external temperature sensor.
			feed_watchdog
			BCLR 2, PTADD
			BCLR 6, ADCSC1
			BCLR 5, ADCSC1
			BCLR 4, ADCSC1
			BCLR 3, ADCSC1
			BCLR 2, ADCSC1
			BSET 1, ADCSC1
			BCLR 0, ADCSC1
check_cocox:
; external sensor
; checks the coco bit and if it is set branch to check_nx else branch to check_cocox again.			
			BRSET 7, ADCSC1, check_nx
			BRA check_cocox
check_nx:
;external sensor
;averages each reading with the number of readings, averages the remainder of each reading with the number of readings,
;combines the remainder with the reading. Converts the reading into a temperature then jumps to displayx.
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
			
