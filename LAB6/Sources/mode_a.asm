			INCLUDE 'derivative.inc'
            
			XDEF mode_a, off
			
			XREF main, n, b, t, Delay, Tset, keypad_write, display, XOR_Mask, LCD_write, new_address, clear_display, Seconds, display_a
            
MY_ZEROPAGE: SECTION  SHORT
			
			device_1: EQU $78
			word_address: EQU $79
			device_read_1: EQU $7A 
			bit_mask: EQU $7B
			
			Tread1: EQU $60
			Tread2: EQU $61
			
MyCode:     SECTION
mode_a:

			MOV #8, n
			MOV #$D0, device_1
			MOV #$00, word_address
			MOV #$D1, device_read_1
			MOV #$80, bit_mask
			
			JSR Start
			MOV device_1, $9F
			JSR Write_address
			MOV word_address, $9F
			JSR Write_address
			MOV #$01, $9F
			JSR Write_address
			JSR Stop
			
			MOV #0, $95				; rollover registers
			MOV #0, $96
			MOV #$30, $97
			
			RTS

off:
			MOV #8, n
			JSR Start				; start condition
			MOV #$90, $9F
			JSR Write_address		; write the address
			
			JSR read_data			; read first byte
			STA $60
			JSR acknowledge_in		; acknowledge
			JSR read_data			; read second byte
			STA $61
			JSR not_acknowledge		; send not acknowledge
			JSR Stop				; stop i2c
			
			JSR convert				; convert the temperature to 1 byte
			
			JSR display_off			; display
			
			JMP keypad	
keypad:
			; heartbeat LED
			CLR PTBD
			PTBDD_Upper_output
			LDA $82
			EOR #XOR_Mask			; Toggle Heartbeat LED
			STA $82
			MOV $82, PTBD
			BSET 3, PTBD			; Clock Heartbeat LED
			NOP
			BCLR 3, PTBD
			
			MOV #0, t				; 4 us delay
			MOV #0, b
			JSR Delay
			MOV #0, t				; 4 us delay
			MOV #0, b
			JSR Delay
			MOV #0, t				; 4 us delay
			MOV #0, b
			JSR Delay
			MOV #0, t				; 4 us delay
			MOV #0, b
			JSR Delay
			
			CLR PTBD
			PTBDD_Upper_output
			LDA $82
			EOR #XOR_Mask			; Toggle Heartbeat LED
			STA $82
			MOV $82, PTBD
			BSET 3, PTBD			; Clock Heartbeat LED
			NOP
			BCLR 3, PTBD
			
			MOV $A0, $70
			
			MOV #%11110111, $76		; return to reading from the keypad.
			JSR keypad_write
			LDA $70
			CMP #%01111110
			BEQ return
			CMP #%10111110
			BEQ zero
			CMP #%01110111
			BEQ one
			CMP #%10110111
			BEQ two
two:
			PTBDD_Upper_output
			; D1 is cool
			MOV #%00100001, PTBD	; set cool bit
			BSET 3, PTBD			; rising edge clock
			
			NOP						; nop
			
			BCLR 3, PTBD			; clear clock line
			
			MOV $70, $A0

			BRSET 4, $93, reset
			JMP heat_cool

one:
			PTBDD_Upper_output
			; D0 is heat
			MOV #%00010001, PTBD	; set heat bit
			BSET 3, PTBD			; rising edge clock
			
			NOP						; nop
			
			BCLR 3, PTBD			; clear clock line
			
			MOV $70, $A0
			
			BRSET 5, $93, reset
			JMP heat_cool
			
zero:
			PTBDD_Upper_output
			; D1 is cool
			MOV #%00000001, PTBD	; clear bits
			BSET 3, PTBD			; rising edge clock
			
			NOP						; nop
			
			BCLR 3, PTBD			; clear clock line
			
			MOV $70, $A0
			
			JSR mode_a

			JMP off

return:
			PTBDD_Upper_output
			MOV #$01, PTBD
			BSET 3, PTBD
			NOP
			BCLR 3, PTBD
			RTS
			
reset:

			JSR mode_a
			MOV PTBD, $93
			JMP keypad

