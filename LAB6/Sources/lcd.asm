; Include derivative-specific definitions
            INCLUDE 'MC9S08QG8.inc'
            
; export symbols
            XDEF lcd_init, lcd_write, lcd_char, lcd_str, lcd_num_to_char, lcd_clear, lcd_goto_addr, lcd_goto_row0, lcd_goto_row1 
            XDEF lcd_data, lcd_char_data, lcd_col_idx
            
; import symbols
			XREF SUB_delay, SUB_delay_cnt
			XREF bus_read, bus_write, bus_addr, bus_data


; variable/data section
MY_ZEROPAGE: SECTION  SHORT

			lcd_data:		DS.B	1	; lower 4 bits = LCD data lines, bit 6 = RS, bit 5 = RW
			lcd_char_data:	DS.B	1	; used by lcd_char subroutine to store a character
			lcd_col_idx:	DS.B	1	; index of the column of the LCD that the cursor is currently in
			
			lcd_addr:		DS.B	1	; holds an address for lcd_goto_addr 
			
			str_length:		DS.B	1	; holds the offset into a string for lcd_str
			
; code section
MyCode:     SECTION

lcd_init:
			; preserve registers
			PSHA

;*** init RS and RW pins as outputs
			LDA		PTADD
			ORA		#$03
			STA		PTADD			
						
;*** wait for 15 ms
			; load address of SUB_delay_cnt
			LDHX #SUB_delay_cnt
			
			; configure loop delays: 0x001388 = 20 ms
			LDA		#$00
			STA		2,X
			LDA		#$13
			STA		1,X
			LDA		#$88
			STA		0,X
			
			; jump to the delay loop
			JSR		SUB_delay


;*** Send Init Command	

			LDA		#$03
			JSR		lcd_write
			
;*** Wait for 4.1 ms
			; load address of SUB_delay_cnt
			LDHX #SUB_delay_cnt
			
			; configure loop delays: 0x001388 = 20 ms
			LDA		#$00
			STA		2,X
			LDA		#$13
			STA		1,X
			LDA		#$88
			STA		0,X
			
			; jump to the delay loop
			JSR		SUB_delay


;*** Send Init command
			
			LDA		#$03
			JSR		lcd_write
			

;*** Wait for 100 us
			; load address of SUB_delay_cnt
			LDHX #SUB_delay_cnt
			
			; configure loop delays: 0x001388 = 20 ms
			LDA		#$00
			STA		2,X
			LDA		#$13
			STA		1,X
			LDA		#$88
			STA		0,X
			
			; jump to the delay loop
			JSR		SUB_delay


;*** Send Init command

			LDA		#$03
			JSR		lcd_write
			
;*** Send Function set command

			LDA		#$02
			JSR		lcd_write

			LDA		#$02
			JSR		lcd_write

			LDA		#$08
			JSR		lcd_write


;*** Send display ctrl command

			LDA		#$00
			JSR		lcd_write

			LDA		#$0C
			JSR		lcd_write

;*** Send display clear command

			LDA		#$00
			JSR		lcd_write
			
;*** Wait for 5 ms
			; load address of SUB_delay_cnt
			LDHX #SUB_delay_cnt
			
			; configure loop delays: 0x001388 = 20 ms
			LDA		#$00
			STA		2,X
			LDA		#$13
			STA		1,X
			LDA		#$88
			STA		0,X
			
			; jump to the delay loop
			JSR		SUB_delay

;*** Send display clear command

			LDA		#$01
			JSR		lcd_write
			
;*** Wait for 5 ms
			; load address of SUB_delay_cnt
			LDHX #SUB_delay_cnt
			
			; configure loop delays: 0x001388 = 20 ms
			LDA		#$00
			STA		2,X
			LDA		#$13
			STA		1,X
			LDA		#$88
			STA		0,X
			
			; jump to the delay loop
			JSR		SUB_delay


;*** Send entry mode command

			LDA		#$00
			JSR		lcd_write

			LDA		#$06
			JSR		lcd_write

