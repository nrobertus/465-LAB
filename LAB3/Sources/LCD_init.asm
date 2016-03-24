; Include derivative-specific definitions
INCLUDE 'derivative.inc'

; export symbols
XDEF LCD_init

; imports
XREF BF_check, Delay, Clock_in t, b, m, n

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