; Include derivative-specific definitions
            INCLUDE 'MC9S08QG8.inc'
            
; export symbols
            XDEF led_write, led_data
            
; import symbols
			XREF bus_read, bus_write, bus_addr, bus_data  


; variable/data section
MY_ZEROPAGE: SECTION  SHORT

			led_data:		DS.B	1	; 8 bit value for the 8 LEDs

; code section
MyCode:     SECTION

led_write:
			; preserve accumulator A
			PSHA

;*** write lower nibble LEDs ***
			; set the address
            LDA 	#$00
            STA		bus_addr
            
            ; set the data
            LDA 	led_data
            AND		#$0F
            STA		bus_data
            
            ; write the data
            JSR		bus_write

;*** write upper nibble LEDs ***
			; set the address
            LDA 	#$01
            STA		bus_addr
            
            ; set the data
            LDA 	led_data
            NSA
            AND		#$0F
            STA		bus_data
            
            ; write the data
            JSR		bus_write
			
;*** done ***
			; restore accumulator A
			PULA			
			RTS

