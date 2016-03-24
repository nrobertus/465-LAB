			INCLUDE 'derivative.inc'
			XDEF pattern_a
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF XOR_mask_C, XOR_mask_C2  ; symbol defined by the linker for the end of the stack

MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
pattern_a:
			Pattern_A
			RTS
