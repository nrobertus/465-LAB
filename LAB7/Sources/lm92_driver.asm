; EQU statements

LM92_ADDR_W 		EQU $90 	; Slave address to write to LM92
LM92_ADDR_R 		EQU $91 	; Slave address to read from LM92

LM92_REG_TEMP		EQU	$00		; register address of the temperature register
LM92_REG_MFGID		EQU $07
LM92_REG_CFG		EQU $01 

; Include derivative-specific definitions
            INCLUDE 'MC9S08QG8.inc'
            
; export symbols
            XDEF lm92_init, lm92_read_temp, lm92_write_lcd_K, lm92_write_lcd_C
            
; import symbols
			XREF i2c_init, i2c_start, i2c_stop, i2c_tx_byte, i2c_rx_byte, i2c_rx_byte_nack, i2c_bit_delay
			
			XREF lcd_init, lcd_write, lcd_char, lcd_str, lcd_num_to_char, lcd_clear, lcd_goto_addr, lcd_goto_row0, lcd_goto_row1
			            


; variable/data section
MY_ZEROPAGE: SECTION  SHORT

			Temp_Data_Raw:		DS.B	2
			
			Temp_c:				DS.B	1			
			temp_k:				DS.B	1			

MY_CONST: SECTION
; Constant Values and Tables Section
			
			;str_date:			DC.B 	"Date is "	
			;str_date_length:	DC.B	8
			
			
; code section
MyCode:     SECTION

lm92_init:
			; nothing to see here			
			RTS

lm92_read_temp:
		

			; start condition
			JSR		i2c_start
			
			; send lm92 write addr
			LDA		#LM92_ADDR_W
			JSR 	i2c_tx_byte
			
			; send register address
			LDA		#LM92_REG_TEMP
			JSR 	i2c_tx_byte
			
			; stop condition
			JSR		i2c_stop
			
			JSR i2c_bit_delay
			JSR i2c_bit_delay
			
			; start condition
			JSR		i2c_start
			
			; send rtc read addr
			LDA		#LM92_ADDR_R
			JSR 	i2c_tx_byte
			
			; read byte
			LDA		#$01			; ack the byte			
			JSR		i2c_rx_byte	
			STA		Temp_Data_Raw+0
			
			
			; read byte
			LDA		#$00			; nack the byte			
			JSR		i2c_rx_byte	
			STA		Temp_Data_Raw+1
			
			; stop condition
			
			JSR 	i2c_bit_delay
			
			JSR		i2c_stop
			
			; divide by 16 to convert to degrees C
			LDHX	Temp_Data_Raw+0
			LDX		#$80
			LDA		Temp_Data_Raw+1
			
			DIV		; A <- (H:A)/(X)
			
			STA		Temp_c

			; done			
			RTS

lm92_write_lcd_K:

			LDA		Temp_c
			
			; temp >= 27 C == 300 K?
			CMP		#$1B
			BLO		k_small

k_big:
			; convert to K
			SUB		#$1B
			STA		temp_k

			; write 3 for 300K
			LDA		#'3'
			JSR		lcd_char
			BRA		cont

k_small:
			; convert to K
			ADD		#$49
			STA		temp_k

			; write 2 for 200K
			LDA		#'2'
			JSR		lcd_char

cont:
			LDA		temp_k

			; write upper number to LCD
			LDHX	#$000A
			DIV						; A <= (H:A)/(X), H <= (remainder)

			; convert to ASCII char
			JSR		lcd_num_to_char

			; write to LCD
			JSR		lcd_char

			; move remainder from H to A
			PSHH
			PULA

			; convert to ASCII char
			JSR		lcd_num_to_char

			; write to LCD
			JSR		lcd_char
			
			
			; done
			RTS

lm92_write_lcd_C:

			LDA		Temp_c

			; write upper number to LCD
			LDHX	#$000A
			DIV						; A <= (H:A)/(X), H <= (remainder)

			; convert to ASCII char
			JSR		lcd_num_to_char

			; write to LCD
			JSR		lcd_char

			; move remainder from H to A
			PSHH
			PULA

			; convert to ASCII char
			JSR		lcd_num_to_char

			; write to LCD
			JSR		lcd_char
			
			
			; done
			RTS





