;** ###################################################################
;**     This code is generated by the Device Initialization Tool.
;**     It is overwritten during code generation.
;**     USER MODIFICATION ARE PRESERVED ONLY INSIDE INTERRUPT SERVICE ROUTINES
;**     OR EXPLICITLY MARKED SECTIONS
;**
;**     Project     : DeviceInitialization
;**     Processor   : MC9S08QG8MPB
;**     Version     : Component 01.262, Driver 01.08, CPU db: 3.00.012
;**     Datasheet   : MC9S08QG8 Rev. 4 2/2008
;**     Date/Time   : 2015-01-27, 15:19, # CodeGen: 4
;**     Abstract    :
;**         This module contains device initialization code 
;**         for selected on-chip peripherals.
;**     Contents    :
;**         Function "MCU_init" initializes selected peripherals
;**
;**     Copyright : 1997 - 2011 Freescale Semiconductor, Inc. All Rights Reserved.
;**     
;**     http      : www.freescale.com
;**     mail      : support@freescale.com
;**
;**		Edited by: Levi Hartman and Erik Andersen
;**		Date: 1/27/15
;**
;** ###################################################################

; MODULE MCUinit

        INCLUDE MC9S08QG8.inc          ; I/O map for MC9S08QG8MPB

; User declarations and definitions
;   Code, declarations and definitions here will be preserved during code generation
; End of user declarations and definitions

CODE_SECT:      SECTION

        XDEF    MCU_init
;** ===================================================================
;**     Method      :  MCU_init (component MC9S08QG8_16)
;**
;**     Description :
;**         Device initialization code for selected peripherals.
;** ===================================================================
MCU_init:
  ; ### MC9S08QG8_16 "Cpu" init code ... 
  ; Common initialization of the write once registers 
  		LDA #100	; load 100 into accumulator
  		STA $60		; store into $60
        ; SOPT1: COPE=0,COPT=1,STOPE=0,BKGDPE=1,RSTPE=0 
        LDA     #$52
        STA     SOPT1                                               
        ; SPMSC1: LVDF=0,LVDACK=0,LVDIE=0,LVDRE=1,LVDSE=1,LVDE=1,BGBE=0 
        LDA     #$1C
        STA     SPMSC1                                               
        ; SPMSC2: PDF=0,PPDF=0,PPDACK=0,PDC=0,PPDC=0 
        CLRA
        STA     SPMSC2                                               
        ; SPMSC3: LVDV=0,LVWV=0 
        LDA     SPMSC3
        AND     #$CF
        STA     SPMSC3
  ;  System clock initialization 
        ;Test if the device trim value is stored on the specified address
        LDA     $FFAF
        CBEQA   #$FF, SkipTrim
        ; ICSTRM: Initialize internal clock trim from a non volatile memory 
        LDA     $FFAF
        STA     ICSTRM
        ; ICSSC: Initialize internal clock trim from a non volatile memory 
        LDA     $FFAE
        STA     ICSSC
SkipTrim:
        ; ICSC1: CLKS=0,RDIV=0,IREFS=1,IRCLKEN=0,IREFSTEN=0 
        MOV     #$04,ICSC1             ; Initialization of the ICS control register 1 
        ; ICSC2: BDIV=1,RANGE=0,HGO=0,LP=0,EREFS=0,ERCLKEN=0,EREFSTEN=0 
        MOV     #$40,ICSC2             ; Initialization of the ICS control register 2 

  ; Common initialization of the CPU registers 
        ; PTASE: PTASE4=1,PTASE3=1,PTASE2=1,PTASE1=1,PTASE0=1 
        LDA     PTASE
        ORA     #$1F
        STA     PTASE
        ; PTBSE: PTBSE7=1,PTBSE6=1,PTBSE5=1,PTBSE4=1,PTBSE3=1,PTBSE2=1,PTBSE1=1,PTBSE0=1 
        LDA     #$FF
        STA     PTBSE                                               
        ; PTADS: PTADS5=0,PTADS4=0,PTADS3=0,PTADS2=0,PTADS1=0,PTADS0=0 
        CLRA
        STA     PTADS                                               
        ; PTBDS: PTBDS7=0,PTBDS6=0,PTBDS5=0,PTBDS4=0,PTBDS3=0,PTBDS2=0,PTBDS1=0,PTBDS0=0 
        CLRA
        STA     PTBDS                                               
  ; ### Init_TPM init code 
        ; TPMSC: TOF=0,TOIE=0,CPWMS=0,CLKSB=0,CLKSA=0,PS2=0,PS1=0,PS0=0 
        CLR     TPMSC                  ; Stop and reset counter 
        LDHX    #$9C40
        STHX    TPMMOD                 ; Period value setting 
        LDA     TPMSC                  ; Overflow int. flag clearing (first part) 
        ; TPMSC: TOF=0,TOIE=1,CPWMS=0,CLKSB=0,CLKSA=1,PS2=0,PS1=0,PS0=0 
        MOV     #$48,TPMSC             ; Int. flag clearing (2nd part) and timer control register setting 
  ; ### Init_GPIO init code 
        ; PTBDD: PTBDD7=1,PTBDD6=1,PTBDD5=1,PTBDD4=1,PTBDD3=1,PTBDD2=1,PTBDD1=1,PTBDD0=1 
        MOV     #$7F,PTBDD                                        
  ; ### 
        CLI                            ; Enable interrupts 

        RTS


