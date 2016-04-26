; Include derivative-specific definitions
            INCLUDE 'derivative.inc'


; export symbols
            XDEF sub_B_1
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on



            XREF __SEG_END_SSTACK,SUB_delay, b_mode, lcd_write, rtc_get_time,rtc_write_tod, rtc_display_data,SUB_delay_cnt, PTBDD_Upper_output, lm92_write_lcd_C, lm92_write_lcd_K, lm92_read_temp, i2c_start, i2c_rx_byte, i2c_tx_byte, i2c_stop, PTBDD_Upper_input, toggle_clock, delay, BF_check,  n, t, m, b, lcd_clear, lcd_char, lcd_goto_row1, lcd_goto_row0, led_write, led_data, keypad_get_keypress, lcd_goto_addr  ; symbol defined by the linker for the end of the stack


; variable/data section
MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition

			
			input: DS.B 1 ; input value
			
			char_in: DS.B 1
			
			digit1: DS.B 1;
			
			digit2: DS.B 1;
			
			char1: DS.B 1;
			
			char2: DS.B 1;
			
			output: DS.B 1;

; code section
MyCode:     SECTION
main:
_Startup:
            LDHX   #__SEG_END_SSTACK ; initialize the stack pointer
            TXS
			CLI			; enable interrupts
			
			MOV #$FF, digit1
			
			MOV #$FF, digit2
			
			MOV #$20, char1
			
			MOV #$20, char2
			
			

sub_B_1:

		
		
		JSR lcd_clear
			
		LDA #'T'				
		JSR lcd_char

		LDA #'i'				
		JSR lcd_char

		LDA #'m'
		JSR lcd_char

		LDA #'e'
		JSR lcd_char

		LDA #' '
		JSR lcd_char

		LDA #'i'
		JSR lcd_char

		LDA #'n'
		JSR lcd_char

		LDA #' '
		JSR lcd_char

		LDA #'s'
		JSR lcd_char

		LDA #'e'
		JSR lcd_char
		
		LDA #'c'
		JSR lcd_char
		
		LDA #'o'
		JSR lcd_char
		
		LDA #'n'
		JSR lcd_char
		
		LDA #'d'
		JSR lcd_char
		
		LDA #'s'
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

		LDA #'0'
		JSR lcd_char

		LDA #'-'
		JSR lcd_char

		LDA #'1'
		JSR lcd_char

		LDA #'8'
		JSR lcd_char
		
		LDA #'0'
		JSR lcd_char
		
		LDA #':'
		JSR lcd_char
		

		
		
		
		
sub_B_1_input:
		
		JSR keypad_get_keypress
		
		CMP #$0E
		BEQ return
		
		CMP #$0F
		BEQ input_done
		
		CMP #$0A
		BEQ sub_B_1_input
		
		CMP #$0B
		BEQ sub_B_1_input
		
		CMP #$0C
		BEQ sub_B_1_input
		
		CMP #$0D
		BEQ sub_B_1_input
		
		; At this point, it has to be numeric input. 
		
		CMP #$00
		BEQ _0
		
		CMP #$01
		BEQ _1
		
		CMP #$02
		BEQ _2
		
		CMP #$03
		BEQ _3
		
		CMP #$04
		BEQ _4
		
		CMP #$05
		BEQ _5
		
		CMP #$06
		BEQ _6
		
		CMP #$07
		BEQ _7
		
		CMP #$08
		BEQ _8
		
		CMP #$09
		BEQ _9
		
		JMP sub_B_1_input


		
return:
		RTS
		
input_done:

		RTS
_0:
	MOV #$00, input
	MOV #$30, char_in
	JMP set_digits
_1:
	MOV #$01, input
	MOV #$31, char_in
	JMP set_digits
_2:
	MOV #$02, input
	MOV #$32, char_in
	JMP set_digits
_3:
	MOV #$03, input
	MOV #$33, char_in
	JMP set_digits
_4:
	MOV #$04, input
	MOV #$34, char_in
	JMP set_digits
_5:	
	MOV #$05, input
	MOV #$35, char_in
	JMP set_digits
_6:
	MOV #$06, input
	MOV #$36, char_in
	JMP set_digits
_7:
	MOV #$07, input
	MOV #$37, char_in
	JMP set_digits
_8:
	MOV #$08, input
	MOV #$38, char_in
	JMP set_digits
_9:
	MOV #$09, input
	MOV #$39, char_in
	JMP set_digits
	
set_digits:
		LDA digit1
		CMP #$FF
		BEQ set_digit_1
		LDA digit2
		CMP #$FF
		BEQ set_digit_2
		JSR roll_digits
		
		LDA #$CD
		JSR lcd_goto_addr
		LDA char2
		JSR lcd_char
		LDA char1
		JSR lcd_char
	
set_digit_1:
		MOV input, digit1
		MOV char_in, char1
		JMP sub_B_1_input

set_digit_2:
		MOV input, digit2
		MOV char_in, char2
		JMP sub_B_1_input
		
roll_digits:
		MOV digit1, digit2
		MOV char1, char2
		MOV input, digit1
		MOV char_in, char1
		RTS

		
