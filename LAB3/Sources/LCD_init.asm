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
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF BF_check, Delay, Clock_in, t, b, m, n   ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition

; code section
MyCode:     SECTION
LCD_init:
	MOV #40, t
	MOV #255, b
	JSR Delay				; wait for 15 ms
			
	BCLR 0, PTAD			; function set command
	BCLR 1, PTAD
	MOV #%00111100, PTBD
	JSR Clock_in
			
	MOV #20, t
	MOV #255, b
	JSR Delay				; wait for 4.1 ms
	
	BCLR 0, PTAD			; function set command
	BCLR 1, PTAD
	MOV #%00111100, PTBD	; function set command
	JSR Clock_in
	
	MOV #10, t
	MOV #40, b
	JSR Delay				; wait for 100 us
	
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00111100, PTBD	; function set command
	JSR Clock_in
	
	JSR BF_check			; check BF
	
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00101100, PTBD	; function set
	JSR Clock_in
			
	JSR BF_check			; check BF
		
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00101100, PTBD	; function set
	JSR Clock_in
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%10101100, PTBD	; set N and F here
	JSR Clock_in
				
	JSR BF_check			; check BF
	
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00001100, PTBD
	JSR Clock_in
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%10001100, PTBD	; Display off command
	JSR Clock_in
			
	JSR BF_check			; check BF
			
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00001100, PTBD
	JSR Clock_in
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00011100, PTBD	; Clear Display command
	JSR Clock_in
			
	JSR BF_check			; check BF
	
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00001100, PTBD
	JSR Clock_in
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%01101100, PTBD	; Entry Mode Set
	JSR Clock_in
	
	JSR BF_check			; check BF
	
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%00001100, PTBD
	JSR Clock_in
	BCLR 0, PTAD			
	BCLR 1, PTAD
	MOV #%11111100, PTBD	; Display On
	JSR Clock_in
	
	JSR BF_check
	RTS
