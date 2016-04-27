; Include derivative-specific definitions
            INCLUDE 'derivative.inc'


; export symbols
            XDEF menu_A
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on



            XREF __SEG_END_SSTACK, SUB_delay, b_mode, lcd_write, rtc_get_time,rtc_write_tod
			
			XREF  rtc_display_data,SUB_delay_cnt, PTBDD_Upper_output, lm92_write_lcd_C
			
			XREF lm92_write_lcd_K, lm92_read_temp, i2c_start, i2c_rx_byte, i2c_tx_byte, i2c_stop
			
			XREF PTBDD_Upper_input, toggle_clock, delay, BF_check,  n, t, m, b, lcd_clear, lcd_char
			
			XREF lcd_goto_row1, lcd_goto_row0, led_write, led_data, keypad_get_keypress, lcd_goto_addr


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition

; code section
MyCode:     SECTION
		
menu_A:
		JSR lcd_clear
		LDA #'E'				
		JSR lcd_char

		LDA #'n'				
		JSR lcd_char

		LDA #'t'
		JSR lcd_char

		LDA #'e'
		JSR lcd_char

		LDA #'r'
		JSR lcd_char

		LDA #' '
		JSR lcd_char

		LDA #'T'
		JSR lcd_char

		LDA #'s'
		JSR lcd_char

		LDA #'e'
		JSR lcd_char

		LDA #'t'
		JSR lcd_char
		
		LDA #'?'
		JSR lcd_char
		
		JSR lcd_goto_row1
		
		LDA #'E'				
		JSR lcd_char

		LDA #'n'				
		JSR lcd_char

		LDA #'t'
		JSR lcd_char

		LDA #'e'
		JSR lcd_char

		LDA #'r'
		JSR lcd_char

		LDA #' '
		JSR lcd_char

		LDA #'1'
		JSR lcd_char

		LDA #'0'
		JSR lcd_char

		LDA #'-'
		JSR lcd_char

		LDA #'4'
		JSR lcd_char
		
		LDA #'0'
		JSR lcd_char
		
		LDA #' '
		JSR lcd_char
		
		LDA #'C'
		JSR lcd_char

menu_A_input:

		JSR keypad_get_keypress ; Return in the accumulator
		
		CMP #$0E
		BEQ return
		
		JMP menu_A_input

return:
		RTS