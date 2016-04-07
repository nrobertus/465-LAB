			INCLUDE 'derivative.inc'
            
			XDEF LCD_init

			XREF BF_check, clock
            
MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
LCD_init:
			MOV #40, t
			MOV #255, b
			JSR Delay				; wait for 15 ms
			
			BCLR 0, PTAD			; function set command
			BCLR 1, PTAD
			MOV #%00111100, PTBD
			JSR clock
			
			MOV #20, t
			MOV #255, b
			JSR Delay				; wait for 4.1 ms
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00111100, PTBD	; function set command
			JSR clock
			
			MOV #10, t
			MOV #40, b
			JSR Delay				; wait for 100 us
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00111100, PTBD	; function set command
			JSR clock
			
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00101100, PTBD	; function set
			JSR clock
			
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00101100, PTBD	; function set
			JSR clock
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%10101100, PTBD	; set N and F here
			JSR clock
				
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00001100, PTBD
			JSR clock
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%10001100, PTBD	; Display off command
			JSR clock
			
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00001100, PTBD
			JSR clock
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00011100, PTBD	; Clear Display command
			JSR clock
			
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00001100, PTBD
			JSR clock
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%01101100, PTBD	; Entry Mode Set
			JSR clock
			
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00001100, PTBD
			JSR clock
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%11111100, PTBD	; Display On
			JSR clock
			
			JSR BF_check
			
			RTS
