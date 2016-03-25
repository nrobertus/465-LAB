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
            XDEF DAA_decode
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF one, two, three, four, five, six, seven, eight, nine, zero   ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition

; code section
MyCode:     SECTION
DAA_decode:
; based on the binary number loaded into the accumulator. 0 - 9 is written to the LCD display			
			LDA $86
			CMP #%00000001
			BEQ one_write
			CMP #%00000010
			BEQ two_write
			CMP #%00000011
			BEQ three_write
			CMP #%00000100
			BEQ four_write
			CMP #%00000101
			BEQ five_write
			CMP #%00000110
			BEQ six_write
			CMP #%00000111
			BEQ seven_write
			CMP #%00001000
			BEQ eight_write
			CMP #%00001001
			BEQ nine_write
			CMP #%00000000
			BEQ zero_write
			
one_write:
			JSR one
			JMP done
two_write:
			JSR two
			JMP done
three_write:
			JSR three
			JMP done
four_write:
			JSR four
			JMP done
five_write:
			JSR five
			JMP done
six_write:
			JSR six
			JMP done
seven_write:
			JSR seven
			JMP done
eight_write:
			JSR eight
			JMP done
nine_write:
			JSR nine
			JMP done
zero_write:
			JSR zero
			JMP done
done:
			RTS



