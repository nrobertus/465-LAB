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
            XDEF zero, one, two, three, four, five, six, seven, eight, nine
            
            
            
            XREF BF_check, Clock_in   ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         

; code section
MyCode:     SECTION
zero: 
	MOV #%00000000, PTBD    ; Write 0000 to LED
	JSR partA
	MOV #%00001100, PTBD	
	JSR partB
	RTS
	
one:
	MOV #%00010000, PTBD	; Write 0001 to LED's 
	JSR partA
	MOV #%00011100, PTBD	
	JSR partB
	RTS
	
two:
	MOV #%00100000, PTBD	; Write 0010 to LED's 
	JSR partA
	MOV #%00101100, PTBD	
	JSR partB
	RTS
	
three:
	MOV #%00110000, PTBD	; Write 0011 to LED's 
	JSR partA
	MOV #%00111100, PTBD	
	JSR partB
	RTS
	
four:
	MOV #%01000000, PTBD	; Write 0100 to LED's  
	JSR partA
	MOV #%01001100, PTBD	
	JSR partB
	RTS
	
five:
	MOV #%01010000, PTBD	; Write 0101 to LED's 
	JSR partA
	MOV #%01011100, PTBD	
	JSR partB
	RTS
	
six:
	MOV #%01100000, PTBD	; Write 0110 to LED's 
	JSR partA
	MOV #%01101100, PTBD	
	JSR partB
	RTS
	
seven:
	MOV #%01110000, PTBD	; Write 0111 to the LED's  
	JSR partA
	MOV #%01111100, PTBD	; seven
	JSR partB
	RTS
	
eight:
	MOV #%10000000, PTBD	; Write 1000 to LED's  
	JSR partA
	MOV #%10001100, PTBD	
	JSR partB
	RTS
	
nine:
	MOV #%10010000, PTBD	; Write 1001 to LED's 
	JSR partA
	MOV #%10011100, PTBD
	JSR partB
	RTS
	
partA:
	BSET 3, PTBD            ; Set G2A clock edge
	MOV #0, $70             ; Reset button press
	BSET 0, PTADD           ; Sets directions of PTA
	BSET 1, PTADD
	BSET 1, PTAD            
	BCLR 0, PTAD            
	MOV #%00111100, PTBD    ; Write data the LCD module
	JSR Clock_in
	RTS
	
partB:
	MOV #%00001100, PTBD	
	JSR Clock_in
	JSR BF_check            ; Jump to check subroutine
	RTS
