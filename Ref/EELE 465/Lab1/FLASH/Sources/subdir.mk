################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
ASM_SRCS += \
../Sources/Keypad_read_write.asm \
../Sources/Pattern_a.asm \
../Sources/Pattern_b.asm \
../Sources/Pattern_c.asm \
../Sources/Pattern_d.asm \
../Sources/main.asm \

ASM_SRCS_QUOTED += \
"../Sources/Keypad_read_write.asm" \
"../Sources/Pattern_a.asm" \
"../Sources/Pattern_b.asm" \
"../Sources/Pattern_c.asm" \
"../Sources/Pattern_d.asm" \
"../Sources/main.asm" \

OBJS += \
./Sources/Keypad_read_write_asm.obj \
./Sources/Pattern_a_asm.obj \
./Sources/Pattern_b_asm.obj \
./Sources/Pattern_c_asm.obj \
./Sources/Pattern_d_asm.obj \
./Sources/main_asm.obj \

ASM_DEPS += \
./Sources/Keypad_read_write_asm.d \
./Sources/Pattern_a_asm.d \
./Sources/Pattern_b_asm.d \
./Sources/Pattern_c_asm.d \
./Sources/Pattern_d_asm.d \
./Sources/main_asm.d \

OBJS_QUOTED += \
"./Sources/Keypad_read_write_asm.obj" \
"./Sources/Pattern_a_asm.obj" \
"./Sources/Pattern_b_asm.obj" \
"./Sources/Pattern_c_asm.obj" \
"./Sources/Pattern_d_asm.obj" \
"./Sources/main_asm.obj" \

ASM_DEPS_QUOTED += \
"./Sources/Keypad_read_write_asm.d" \
"./Sources/Pattern_a_asm.d" \
"./Sources/Pattern_b_asm.d" \
"./Sources/Pattern_c_asm.d" \
"./Sources/Pattern_d_asm.d" \
"./Sources/main_asm.d" \

OBJS_OS_FORMAT += \
./Sources/Keypad_read_write_asm.obj \
./Sources/Pattern_a_asm.obj \
./Sources/Pattern_b_asm.obj \
./Sources/Pattern_c_asm.obj \
./Sources/Pattern_d_asm.obj \
./Sources/main_asm.obj \


# Each subdirectory must supply rules for building sources it contributes
Sources/Keypad_read_write_asm.obj: ../Sources/Keypad_read_write.asm
	@echo 'Building file: $<'
	@echo 'Executing target #1 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/Keypad_read_write.args" -Objn"Sources/Keypad_read_write_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/%.d: ../Sources/%.asm
	@echo 'Regenerating dependency file: $@'
	
	@echo ' '

Sources/Pattern_a_asm.obj: ../Sources/Pattern_a.asm
	@echo 'Building file: $<'
	@echo 'Executing target #2 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/Pattern_a.args" -Objn"Sources/Pattern_a_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/Pattern_b_asm.obj: ../Sources/Pattern_b.asm
	@echo 'Building file: $<'
	@echo 'Executing target #3 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/Pattern_b.args" -Objn"Sources/Pattern_b_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/Pattern_c_asm.obj: ../Sources/Pattern_c.asm
	@echo 'Building file: $<'
	@echo 'Executing target #4 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/Pattern_c.args" -Objn"Sources/Pattern_c_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/Pattern_d_asm.obj: ../Sources/Pattern_d.asm
	@echo 'Building file: $<'
	@echo 'Executing target #5 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/Pattern_d.args" -Objn"Sources/Pattern_d_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/main_asm.obj: ../Sources/main.asm
	@echo 'Building file: $<'
	@echo 'Executing target #6 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/main.args" -Objn"Sources/main_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '


