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
            XDEF _Startup, main
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF __SEG_END_SSTACK   ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition
				t: equ $60
				m: equ $61
				b: equ $62

; code section
MyCode:     SECTION
main:
_Startup:
            LDHX   #__SEG_END_SSTACK ; initialize the stack pointer
            TXS
			CLI			; enable interrupts
			MOV		#%1, PTADD

mainLoop:
            ; Insert your code here
            feed_watchdog
            LDA		PTAD
            COMA
            STA		PTAD
            BRA delayLoop
delayLoop:							; 1.99s delay loop.
			feed_watchdog
			LDA #53 				; Load A with 53
			STA t					; store A into t
			
		Top:
			feed_watchdog
			LDA t					
			SUB #1					; decrement A
			BEQ mainLoop			; go to mainLoop if A equals 0
			STA t					; store back into memory
			LDA #65					
			STA m					; store 65 into middle if not equal to zero and go to middle
		Middle:
			feed_watchdog
			LDA m
			SUB #1					; decrement M
			STA m					; store back into m
			BEQ Top					; if equal to 0 go to top
			LDA #65
			STA b					; store 65 into b and go to bottom
		bottom: 
			feed_watchdog	
			LDA b
			SUB #1					; decrement B
			STA b					; store back into b 
			BEQ Middle				; if equal to 0 branch to middle
			BRA bottom				; if not 0 branch to bottom


