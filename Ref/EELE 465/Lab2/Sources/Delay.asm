			;INCLUDE 'derivative.inc'
            
			XDEF Delay
         
			XREF t, b, m
            
MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
Delay:
	MOV b, m
	top:
			DEC t
			BEQ ass
			MOV m, b
	bottom:
			DEC b
			BEQ top
			BRA bottom
			
	ass:
			
			RTS
			
; 20 ms delay $71 30, $73 255
; 4.75 ms delay $71 8, $73 255
; 116 us delay $71 2, $73 40
