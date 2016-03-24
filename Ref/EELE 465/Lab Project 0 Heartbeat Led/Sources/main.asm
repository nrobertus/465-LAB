;*******************************************************************
;* 																   *
;*	EELE 465													   *
;*	1/20/2015													   *
;*	Lab 0														   *
;*	Authors: Levi Hartman, Erik Andersen						   *
;*																   *
;*******************************************************************

; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            

; export symbols
            XDEF _Startup, main
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF __SEG_END_SSTACK   ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definiti
				
				t: equ $60
				m: equ $61
				b: equ $62
							
; code section
MyCode:     SECTION
main:
_Startup:
			
			BSET 6, PTBDD			; Configure the data direction register, bit 6 port B, as an output
			BSET 6, PTBD			; Set bit 6 in Port B Data
			
				loop1:
			
				feed_watchdog		; Feed the watchdog!
				LDA PTBD			; Load port B into accumulator
				COMA				; 1's Complement the data in accumulator 
				STA PTBD			; Store the accumulator back into port B
				BRA Delay_Loop		; Branch back to loop1
				
			
            feed_watchdog
            BRA    main

Delay_Loop:							; 2.447s delay loop.

			LDA #65					; Load A with 65
			STA t					; store A into t, m, and b
			STA m
			STA b
			
		Top:
			feed_watchdog
			LDA t					
			SUB #1					; decrement A
			BEQ loop1				; go to loop1 if A equals 0
			STA t					; store back into memory
			LDA #65					
			STA m					; store 65 into middle if not equal to zero and go to middle
		Middle:
			feed_watchdog
			LDA m
			SUB #1					; decrement
			STA m					; store back into m
			BEQ Top					; if equal to 0 go to top
			LDA #65
			STA b					; store 65 into b and go to bottom
		bottom: 
			feed_watchdog	
			LDA b
			SUB #1					; decrement
			STA b					; store back into b 
			BEQ Middle				; if equal to 0 branch to middle
			BRA bottom				; if not 0 branch to bottom

