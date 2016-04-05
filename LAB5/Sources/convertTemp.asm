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
            
            XREF n, display


MY_ZEROPAGE: SECTION  SHORT 

MyCode:     SECTION
convert_temp:
;check to see if we should go to the cold or hot conversion

			LDA #54
			CMP $85
			BMI cold_slope
			BPL hot_slope
			
cold_slope:
;convert to temp and then move on to display
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
;convert temperature and go to the display
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
;Return from whence you came. 
			RTS