heat_cool:

			; initializations
			MOV PTBD, $93
			MOV #$90, device_1
			MOV #$00, word_address
			MOV #$91, device_read_1
			MOV #$80, bit_mask
			MOV #8, n
			
			; first write
			JSR Start				; start condition
			MOV device_read_1, $9F	; device address with read bit
			JSR Write_address		; write sub
			
			; temperature read
			JSR read_data			; read sub
			STA $60
			JSR acknowledge_in		; send acknowledge
			JSR read_data			; read second byte from I2C
			STA $61
			JSR not_acknowledge		; send not acknowledge
			JSR Stop				; stop
			
			; second initialization
			MOV #$D0, device_1
			MOV #$00, word_address
			MOV #$D1, device_read_1
			
			; second write
			JSR Start				; start
			MOV device_1, $9F		; device address with write bit
			JSR Write_address		; write sub
			MOV word_address, $9F	; word address
			JSR Write_address		; write sub
			JSR Start				; repeated start
			MOV device_read_1, $9F	; device address with read bit
			JSR Write_address		; write sub
			
			; seconds read
			JSR read_data			; read sub
			STA Seconds				; seconds
			
			CMP #0
			BEQ inc_sec
			JMP rest
inc_sec:
			LDA #%01100000
			ADD $95
			DAA
			STA $95
			
			MOV #0, t				; 4 us delay
			MOV #0, b
			JSR Delay
			
			MOV #0, t				; 4 us delay
			MOV #0, b
			JSR Delay
			
			MOV #200, t				; 4 us delay
			MOV #200, b
			JSR Delay
rest:
			
			JSR convert				; convert the temperature to 1 byte

			
			JSR display_a			; jump to the display sequence
			
			JMP keypad

Start:
			BSET 2, PTADD			; set as output
			BSET 3, PTADD			; set as output
			BSET 2, PTAD			; data line = 1
			BSET 3, PTAD			; clock line =1
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BCLR 2, PTAD			; data line low
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BCLR 3, PTAD			; bring clock line low
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			RTS
Write_address:
			BSET 2, PTADD			; set data as output
			LDA bit_mask			; load bit_mask
			AND $9F					; and it with address
			BEQ write_low_ad		; write low if zero
			BRA write_high_ad		; write high if one
write_low_ad:
			BCLR 2, PTAD			; data line low
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BSET 3, PTAD			; clock line high
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BCLR 3, PTAD			; clock line low
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			BCLR 2, PTAD			; clear data
			DEC n					; decrement counter
			JMP check_n_ad			; check if bit counter is 8
write_high_ad:
			BSET 2, PTAD			; data line high
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BSET 3, PTAD			; clock line high
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BCLR 3, PTAD			; clock line low
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			BCLR 2, PTAD			; clear data
			DEC n					; decrement counter
			JMP check_n_ad			; check if bit counter is 8
check_n_ad:
			LDA #0					; load 0
			CMP n					; compare to counter
			BEQ acknowledge			; if n = 0, branch to acknowledge
			LSR bit_mask			; otherwise lsr bit_mask
			JMP Write_address		; loop back to write next bit
acknowledge:
			BCLR 2, PTADD			; set data line as input
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BSET 3, PTAD			; Set the clock line
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			MOV PTAD, $90
			
			BCLR 3, PTAD			; Clear the clock line
			MOV #$80, bit_mask
			
			BRCLR 2, $90, done
			JMP error 
done:
			MOV #8, n
			RTS
error:
			SEI
			STOP
read_data:
			BCLR 2, PTADD			; release control of data line
			
			MOV #16, t				; 4 us delay
			MOV #2, b
			JSR Delay
			
			BSET 3, PTAD			; clock in data
			
			MOV #16, t				; 4 us delay
			MOV #2, b
			JSR Delay
			
			MOV PTAD, $91			; move data into $91
			BCLR 3, PTAD			; clear clock
			
			BRCLR 2, $91, Clear_Carry	; if bit is 0, write zero
			BRSET 2, $91, Set_Carry		; if bit is 1, write one
Clear_Carry:
			CLC						; clear carry bit
			JMP Store				
Set_Carry:
			SEC						; set carry bit
			JMP Store
Store:
			ROLA					; rotate the carry into accumulator
			DBNZ n, read_data		; decrement n and branch to read data if not zero
			RTS
acknowledge_in:
			BSET 2, PTADD			; take control of data line
			BCLR 2, PTAD			; clear the data line
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BSET 3, PTAD			; set clock line
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BCLR 3, PTAD			; clear clock line
			
			BCLR 2, PTADD			; release control of data line
			JMP done
