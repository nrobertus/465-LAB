			;INCLUDE 'derivative.inc'
            
			XDEF Delay
         
			XREF t, b, m
            
MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
Delay:
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
			
; 20 ms delay $60 30, $61 255
; 4.75 ms delay $60 8, $61 255
; 116 us delay $60 2, $61 40
