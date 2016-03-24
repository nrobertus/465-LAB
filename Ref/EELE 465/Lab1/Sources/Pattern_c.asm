			INCLUDE 'derivative.inc'
			XDEF pattern_c_away, pattern_c_together
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF XOR_mask_C, XOR_mask_C2, XOR_mask, clear_bottom  ; symbol defined by the linker for the end of the stack

MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
pattern_c_away:
			MOV #%11101101, $70
			
			LDA XOR_mask_C
			CMP #%10000000
			BEQ pattern_c_together
			
			Pattern_C_away
			RTS
pattern_c_together:
			MOV #%10101010, $70
			
			LDA XOR_mask_C
			CMP #%00010000
			BEQ pattern_c_away
			
			Pattern_C_together
			RTS
