; Include derivative-specific definitions
            INCLUDE 'derivative.inc'


; export symbols
            XDEF menu_B, b_mode
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on



            XREF __SEG_END_SSTACK,SUB_delay, sub_B_1,lcd_write, rtc_get_time,rtc_write_tod, rtc_display_data,SUB_delay_cnt, PTBDD_Upper_output, lm92_write_lcd_C, lm92_write_lcd_K, lm92_read_temp, i2c_start, i2c_rx_byte, i2c_tx_byte, i2c_stop, PTBDD_Upper_input, toggle_clock, delay, BF_check,  n, t, m, b, lcd_clear, lcd_char, lcd_goto_row1, lcd_goto_row0, led_write, led_data, keypad_get_keypress  ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition
			
			input: DS.B 1 ; input value
			
			b_mode: DS.B 1


; code section
MyCode:     SECTION
main:
_Startup:
            LDHX   #__SEG_END_SSTACK ; initialize the stack pointer
            TXS
			CLI			; enable interrupts

menu_B:
		MOV #$FF, b_mode
		
		JSR lcd_clear
		LDA #'B'				
		JSR lcd_char

		LDA #':'				
		JSR lcd_char

		LDA #' '
		JSR lcd_char

		LDA #'T'
		JSR lcd_char

		LDA #'E'
		JSR lcd_char

		LDA #'C'
		JSR lcd_char

		LDA #' '
		JSR lcd_char

		LDA #'f'
		JSR lcd_char

		LDA #'u'
		JSR lcd_char

		LDA #'n'
		JSR lcd_char
		
		LDA #'c'
		JSR lcd_char
		
		LDA #'t'
		JSR lcd_char
		
		LDA #'i'
		JSR lcd_char
		
		LDA #'o'
		JSR lcd_char
		
		LDA #'n'
		JSR lcd_char
		
		LDA #'?'
		JSR lcd_char
		
		JSR lcd_goto_row1
		
		LDA #'1'				
		JSR lcd_char

		LDA #' '				
		JSR lcd_char

		LDA #'-'
		JSR lcd_char

		LDA #'H'
		JSR lcd_char

		LDA #'e'
		JSR lcd_char

		LDA #'a'
		JSR lcd_char

		LDA #'t'
		JSR lcd_char

		LDA #','
		JSR lcd_char

		LDA #' '
		JSR lcd_char

		LDA #'0'
		JSR lcd_char
		
		LDA #' '
		JSR lcd_char
		
		LDA #'-'
		JSR lcd_char
		
		LDA #'C'
		JSR lcd_char
		
		LDA #'o'
		JSR lcd_char
		
		LDA #'o'
		JSR lcd_char
		
		LDA #'l'
		JSR lcd_char
		
menu_B_input:
		JSR keypad_get_keypress
		
		CMP #$0E
		BEQ return
		
		CMP #$0F
		BEQ check_sub_b
		
		;If it gets to here, it has to be numerical or the # symbol
		
		CMP #$00 ; User entered a 0
		BEQ _0_pressed
		
		CMP #$01 ; User entered a 1
		BEQ _1_pressed

		
		JMP menu_B_input

_0_pressed:

		MOV #$00, b_mode
		
		JMP menu_B_input
		
		

_1_pressed:

		MOV #$01, b_mode
		
		JMP menu_B_input


check_sub_b:
		LDA b_mode
		
		CMP #$01
		BEQ goto_sub_b
		
		CMP #$00
		BEQ goto_sub_b
		
		JMP menu_B_input
		
goto_sub_b:
		
		JSR sub_B_1
		
		JMP menu_B
		
return:
		RTS
