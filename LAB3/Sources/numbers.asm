INCLUDE 'derivative.inc'
            
XDEF zero, one, two, three, four, five, six, seven, eight, nine
XREF BF_check
			
MyCode:     SECTION
zero:
	MOV #%00000000, PTBD    ; Write 0000 to the LED's 
	JSR partA
	MOV #%00001100, PTBD	; zero
	JSR partB
	RTS
	
one:
	MOV #%00010000, PTBD	; Write 0001 to the LED's 
	JSR partA
	MOV #%00011100, PTBD	; one
	JSR partB
	RTS
	
two:
	MOV #%00100000, PTBD	; Write 0010 to the LED's 
	JSR partA
	MOV #%00101100, PTBD	; two
	JSR partB
	RTS
	
three:
	MOV #%00110000, PTBD	; Write 0011 to the LED's 
	JSR partA
	MOV #%00111100, PTBD	; three
	JSR partB
	RTS
	
four:
	MOV #%01000000, PTBD	; Write 0100 to the LED's  
	JSR partA
	MOV #%01001100, PTBD	; four
	JSR partB
	RTS
	
five:
	MOV #%01010000, PTBD	; Write 0101 to the LED's 
	JSR partA
	MOV #%01011100, PTBD	; five
	JSR partB
	RTS
	
six:
	MOV #%01100000, PTBD	; Write 0110 to the LED's 
	JSR partA
	MOV #%01101100, PTBD	; six
	JSR partB
	RTS
	
seven:
	MOV #%01110000, PTBD	; Write 0111 to the LED's  
	JSR partA
	MOV #%01111100, PTBD	; seven
	JSR partB
	RTS
	
eight:
	MOV #%10000000, PTBD	; Write 1000 to the LED's  
	JSR partA
	MOV #%10001100, PTBD	; eight
	JSR partB
	RTS
	
nine:
	MOV #%10010000, PTBD	; Write 1001 to the LED's 
	JSR partA
	MOV #%10011100, PTBD	; nine
	JSR partB
	RTS
	
partA:
	BSET 3, PTBD            ; Set G2A for a rising edge of clock
	MOV #0, $70             ; Reset the button press to zero
	BSET 0, PTADD           ; Sets PTA Data Directions
	BSET 1, PTADD
	BSET 1, PTAD            ; set RS = 1
	BCLR 0, PTAD            ; set R/W = 0
	MOV #%00111100, PTBD    ; Write to the LCD display
	JSR Clock_in
	RTS
	
partB:
	MOV #%00001100, PTBD	
	JSR Clock_in
	JSR BF_check            ; Jump to BF_check
	RTS                     
