INCLUDE 'derivative.inc'
            
XDEF convert_temp   
XREF n, display   ; symbol defined by the linker for the end of the stack

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
