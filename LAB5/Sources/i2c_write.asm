			INCLUDE 'derivative.inc'
            
			XDEF i2c_write

			XREF BF_check, Month, Day, Year, Hour, Minutes, Seconds, Delay, t, b, n, clear_display, read
            
MY_ZEROPAGE: SECTION  SHORT

			bit_mask: EQU $98
			address: EQU $90
			device: EQU $9E
			
MyCode:     SECTION
i2c_write:
			BSET 2, PTADD
			MOV #%11010000, device
			CLR n					; clearing bit counter
			CLRH					; clear H
			CLRX					; clear X
			CLR address				; clear address --> seconds
			
			MOV #%10000000, $98		; bit mask
			
			MOV Seconds, $91		; moves data into correct order
			MOV Minutes, $92
			MOV Hour, $93
			BCLR 6, $93				; sets real-time-clock to 24 hour mode
			MOV #0, $94
			MOV Day, $95
			MOV Month, $96
			MOV Year, $97

Start:
			BSET 2, PTAD			; data line = 1
			BSET 3, PTAD			; clock line =1
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BCLR 2, PTAD			; data line low
			
			MOV #2, t				; 4 us delay
			MOV #17, b
			JSR Delay
			
			BCLR 3, PTAD			; bring clock line low
			
			MOV #2, t				; 4 us delay
			MOV #21, b
			JSR Delay
			
			MOV device, $9F
			
Write_address:
			BSET 2, PTADD
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
			BCLR 2, PTAD			; clear data
			INC n					; increment counter
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
			BCLR 2, PTAD			; clear data
			INC n					; increment counter
			JMP check_n_ad			; check if bit counter is 8
check_n_ad:
			LDA #8					; load 8
			CMP n					; compare to counter
			BEQ acknowledge			; if n = 8, branch to acknowledge
			LSR bit_mask			; otherwise lsr bit_mask
			JMP Write_address		; loop back to write next bit
acknowledge:
			BCLR 2, PTADD			; set data as input
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BSET 3, PTAD			; bring clock line high
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			MOV PTAD, $9D
			
			MOV #2, t				; 4 us delay
			MOV #16, b
			JSR Delay
			
			BCLR 3, PTAD			; bring clock line low
			MOV #%10000000, bit_mask; reset bit_mask
			CLR n					; clear bit counter
			
			TXA
			CMP #8					; compare to 6
			BEQ stop				; if x = 6, done writing to real time clock
			
			LDA address, X
			STA $9F
			INCX
			BRCLR 2, $9D, write	; if acknowlede, then go to write data
			
			BSET 2, PTADD			; otherwise reset data direction
			
			JMP Start				; and restart address transmission
write:
			JMP Write_address
stop:
			BCLR 2, PTAD			; bring data low
			BSET 3, PTAD			; bring clock high
			NOP						; no op
			BSET 2, PTAD			; bring data high
			CLRX
			CLRH
			
I2C_read:
			JSR read			 	; start to read from real time clock
			JMP i2c_write
