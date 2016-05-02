; Include derivative-specific definitions
            INCLUDE 'derivative.inc'


; export symbols
            XDEF _Startup, main, n, t, m, b, i_temp, XOR_Mask, SUB_delay, SUB_delay_cnt
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on



            XREF __SEG_END_SSTACK, keypad_get_keypress, lm92_init, lm92_read_temp, lm92_write_lcd_C, lcd_init, lcd_clear, lcd_write, lcd_char, mode_0, mode_1, mode_2, i2c_init, rtc_init, rtc_set_time_zero ; symbol defined by the linker for the end of the stack
			
			XREF cont_mode_0, cont_mode_1, cont_mode_2

; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition

            n: EQU $7C
            t: EQU $71
            m: EQU $72
            b: EQU $73
            prev_input: EQU $89
            i_temp: EQU $74
            XOR_Mask: EQU %00010000
            SUB_delay_cnt:		DS.B	3


; code section
MyCode:     SECTION
main:
_Startup:

            LDHX   #__SEG_END_SSTACK ; initialize the stack pointer
            TXS
			CLI			; enable interrupts

			LDA SOPT1
            ORA #%00000001	;enable reset switch
            AND #%01111111	;disable watchdog
            STA SOPT1

            BSET 0, PTADD			; Set data direction for port A to outputs.
  			BSET 1, PTADD
  			BSET 2, PTADD
  			BCLR 2, PTADD
  			BCLR 2, PTAD			; Clear all of port A
  			BCLR 3, PTAD
  			BCLR 4, PTAD
  			BCLR 5, PTAD
  			MOV #$FF, PTBDD			; set data direction for port B
  			MOV #%00000000, $82		; initial heartbeat LED.


  			MOV #$01, PTBD
  			BSET 3, PTBD
  			BCLR 3, PTBD

  			MOV #0, $95
  			MOV #0, $96
  			MOV #$30, $97

  			MOV #%10111110, $A0

        	JSR lcd_init
        	
        	JSR lcd_clear
        	
			JSR		i2c_init
			
			JSR		rtc_init		
			
			JSR		lm92_init
        	
        	JSR mode_0

main_function:
			
			JSR keypad_get_keypress 
			
			;LDA $70 ; The result will be in the accumulator
			CMP #$00		
			BEQ goto_mode_0		
			CMP #$01	
			BEQ goto_mode_1
			CMP #$02
			BEQ goto_mode_2
			
			LDA prev_input
			CMP #$00		
			BEQ continue_mode_0		
			CMP #$01			
			BEQ continue_mode_1
			CMP #$02
			BEQ continue_mode_2
			
    		JMP main_function
    		
goto_mode_0:
		STA prev_input
		JSR rtc_set_time_zero
		JSR mode_0
		JMP main_function

goto_mode_1:
		STA prev_input
		JSR rtc_set_time_zero
		JSR mode_1
		JMP main_function

goto_mode_2:
		STA prev_input
		JSR rtc_set_time_zero
		JSR mode_2
		JMP main_function
		
continue_mode_0:
		JSR cont_mode_0
		JMP main_function

continue_mode_1:
		JSR cont_mode_1
		JMP main_function

continue_mode_2:
		JSR cont_mode_2
		JMP main_function

SUB_delay:
			; save the existing values of registers
			PSHH
			PSHX
			PSHA
			
			; load address of SUB_delay_cnt
			LDHX #SUB_delay_cnt
			
SUB_delay_loop_0:

			feed_watchdog
			
			; if byte[0] == 0
			LDA 	0, X
			BEQ		SUB_delay_loop_1		; jump to SUB_delay_outer_loop
			
			;else
			DECA							; decrement byte[0]
			STA		0, X
			
			;repeat
			BRA SUB_delay_loop_0
			
SUB_delay_loop_1:

			; if byte[1] == 0
			LDA 	1, X
			BEQ		SUB_delay_loop_2		; branch to done
			
			;else
			DECA							; decrement byte[1]
			STA		1, X
			 
			LDA		#$FF					; reset byte[0]
			STA		0,X
			
			;repeat
			BRA SUB_delay_loop_0	
			
SUB_delay_loop_2:

			; if byte[2] == 0
			LDA 	2, X
			BEQ		SUB_delay_done			; branch to done
			
			;else
			DECA							; decrement byte[2]
			STA		4, X
			 
			LDA		#$FF					; reset byte[1]
			STA		2, X
			LDA		#$FF					; reset byte[0]
			STA		0, X
			
			;repeat
			BRA SUB_delay_loop_0	
			
SUB_delay_done:
			
			; restore registers to previous values 
			PULA
			PULX
			PULH

			RTS