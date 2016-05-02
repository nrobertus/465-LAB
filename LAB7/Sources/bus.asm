; EQU statements
mDataBus		EQU	$F0		; Mask for the data bus pins on PortB
mAddrBus		EQU	$0F		; Mask for the address bus pins on PortB


; Include derivative-specific definitions
            INCLUDE 'MC9S08QG8.inc'
            
; export symbols
            XDEF bus_init, bus_write, bus_read, bus_addr, bus_data
            
; import symbols
			XREF _Startup, main, _Vtpmov  


; variable/data section
MY_ZEROPAGE: SECTION  SHORT

			bus_addr:		DS.B	1	; only use lower 3 bits
			bus_data:		DS.B	1	; only use lower 4 bits

; code section
MyCode:     SECTION

bus_init:
			; preserve registers
			PSHA
			
			;*** init Data & Address Busses ***
			LDA		mAddrBus				; Set Address Bus pins as output by default, leave data as input
			STA		PTBDD
			LDA		$00						; Leave all of PortB as input at start 
			STA		PTBD
			
			; restore registers
			PULA

bus_read:
			; preserve accumulator A
			PSHA

			; make address bus output, data bus an input
            LDA		#mAddrBus
            STA		PTBDD
            
			; pull the address low
            LDA 	bus_addr			; load address
            AND		#$07				; mask off the lower 3 bits to be sure, will leave G2A low
            STA		PTBD				; write data to address bus, and clear data bus
            
            ; read data from the bus
            LDA		PTBD
            NSA 						; shift data down to the lower 4 bits
            AND		#$0F				; mask off the lower 4 bits to be sure
            STA		bus_data			; 
            
			; pull the address high
            LDA 	#$08				; G2A_not high
            STA		PTBD				; write, clears address bus
            
			; restore accumulator A
			PULA
			
			; return from subroutine bus_read
			RTS

bus_write:
			; preserve accumulator A
			PSHA			
			
			; make data and address busses outputs
            LDA		#$FF
            STA		PTBDD
            
            ; prep data for the bus
            LDA		bus_data
            NSA 						; swap the lower 4 bits to be the upper 4 bits
            AND		#$F0				; mask off the upper 4 bits to be sure
            
			; prep the addr, G2A_not low, Yx goes low
            ORA		bus_addr 			; add in the address
            STA		PTBD				; write data and address bus, with G2A_not low            
            
            ORA		#$08				; leave data and address, set G2A_not high - Yx goes high
            STA		PTBD
            
			; restore accumulator A
			PULA
			
			; return from subroutine bus_write
			RTS

			
