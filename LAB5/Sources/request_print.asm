;*******************************************************************
;* This stationery serves as the framework for a user application. *
;* For a more comprehensive program that demonstrates the more     *
;* advanced functionality of this processor, please see the        *
;* demonstration applications, located in the examples             *
;* subdirectory of the "Freescale CodeWarrior for HC08" program    *
;* directory.                                                      *
;*******************************************************************

; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            

; export symbols
            XDEF request_print
     
            XREF display_char, char_1, char_2, n, clear_display, BF_check, new_address, DAA_decode, PTBDD_Upper_output, Clock_in   ; symbol defined by the linker for the end of the stack

MY_ZEROPAGE: SECTION  SHORT 

MyCode:     SECTION
request_print:

			MOV #%01011100, char_1
			MOV #%00101100, char_2 ; 'R'
			JSR display_char

			MOV #%01101100, char_1
			MOV #%01011100, char_2	;  'e'
			JSR display_char
			
			MOV #%01111100, char_1
			MOV #%00011100, char_2	;  'q'
			JSR display_char
			
			MOV #%00101100, char_1
			MOV #%00001100, char_2	;  ' '
			JSR display_char
			
			MOV #%01001100, char_1
			MOV #%11111100, char_2	;  'O'
			JSR display_char

			MOV #%01111100, char_1
			MOV #%01011100, char_2	;  'u'
			JSR display_char
			
			MOV #%01111100, char_1
			MOV #%01001100, char_2	;  't'
			JSR display_char
			
			MOV #%00101100, char_1
			MOV #%00001100, char_2	;  ' '
			JSR display_char
			
			MOV #%00111100, char_1
			MOV #%11011100, char_2	;  '='
			JSR display_char
			
			MOV #%00101100, char_1
			MOV #%00001100, char_2	;  ' '
			JSR display_char
			
			RTS
