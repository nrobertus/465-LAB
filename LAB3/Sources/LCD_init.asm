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
            XDEF LCD_init
          
            XREF BF_check, Delay, Clock_in, t, b, m, n  

MY_ZEROPAGE: SECTION  SHORT       

MyCode:     SECTION
LCD_init:
	MOV #40, t
	MOV #255, b
	JSR Delay				; wait 15 ms
			
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00111100, PTBD
	JSR Clock_in
			
	MOV #20, t
	MOV #255, b
	JSR Delay				; wait 4.1 ms
	
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00111100, PTBD	
	JSR Clock_in
	
	MOV #10, t
	MOV #40, b
	JSR Delay				; wait 100 us
	
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00111100, PTBD	
	JSR Clock_in
	
	JSR BF_check			; check the BF
	
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00101100, PTBD	
	JSR Clock_in
			
	JSR BF_check			; check the BF
		
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00101100, PTBD	
	JSR Clock_in
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%10101100, PTBD	; set N and F 
	JSR Clock_in
				
	JSR BF_check			; check the BF
	
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00001100, PTBD
	JSR Clock_in
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%10001100, PTBD	; turn off display
	JSR Clock_in
			
	JSR BF_check			; check the BF
			
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00001100, PTBD
	JSR Clock_in
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00011100, PTBD	; clear the display
	JSR Clock_in
			
	JSR BF_check			; check the BF
	
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00001100, PTBD
	JSR Clock_in
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%01101100, PTBD	; Set entry mode
	JSR Clock_in
	
	JSR BF_check			; check the BF
	
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00001100, PTBD
	JSR Clock_in
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%11111100, PTBD	; Turn on display
	JSR Clock_in
	
	JSR BF_check
	RTS
