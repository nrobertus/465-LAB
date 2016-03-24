################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
ASM_SRCS += \
../Sources/MCUinit.asm \
../Sources/main.asm \

ASM_SRCS_QUOTED += \
"../Sources/MCUinit.asm" \
"../Sources/main.asm" \

OBJS += \
./Sources/MCUinit_asm.obj \
./Sources/main_asm.obj \

ASM_DEPS += \
./Sources/MCUinit_asm.d \
./Sources/main_asm.d \

OBJS_QUOTED += \
"./Sources/MCUinit_asm.obj" \
"./Sources/main_asm.obj" \

ASM_DEPS_QUOTED += \
"./Sources/MCUinit_asm.d" \
"./Sources/main_asm.d" \

OBJS_OS_FORMAT += \
./Sources/MCUinit_asm.obj \
./Sources/main_asm.obj \


# Each subdirectory must supply rules for building sources it contributes
Sources/MCUinit_asm.obj: ../Sources/MCUinit.asm
	@echo 'Building file: $<'
	@echo 'Executing target #1 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/MCUinit.args" -Objn"Sources/MCUinit_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/%.d: ../Sources/%.asm
	@echo 'Regenerating dependency file: $@'
	
	@echo ' '

Sources/main_asm.obj: ../Sources/main.asm
	@echo 'Building file: $<'
	@echo 'Executing target #2 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/main.args" -Objn"Sources/main_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '


