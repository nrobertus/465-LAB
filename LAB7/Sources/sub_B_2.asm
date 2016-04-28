; Include derivative-specific definitions
            INCLUDE 'derivative.inc'


; export symbols
            XDEF sub_B_2
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on



            XREF __SEG_END_SSTACK, SUB_delay, b_mode, lcd_write, rtc_get_time,rtc_write_tod
			
			XREF  rtc_display_data,SUB_delay_cnt, PTBDD_Upper_output, lm92_write_lcd_C, rtc_set_time_zero
			
			XREF lm92_write_lcd_K, lm92_read_temp, i2c_start, i2c_rx_byte, i2c_tx_byte, i2c_stop, i2c_init
			
			XREF PTBDD_Upper_input, toggle_clock, delay, BF_check,  n, t, m, b, lcd_clear, lcd_char, rtc_init
			
			XREF lcd_goto_row1, lcd_goto_row0, led_write, led_data, keypad_get_keypress, lcd_goto_addr
			
			XREF B_1_output, sub_B_1_char1, sub_B_1_char2, Sec, lcd_num_to_char
			

MAX_TEMP EQU $32 ; 50 celcius 
;MAX_TEMP EQU $1E ; 30 celcius
; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition
			
			old_time: DS.B 1
			
			current_temp: DS.B 1
			
			seconds: DS.B 1

; code section
MyCode:     SECTION

print_heating:
		LDA #'H'
		JSR lcd_char

		LDA #'e'
		JSR lcd_char

		LDA #'a'
		JSR lcd_char

		LDA #'t'
		JSR lcd_char
		
		LDA #'i'
		JSR lcd_char
		
		LDA #'n'
		JSR lcd_char
		
		LDA #'g'
		JSR lcd_char
		
		;Turn on the heat
		MOV	#$02, led_data
		JSR led_write

		JMP sub_B_2_mid

print_cooling:

		LDA #'C'
		JSR lcd_char

		LDA #'o'
		JSR lcd_char

		LDA #'o'
		JSR lcd_char

		LDA #'l'
		JSR lcd_char
		
		LDA #'i'
		JSR lcd_char
		
		LDA #'n'
		JSR lcd_char
		
		LDA #'g'
		JSR lcd_char
		
		; Turn on the cool
		MOV	#$01, led_data
		JSR led_write

		JMP sub_B_2_mid
			

sub_B_2:

		JSR rtc_set_time_zero
		
		JSR lcd_clear
		
		LDA #'B'				
		JSR lcd_char

		LDA #':'				
		JSR lcd_char

		LDA #' '
		JSR lcd_char
		
		LDA b_mode
		CMP #$00
		BEQ print_cooling
		
		CMP #$01
		BEQ print_heating

sub_B_2_mid:

		

		LDA #' '
		JSR lcd_char

		LDA #'T'
		JSR lcd_char

		LDA #'='
		JSR lcd_char
		
		JSR rtc_display_data
		
		;LDA Sec+1
		;JSR lcd_num_to_char
		;JSR lcd_char
		
		;LDA Sec+0
		;JSR lcd_num_to_char
		;JSR lcd_char
		
		JSR lcd_goto_row1
		
		
		LDA #'T'
		JSR lcd_char
		
		LDA #'9'
		JSR lcd_char
		
		LDA #'2'
		JSR lcd_char
		
		LDA #':'
		JSR lcd_char
		
		LDA #' '
		JSR lcd_char
		
		
get_input:

		JSR keypad_get_keypress
		
		CMP #$0E
		BEQ return

		JSR Big_Delay
		
		JSR rtc_get_time
		
		CMP old_time
		BNE print_temp
		
		JMP get_input
		
print_temp:

		STA old_time
		
		LDA Sec+0
		LDX #$0A
		MUL
		ADD Sec+1
		
		STA seconds
		
		; Check to see if time is up
		CMP B_1_output
		BEQ return
		
		
		JSR Big_Delay
		
		JSR lcd_goto_row0
		
		LDA b_mode
		CMP #$00
		BEQ goto_print_cooling_time
		
		CMP #$01
		BEQ print_heating_time
		
print_temp_mid:
		
		JSR lcd_goto_row1
		
		LDA #$C6
		JSR lcd_goto_addr
		
		JSR lm92_read_temp
		
		STA current_temp
					
		JSR lm92_write_lcd_C
		
		LDA #'C'
		JSR lcd_char
		
		; Check to see if temp is maxed
		LDA current_temp
		CMP #MAX_TEMP
		BEQ return
		
		JMP get_input
		
		
return:
		; turn off the heater/cooler
		MOV	#$00, led_data
		JSR led_write
		
		RTS
		
goto_print_cooling_time:
		JMP print_cooling_time

print_heating_time:
		LDA #'B'
		JSR lcd_char
		
		LDA #':'
		JSR lcd_char
		
		LDA #' '
		JSR lcd_char
		
		LDA #'H'
		JSR lcd_char

		LDA #'e'
		JSR lcd_char

		LDA #'a'
		JSR lcd_char

		LDA #'t'
		JSR lcd_char
		
		LDA #'i'
		JSR lcd_char
		
		LDA #'n'
		JSR lcd_char
		
		LDA #'g'
		JSR lcd_char
		
		LDA #' '
		JSR lcd_char
		
		LDA #'T'
		JSR lcd_char
		
		LDA #'='
		JSR lcd_char
		
		LDA Sec+0
		JSR lcd_num_to_char
		JSR lcd_char
		
		LDA Sec+1
		JSR lcd_num_to_char
		JSR lcd_char
		
		LDA #' '
		JSR lcd_char
		
		JMP print_temp_mid

print_cooling_time:
		LDA #'B'
		JSR lcd_char
		
		LDA #':'
		JSR lcd_char
		
		LDA #' '
		JSR lcd_char
		
		LDA #'C'
		JSR lcd_char

		LDA #'o'
		JSR lcd_char

		LDA #'o'
		JSR lcd_char

		LDA #'l'
		JSR lcd_char
		
		LDA #'i'
		JSR lcd_char
		
		LDA #'n'
		JSR lcd_char
		
		LDA #'g'
		JSR lcd_char
		
		LDA #' '
		JSR lcd_char
		
		LDA #'T'
		JSR lcd_char
		
		LDA #'='
		JSR lcd_char
		
		LDA Sec+0
		JSR lcd_num_to_char
		JSR lcd_char
		
		LDA Sec+1
		JSR lcd_num_to_char
		JSR lcd_char
		
		LDA #' '
		JSR lcd_char
		
		JMP print_temp_mid
		
Delay:
	MOV b, m
	top:
			DEC t
			BEQ done
			MOV m, b
	bottom:
			DEC b
			BEQ top
			BRA bottom			
	done:			
			RTS

Big_Delay:
	;Little delay, so as not to flood the clock
		MOV #16, t				; 4 us delay
		MOV #16, b
		JSR Delay
		MOV #16, t				; 4 us delay
		MOV #16, b
		JSR Delay
		MOV #16, t				; 4 us delay
		MOV #16, b
		JSR Delay
		MOV #16, t				; 4 us delay
		MOV #16, b
		JSR Delay
		RTS 
		
Bigger_Delay:
		JSR Big_Delay
		JSR Big_Delay
		JSR Big_Delay
		JSR Big_Delay
		JSR Big_Delay
		JSR Big_Delay
		JSR Big_Delay
		JSR Big_Delay
		JSR Big_Delay
		JSR Big_Delay
		RTS

Biggest_Delay:
		JSR Bigger_Delay
		JSR Bigger_Delay
		JSR Bigger_Delay
		JSR Bigger_Delay
		JSR Bigger_Delay
		JSR Bigger_Delay
		JSR Bigger_Delay
		JSR Bigger_Delay
		JSR Bigger_Delay
		JSR Bigger_Delay
		RTS