;** ===================================================================
;**     Interrupt handler : isrVtpmovf
;**
;**     Description :
;**         User interrupt service routine. 
;**     Parameters  : None
;**     Returns     : Nothing
;** ===================================================================
        XDEF    isrVtpmovf
isrVtpmovf:
  ; Write your interrupt code here ... 
  
  		LDA $60					
  		DECA					; Decrement our counter
  		STA $60					; Store back into memory
		BEQ LED_TOGGLE			; If equal to 0 branch to LED_TOGGLE
		
		BCLR 7, TPMSC			; Otherwise return from interrupt
		RTI
		
		LED_TOGGLE:
			LDA PTBD			; Load port B into accumulator
			COMA				; 1's Complement the data in accumulator 
			STA PTBD			; Store the accumulator back into port B
			
			LDA #100			; reinitialize address $60 to 100
			STA $60
		
			BCLR 7, TPMSC		; Set the TOF flag to a 0
		
        	RTI					; Return from interrupt
; end of isrVtpmovf 



; Initialization of the CPU registers in FLASH 
        ; NVPROT: FPS6=1,FPS5=1,FPS4=1,FPS3=1,FPS2=1,FPS1=1,FPS0=1,FPDIS=1 
        ORG     NVPROT
        DC.B    $FF
        ; NVOPT: KEYEN=0,FNORED=1,SEC01=1,SEC00=0 
        ORG     NVOPT
        DC.B    $7E



        XREF    _Startup

; Interrupt vector table 
  ifndef UNASSIGNED_ISR
UNASSIGNED_ISR: EQU     $FFFF          ; unassigned interrupt service routine
  endif

        ORG     $FFD0                  ; Interrupt vector table
_vect:
        DC.W    UNASSIGNED_ISR         ; Int.no. 23 Vrti (at FFD0)                  Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no. 22 VReserved22 (at FFD2)           Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no. 21 VReserved21 (at FFD4)           Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no. 20 Vacmp (at FFD6)                 Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no. 19 Vadc (at FFD8)                  Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no. 18 Vkeyboard (at FFDA)             Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no. 17 Viic (at FFDC)                  Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no. 16 Vscitx (at FFDE)                Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no. 15 Vscirx (at FFE0)                Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no. 14 Vscierr (at FFE2)               Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no. 13 Vspi (at FFE4)                  Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no. 12 Vmtim (at FFE6)                 Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no. 11 VReserved11 (at FFE8)           Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no. 10 VReserved10 (at FFEA)           Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no.  9 VReserved9 (at FFEC)            Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no.  8 VReserved8 (at FFEE)            Unassigned
        DC.W    isrVtpmovf             ; Int.no.  7 Vtpmovf (at FFF0)               Used
        DC.W    UNASSIGNED_ISR         ; Int.no.  6 Vtpmch1 (at FFF2)               Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no.  5 Vtpmch0 (at FFF4)               Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no.  4 VReserved4 (at FFF6)            Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no.  3 Vlvd (at FFF8)                  Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no.  2 Virq (at FFFA)                  Unassigned
        DC.W    UNASSIGNED_ISR         ; Int.no.  1 Vswi (at FFFC)                  Unassigned
        DC.W    _Startup               ; Int.no.  0 Vreset (at FFFE)                Reset vector




        END     ; MODULE MCUinit

;** ###################################################################
;**
;**     This file was created by Processor Expert 5.3 [05.01]
;**     for the Freescale HCS08 series of microcontrollers.
;**
;** ###################################################################
