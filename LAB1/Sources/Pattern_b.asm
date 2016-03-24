			INCLUDE 'derivative.inc'
			XDEF pattern_b
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF XOR_mask_C, XOR_mask_C2, XOR_mask, clear_bottom  ; symbol defined by the linker for the end of the stack

MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
pattern_b:

			LDA XOR_mask
			CMP #%00000000
			BEQ Reset_XOR
			
			Pattern_B
			RTS
Reset_XOR:
		MOV #%10000000, XOR_mask
		JMP pattern_b
