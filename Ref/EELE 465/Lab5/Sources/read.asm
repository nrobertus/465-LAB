			INCLUDE 'derivative.inc'
            
			XDEF read

			XREF BF_check, Month, Day, Year, Hour, Minutes, Seconds, Delay, t, b, n, display
            
MY_ZEROPAGE: SECTION  SHORT
			
			var: DS.B 1
			device_1: DS.B 1
			word_address: DS.B 1
			device_read_1: DS.B 1
			
			bit_mask: EQU $9B

MyCode:     SECTION

read:
			MOV #$D0, device_1
			MOV #$00, word_address
			MOV #$D1, device_read_1
			MOV #$80, bit_mask
			
			LDA $82
			EOR #%00010000			; Toggle Heartbeat LED
			STA $82
			MOV $82, PTBD
			BSET 3, PTBD			; Clock Heartbeat LED

			MOV #8, n
			JSR Start				; start condition
			MOV device_1, $9F		; device address with write bit
			JSR Write_address		; write sub
			MOV word_address, $9F	; word address
			JSR Write_address		; write sub
			JSR Start				; repeated start
			MOV device_read_1, $9F	; device address with read bit
			JSR Write_address		; write sub
			
			JSR read_data			; read data
			STA Seconds				; store data into seconds
			JSR acknowledge_in
			JSR read_data			; read data
			STA Minutes				; store data into minutes
			JSR acknowledge_in
			JSR read_data			; read data
			STA Hour				; store data into hour
			JSR acknowledge_in
			JSR read_data			; read data
			STA $88
			JSR acknowledge_in
									; the data is day of week
			JSR read_data			; read data
			STA Day					; store data into day
			JSR acknowledge_in
			JSR read_data			; read data
			STA Month				; store data into month
			JSR acknowledge_in
			JSR read_data			; read data
			STA Year				; store data into year
			
			
			JSR not_acknowledge
			JSR Stop				; stop
			
			JSR display
			
			MOV #255, t				; 4 us delay
			MOV #255, b
			JSR Delay
			
			MOV #255, t				; 4 us delay
			MOV #255, b
			JSR Delay
			
			JMP read
			

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
			
			BRCLR 2, PTAD, done
			JMP error 
done:
			MOV #8, n
			RTS
error:
			SEI
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
