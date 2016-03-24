            INCLUDE 'derivative.inc'
			XDEF pattern_d
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF XOR_mask_C, XOR_mask_C2  ; symbol defined by the linker for the end of the stack

MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION

reset:
		  MOV #1, $8C
		  JMP pattern_d
pattern_d:
		  MOV #%10000000, $65
		  MOV #%00010000, XOR_mask_C 
		  MOV #%00001000, XOR_mask_C2
          LDA $8C
          CMP #11
          BEQ reset
          CMP #0
          BEQ one
          CMP #1
          BEQ two
          CMP #2
          BEQ three
          CMP #3
          BEQ four
          CMP #4
          BEQ five
          CMP #5
          BEQ six
          CMP #6
          BEQ five
          CMP #7
          BEQ four
          CMP #8
          BEQ three
          CMP #9
          BEQ two
          CMP #10
          BEQ one
one: 
          Pattern_D1
          LDA $8C
          ADD #1
          STA $8C
          RTS

two: 
          Pattern_D2
          LDA $8C
          ADD #1
          STA $8C
          RTS
three: 
          Pattern_D3
          LDA $8C
          ADD #1
          STA $8C
          RTS
four: 
          Pattern_D4
          LDA $8C
          ADD #1
          STA $8C
          RTS
five: 
          Pattern_D5
          LDA $8C
          ADD #1
          STA $8C
          RTS
six: 
          Pattern_D6
          LDA $8C
          ADD #1
          STA $8C
          RTS