not_acknowledge:
			BSET 2, PTADD			; take control of data line
			BSET 2, PTAD			; set data line for not acknowledge
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BSET 3, PTAD			; set clock line
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BCLR 3, PTAD			; clear clock line
			
			BCLR 2, PTADD			; release control of data line
			JMP done
Stop:
			BSET 2, PTADD			; take control of data line
			BCLR 2, PTAD			; clear data line
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BSET 3, PTAD			; set clock line
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BSET 2, PTAD			; set data line while clock line is high
			NOP
			BCLR 3, PTAD			; clear clock line
			
			BCLR 2, PTADD			; release control of data line
			
			JMP done
display_off:
			
			JSR clear_display			; clear display
			
			MOV #$54, $83				; 'T'
			JSR LCD_write
			
			MOV #$45, $83				; 'E'
			JSR LCD_write
			
			MOV #$43, $83				; 'C'
			JSR LCD_write
			
			MOV #$20, $83				; ' '
			JSR LCD_write
			
			MOV #$73, $83				; 's'
			JSR LCD_write
			
			MOV #$74, $83				; 't'
			JSR LCD_write
			
			MOV #$61, $83				; 'a'
			JSR LCD_write
			
			MOV #$74, $83				; 't'
			JSR LCD_write
			
			MOV #$65, $83				; 'e'
			JSR LCD_write
			
			MOV #$3A, $83				; ':'
			JSR LCD_write
			
			MOV #$20, $83				; ' '
			JSR LCD_write
			
			MOV #$6F, $83				; 'o'
			JSR LCD_write
			
			MOV #$66, $83				; 'f'
			JSR LCD_write
			
			MOV #$66, $83				; 'f'
			JSR LCD_write
			
			JSR new_address
			
			MOV #$54, $83				; 'T'
			JSR LCD_write
			
			MOV #$39, $83				; '9'
			JSR LCD_write
			
			MOV #$32, $83				; '2'
			JSR LCD_write
			
			MOV #$3A, $83				; ':'
			JSR LCD_write
			
			LDA $92
			ADD #73
			BCS write_3
			BRA write_2
			
write_3:

			MOV #$33, $83				; '3'
			JSR LCD_write
			JMP display_2

write_2:
			
			MOV #$32, $83				; '2'
			JSR LCD_write
			JMP display_2
			
display_2:

			CLRX
			CLRH
			LDX #10

			LDA $92
			ADD #73
			DIV
			STHX $90
			STA $91
			
			LDA $91
			ADD #$30
			STA $91
			
			LDA $90
			ADD #$30
			STA $90
			
			MOV $91, $83				; write top digit
			JSR LCD_write
			
			MOV $90, $83				; write bottom digit
			JSR LCD_write
			
			MOV #$4B, $83				; 'K'
			JSR LCD_write
			
			MOV #$40, $83				; '@'
			JSR LCD_write
			
			MOV #$54, $83				; 'T'
			JSR LCD_write
			
			MOV #$3D, $83				; '='
			JSR LCD_write
			
			MOV #$30, $83				; '0'
			JSR LCD_write
			
			MOV #$30, $83				; '0'
			JSR LCD_write
			
			MOV #$30, $83				; '0'
			JSR LCD_write
			
			MOV #$73, $83				; 's'
			JSR LCD_write
			
			RTS
			
convert:

			LSR $61
			LSR $61
			LSR $61				; get rid of first three bits... they are useless for this application
			
			LSR $61
			LSR $61
			LSR $61
			LSR $61				; get rid of first nibble of data. It contains decimal information
			
			LSL $60
			
			LDA $61
			ORA $60				; 0000 000x OR 00xx xxx0 --> A
								; A has 00xx xxxx
			STA $92 			; store into decoded temperature address
			
			RTS
			
BCD_to_binary:
			
			; $75 has BCD value in it
			
			MOV $75, $74			; move $75 into $74
			
			LSR $74
			LSR $74
			LSR $74
			LSR $74					; obtain top nibble
			
			LDA #%00001111
			AND $75					; obtain bottom nibble
			STA $73
			
			CLRX
			CLRH
			
			LDA $74
			LDX #10					; multiply top nibble by 10's place
			MUL
			STA $74
			
			CLRX
			CLRH
			
			LDA $74					; LDA with bottom nibble
			ADD $73					; Add upper nibble*10 to that value
			
			STA $87					; $75 has binary value
			
			RTS
