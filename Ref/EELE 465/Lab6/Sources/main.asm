;*******************************************************************
;*																   *
;* Authors: Levi Hartman, Erik Andersen							   *
;* Project: Lab 3, Temperature Sensor							   *
;* Date: 4/2/2015												   *
;*																   *
;*																   *
;*******************************************************************

; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            

; export symbols
            XDEF _Startup, main, t, b, m, n, XOR_Mask, i_temp

			XREF __SEG_END_SSTACK, BF_check, Delay, keypad_write, clear_display, new_address, mode_b, LCD_write, mode_a, off  ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition

			n: EQU $7C
			t: EQU $71
			m: EQU $72
			b: EQU $73
			i_temp: EQU $74
			XOR_Mask: EQU %00010000
			
; Me write code here
MyCode:     SECTION
main:
_Startup:							; literally... this happens on Startup. Nothing exciting...
			BSET 0, PTADD			; Set data direction for port A to outputs.
			BSET 1, PTADD
			BSET 2, PTADD
			BSET 3, PTADD
			BCLR 2, PTADD
			BCLR 2, PTAD			; Clear all of port A
			BCLR 3, PTAD
			BCLR 4, PTAD
			BCLR 5, PTAD
			MOV #$FF, PTBDD			; set data direction for port B
			MOV #%00000000, $82		; initial heartbeat LED.
			
			LDA SOPT1				; Enable the reset switch.
			ORA #%00000001
			AND #%01111111			; disable watchdog
			STA SOPT1
			
			MOV #$01, PTBD
			BSET 3, PTBD
			BCLR 3, PTBD
			
			MOV #0, $95
			MOV #0, $96
			MOV #$30, $97
			
			MOV #%10111110, $A0
			
LCD_initialization:
			feed_watchdog
			MOV #40, t
			MOV #255, b
			JSR Delay				; wait for 15 ms
			
			BCLR 0, PTAD			; function set command
			BCLR 1, PTAD
			MOV #%00111100, PTBD
			Clock_in
			
			MOV #20, t
			MOV #255, b
			JSR Delay				; wait for 4.1 ms
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00111100, PTBD	; function set command
			Clock_in
			
			MOV #10, t
			MOV #40, b
			JSR Delay				; wait for 100 us
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00111100, PTBD	; function set command
			Clock_in
			
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00101100, PTBD	; function set
			Clock_in
			
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00101100, PTBD	; function set
			Clock_in
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%10101100, PTBD	; set N and F here
			Clock_in
				
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00001100, PTBD
			Clock_in
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%10001100, PTBD	; Display off command
			Clock_in
			
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00001100, PTBD
			Clock_in
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00011100, PTBD	; Clear Display command
			Clock_in
			
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00001100, PTBD
			Clock_in
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%01101100, PTBD	; Entry Mode Set
			Clock_in
			
			JSR BF_check			; check BF
			
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%00001100, PTBD
			Clock_in
			BCLR 0, PTAD			
			BCLR 1, PTAD
			MOV #%11111100, PTBD	; Display On
			Clock_in
			
			JSR BF_check
			
ask_temp:
			MOV #$01, PTBD
			BSET 3, PTBD
			NOP
			BCLR 3, PTBD
			JSR clear_display
			JSR clear_display
			JSR clear_display
			
			MOV #$4D, $83			; Write 'M'
			JSR LCD_write
			
			MOV #$6F, $83			; Write 'o'
			JSR LCD_write
			
			MOV #$64, $83			; Write 'd'
			JSR LCD_write
			
			MOV #$65, $83			; Write 'e'
			JSR LCD_write
			
			MOV #$3A, $83			; Write ':'
			JSR LCD_write
			
			MOV #$20, $83			; Write ' '
			JSR LCD_write
			
			MOV #$41, $83			; Write 'A'
			JSR LCD_write
			
			MOV #$2C, $83			; Write ','
			JSR LCD_write
			
			MOV #$42, $83			; Write 'B'
			JSR LCD_write
			
			MOV #$3F, $83			; Write '?'
			JSR LCD_write
			
			JSR new_address
			JMP done
decode:

			; determine which button was pressed.
			;CLR PTBD
			;PTBDD_Upper_output
			;LDA $82
			;EOR #XOR_Mask			; Toggle Heartbeat LED
			;STA $82
			;MOV $82, PTBD
			;BSET 3, PTBD			; Clock Heartbeat LED


			LDA $70					; Load the pattern from memory
			CMP #%11100111			
			BEQ Mode_A			
			CMP #%11101011			
			BEQ Mode_B			
			JMP done
			
Mode_A:
			JSR off
			JMP ask_temp
			
Mode_B:
			JSR mode_b
			
			MOV #$01, PTBD
			BSET 3, PTBD
			NOP
			BCLR 3, PTBD
			
			MOV #0, $93
			
			JMP ask_temp

done:
			MOV #%11110111, $76		; return to reading from the keypad.
			JSR keypad_write
			JMP decode	
