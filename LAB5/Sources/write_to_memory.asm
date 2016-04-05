			INCLUDE 'derivative.inc'
            
			XDEF write_to_time

			XREF Month, n, dummy, LCD_write, i2c_write
            
MY_ZEROPAGE: SECTION  SHORT
			
MyCode:     SECTION
write_to_time:
			CLRH

			LDA n
			CMP #0
			BEQ write_10_month
			CMP #1
			BEQ write_month
			
write_10_month:
			LSL dummy
			LSL dummy
			LSL dummy
			LSL dummy
			LDA dummy
			STA Month, X
			BSET 0, n
			JMP done
write_month:
			LDA Month, X
			ORA dummy
			STA Month, X
			INCX
			CLR n
			
			TXA
			CMP #3
			BEQ done
			CMP #7
			BEQ I2C
			
			MOV #$2F, $83			; Write '/'
			JSR LCD_write
			
			JMP done
			
done:
			BRA return
return:
			RTS
I2C:
			JSR i2c_write
