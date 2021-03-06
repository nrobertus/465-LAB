;** ###################################################################
;**     This code is generated by the Device Initialization Tool.
;**     It is overwritten during code generation.
;**     USER MODIFICATION ARE PRESERVED ONLY INSIDE EXPLICITLY MARKED SECTIONS.
;**
;**     Project     : DeviceInitialization
;**     Processor   : MC9S08QG8MPB
;**     Version     : Component 01.262, Driver 01.08, CPU db: 3.00.013
;**     Datasheet   : MC9S08QG8 Rev. 4 2/2008
;**     Date/Time   : 2016-02-11, 15:16, # CodeGen: 0
;**     Abstract    :
;**         This module contains device initialization code 
;**         for selected on-chip peripherals.
;**     Contents    :
;**         Function "MCU_init" initializes selected peripherals
;**
;**     Copyright : 1997 - 2014 Freescale Semiconductor, Inc. 
;**     All Rights Reserved.
;**     
;**     Redistribution and use in source and binary forms, with or without modification,
;**     are permitted provided that the following conditions are met:
;**     
;**     o Redistributions of source code must retain the above copyright notice, this list
;**       of conditions and the following disclaimer.
;**     
;**     o Redistributions in binary form must reproduce the above copyright notice, this
;**       list of conditions and the following disclaimer in the documentation and/or
;**       other materials provided with the distribution.
;**     
;**     o Neither the name of Freescale Semiconductor, Inc. nor the names of its
;**       contributors may be used to endorse or promote products derived from this
;**       software without specific prior written permission.
;**     
;**     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
;**     ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;**     WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;**     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
;**     ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
;**     (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
;**     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
;**     ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;**     (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;**     SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;**     
;**     http: www.freescale.com
;**     mail: support@freescale.com
;** ###################################################################

 IFNDEF __DeviceInitialization_INC
__DeviceInitialization_INC: EQU  1

; Include shared modules, which are used for whole project 


; User declarations and definitions
;   Code, declarations and definitions here will be preserved during code generation
; End of user declarations and definitions

        XREF    MCU_init
;** ===================================================================
;**     Method      :  Cpu_MCU_init (component MC9S08QG8_16)
;**     @brief
;**         Device initialization code for selected peripherals.
;** ===================================================================*/



;** ===================================================================
;**     Interrupt handler : isrVtpmovf
;**
;**     Description :
;**         User interrupt service routine. 
;**     Parameters  : None
;**     Returns     : Nothing
;** ===================================================================
        XREF    isrVtpmovf






;      end     ; DeviceInitialization

 ENDIF   ; IFNDEF __DeviceInitialization_INC
;** @}
;** ###################################################################
;**
;**     This file was created by Processor Expert 10.3 [05.09]
;**     for the Freescale HCS08 series of microcontrollers.
;**
;** ###################################################################
