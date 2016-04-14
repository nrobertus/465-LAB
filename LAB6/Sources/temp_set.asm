			INCLUDE 'derivative.inc'
            
			XDEF time_reset, read, Seconds
			
			XREF main, n, b, t, Delay, Tset, keypad_write, display, XOR_Mask
            
MY_ZEROPAGE: SECTION  SHORT
			
			device_1: EQU $78
			word_address: EQU $79
			device_read_1: EQU $7A 
			bit_mask: EQU $7B
			Seconds: EQU $7D
			
			Tread1: EQU $60
			Tread2: EQU $61
			
MyCode:     SECTION
time_reset:
			
			MOV PTBD, $93		; update state
			
			; initialize seconds register to 0 seconds
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
			
			MOV #0, $95
			MOV #0, $96
			MOV #$30, $97
			
			JMP read

read:

			; initializations
			MOV #$90, device_1
			MOV #$00, word_address
			MOV #$91, device_read_1
			MOV #$80, bit_mask
			MOV #8, n
			
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

			
			JSR display				; jump to the display sequence
			
			JSR BCD_to_binary		; convert input BCD temperature to Binary value
			
			MOV #%11110111, $76		; return to reading from the keypad.
			JSR keypad_write
			LDA $70
			CMP #%01111110
			BEQ return
			
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
			
			LDA $87					; load A with desired temperature
			CMP $92					; compare with actual value
			BEQ hold
			BMI cool				; if actual value is greater than desired, goto cool 
			BPL heat				; if actual value is less than desired, goto heat
return:
			PTBDD_Upper_output
			MOV #$01, PTBD
			BSET 3, PTBD
			NOP
			BCLR 3, PTBD
			RTS
hold:
			PTBDD_Upper_output
			; D1 is cool
			MOV #%00000001, PTBD	; set cool bit
			BSET 3, PTBD			; rising edge clock
			
			NOP						; nop
			
			BCLR 3, PTBD			; clear clock line
			
			BRSET 4, $93, reset; if previous state was heating, branch to time_reset
			BRSET 5, $93, reset; if previous state was cooling, branch to time_reset
			MOV PTBD, $93			; update state
			JMP read
cool:
			PTBDD_Upper_output
			; D1 is cool
			MOV #%00100001, PTBD	; set cool bit
			BSET 3, PTBD			; rising edge clock
			
			NOP						; nop
			
			BCLR 3, PTBD			; clear clock line
			
			BRSET 4, $93, reset; if previous state was heating, branch to time_reset
			MOV PTBD, $93			; update state
			JMP read
			
heat:
			PTBDD_Upper_output
			; D0 is heat
			MOV #%00010001, PTBD	; set heat bit
			BSET 3, PTBD			; rising edge clock
			
			NOP						; nop
			
			BCLR 3, PTBD			; clear clock line
			
			BRSET 5, $93, reset; if previous state was cooling, branch to time_reset
			MOV PTBD, $93			; update state
			JMP read
reset:
			JMP time_reset

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