;*** done ***
            
			; restore registers
			PULA
			
			; return from subroutine lcd_init
			RTS

lcd_write:
			; preserve HX register
			PSHH
			PSHX

			; store param to var for latter
			STA		lcd_data

			; clear RS and RW pins on PTAD
			LDA 	PTAD
			AND		#$FC
			STA		PTAD

			; put RS an RW on PTAD
			LDA		lcd_data
			NSA
			AND 	#$03
			ORA		PTAD
			STA		PTAD
			
			; prep bus data
			LDA		lcd_data
			AND		#$0F
			STA		bus_data						
			; prep bus addr
			LDA		#$04
			STA		bus_addr			
			; write data to bus (and clock the addr)
			JSR		bus_write		
			
			
;*** Wait for 40 us
			; load address of SUB_delay_cnt
			LDHX #SUB_delay_cnt
			
			; configure loop delays: 0x00000A = 40 us
			LDA		#$00
			STA		2,X
			LDA		#$00
			STA		1,X
			LDA		#$0A
			STA		0,X
			
			; jump to the delay loop
			JSR		SUB_delay
			
			; restore HX register
			PULX
			PULH

			; done
			RTS

lcd_char:
			; preserve registers
			PSHH
			PSHX
			
			; save data
			STA		lcd_char_data

			; write upper nibble
			NSA
			AND		#$0F
			ORA		#$20
			JSR		lcd_write
			
			; write lower nibble
			LDA		lcd_char_data
			AND		#$0F
			ORA		#$20
			JSR		lcd_write
			
;*** Wait for 1 ms ***
			LDHX #SUB_delay_cnt

			; configure loop delays: 0x0000FA = 1 ms
			LDA		#$00
			STA		2,X
			LDA		#$00
			STA		1,X
			LDA		#$FA
			STA		0,X

			; jump to the delay loop
			JSR		SUB_delay				
			
			; done
			PULX
			PULH
			RTS

lcd_str:
			; save str length
			STA		str_length

lcd_str_loop:
			; get data
			LDA		0,X
			
			; write data to lcd
			JSR		lcd_char
			
			; increament lower byte X
			PSHX
			PULA
			ADD		#01
			PSHA
			PULX
			
			; increment upper byte H
			PSHH
			PULA
			ADC		#$00
			PSHA
			PULH
			
			; decrement str_length
			LDA		str_length
			DECA
			STA		str_length
			
			; repeat if length != 0
			BNE		lcd_str_loop

lcd_str_done:

			RTS

lcd_num_to_char:
			; Add 0x30
			ADD		#$30
			RTS

lcd_clear:
						
;*** Wait for 20 ms ***
			LDHX #SUB_delay_cnt
			
			; configure loop delays: 0x001388 = 20 ms
			LDA		#$00
			STA		2,X
			LDA		#$13
			STA		1,X
			LDA		#$88
			STA		0,X
			
			; jump to the delay loop
			JSR		SUB_delay
								
			; Send display clear command
			LDA		#$00
			JSR		lcd_write
			LDA		#$01
			JSR		lcd_write
						
;*** Wait for 20 ms ***
			LDHX #SUB_delay_cnt
			
			; configure loop delays: 0x001388 = 20 ms
			LDA		#$00
			STA		2,X
			LDA		#$13
			STA		1,X
			LDA		#$88
			STA		0,X
			
			; jump to the delay loop
			JSR		SUB_delay

			; done
			RTS
			
lcd_goto_addr:

			; store addr
			STA		lcd_addr

			; write upper nibble
			NSA
			AND		#$0F
			JSR		lcd_write
			
			; write lower nibble			
			LDA		lcd_addr
			AND		#$0F
			JSR		lcd_write

			RTS
			
lcd_goto_row0:

			; go back to first column and row of LCD
			LDA		#$08
			JSR		lcd_write
			LDA		#$00
			JSR		lcd_write
			
			RTS

lcd_goto_row1:

			; go back to first column and row of LCD
			LDA		#$0C
			JSR		lcd_write
			LDA		#$00
			JSR		lcd_write

			RTS


