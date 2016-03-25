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
            XDEF convert_temp
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF n, display   ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition

; code section
MyCode:     SECTION
convert_temp:
;If the reading of the internal temperature sensor is greater than 54 base 10 branch to cold slope. If the reading of the internal temperature sensor is less then 54 base 10 branch to hot slope.

			LDA #54
			CMP $85
			BMI cold_slope
			BPL hot_slope
			
cold_slope:
;Converts the reading of the internal temperature sensor into a temperature and jumps to display.
			LDA $85
			SUB #55
			CLRX
			CLRH
			LDX #12
			DIV
			STHX $85
			LDA  $85
			LDX  #100
			MUL
			CLRH
			LDX #12
			DIV
			STA $85
			CLRX
			CLRH
			LDX #100
			MUL
			CLRA
			ADD $85
			STA $85
			LDA #25
			SUB $85
			STA $86
			JSR display
			JMP done
hot_slope:
;Converts the reading of the internal temperature sensor into a temperature and jumps to display
			LDA #55
			SUB $85
			CLRX
			CLRH
			LDX #13
			DIV
			STHX $85
			LDA  $85
			LDX  #100
			MUL
			CLRH
			LDX #13
			DIV
			STA $85
			CLRX
			CLRH
			LDX #100
			MUL
			CLRA
			ADD $85
			STA $85
			
			LDA #25
			ADD $85
			STA $86
			JSR display
			JMP done
done:
;Return to subroutine from where called from.
			RTS
