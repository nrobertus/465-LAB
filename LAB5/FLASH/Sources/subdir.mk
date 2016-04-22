################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.local

# Add inputs and outputs from these tool invocations to the build variables 
ASM_SRCS += \
../Sources/BF_check.asm \
../Sources/Delay.asm \
../Sources/LCD_init.asm \
../Sources/LCD_write.asm \
../Sources/display.asm \
../Sources/functions.asm \
../Sources/i2c_write.asm \
../Sources/keypad.asm \
../Sources/main.asm \
../Sources/prints.asm \
../Sources/read.asm \
../Sources/write_to_memory.asm \

ASM_SRCS_QUOTED += \
"../Sources/BF_check.asm" \
"../Sources/Delay.asm" \
"../Sources/LCD_init.asm" \
"../Sources/LCD_write.asm" \
"../Sources/display.asm" \
"../Sources/functions.asm" \
"../Sources/i2c_write.asm" \
"../Sources/keypad.asm" \
"../Sources/main.asm" \
"../Sources/prints.asm" \
"../Sources/read.asm" \
"../Sources/write_to_memory.asm" \

OBJS += \
./Sources/BF_check_asm.obj \
./Sources/Delay_asm.obj \
./Sources/LCD_init_asm.obj \
./Sources/LCD_write_asm.obj \
./Sources/display_asm.obj \
./Sources/functions_asm.obj \
./Sources/i2c_write_asm.obj \
./Sources/keypad_asm.obj \
./Sources/main_asm.obj \
./Sources/prints_asm.obj \
./Sources/read_asm.obj \
./Sources/write_to_memory_asm.obj \

ASM_DEPS += \
./Sources/BF_check_asm.d \
./Sources/Delay_asm.d \
./Sources/LCD_init_asm.d \
./Sources/LCD_write_asm.d \
./Sources/display_asm.d \
./Sources/functions_asm.d \
./Sources/i2c_write_asm.d \
./Sources/keypad_asm.d \
./Sources/main_asm.d \
./Sources/prints_asm.d \
./Sources/read_asm.d \
./Sources/write_to_memory_asm.d \

OBJS_QUOTED += \
"./Sources/BF_check_asm.obj" \
"./Sources/Delay_asm.obj" \
"./Sources/LCD_init_asm.obj" \
"./Sources/LCD_write_asm.obj" \
"./Sources/display_asm.obj" \
"./Sources/functions_asm.obj" \
"./Sources/i2c_write_asm.obj" \
"./Sources/keypad_asm.obj" \
"./Sources/main_asm.obj" \
"./Sources/prints_asm.obj" \
"./Sources/read_asm.obj" \
"./Sources/write_to_memory_asm.obj" \

ASM_DEPS_QUOTED += \
"./Sources/BF_check_asm.d" \
"./Sources/Delay_asm.d" \
"./Sources/LCD_init_asm.d" \
"./Sources/LCD_write_asm.d" \
"./Sources/display_asm.d" \
"./Sources/functions_asm.d" \
"./Sources/i2c_write_asm.d" \
"./Sources/keypad_asm.d" \
"./Sources/main_asm.d" \
"./Sources/prints_asm.d" \
"./Sources/read_asm.d" \
"./Sources/write_to_memory_asm.d" \

OBJS_OS_FORMAT += \
./Sources/BF_check_asm.obj \
./Sources/Delay_asm.obj \
./Sources/LCD_init_asm.obj \
./Sources/LCD_write_asm.obj \
./Sources/display_asm.obj \
./Sources/functions_asm.obj \
./Sources/i2c_write_asm.obj \
./Sources/keypad_asm.obj \
./Sources/main_asm.obj \
./Sources/prints_asm.obj \
./Sources/read_asm.obj \
./Sources/write_to_memory_asm.obj \


# Each subdirectory must supply rules for building sources it contributes
Sources/BF_check_asm.obj: ../Sources/BF_check.asm
	@echo 'Building file: $<'
	@echo 'Executing target #1 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/BF_check.args" -Objn"Sources/BF_check_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/%.d: ../Sources/%.asm
	@echo 'Regenerating dependency file: $@'
	
	@echo ' '

Sources/Delay_asm.obj: ../Sources/Delay.asm
	@echo 'Building file: $<'
	@echo 'Executing target #2 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/Delay.args" -Objn"Sources/Delay_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/LCD_init_asm.obj: ../Sources/LCD_init.asm
	@echo 'Building file: $<'
	@echo 'Executing target #3 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/LCD_init.args" -Objn"Sources/LCD_init_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/LCD_write_asm.obj: ../Sources/LCD_write.asm
	@echo 'Building file: $<'
	@echo 'Executing target #4 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/LCD_write.args" -Objn"Sources/LCD_write_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/display_asm.obj: ../Sources/display.asm
	@echo 'Building file: $<'
	@echo 'Executing target #5 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/display.args" -Objn"Sources/display_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/functions_asm.obj: ../Sources/functions.asm
	@echo 'Building file: $<'
	@echo 'Executing target #6 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/functions.args" -Objn"Sources/functions_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/i2c_write_asm.obj: ../Sources/i2c_write.asm
	@echo 'Building file: $<'
	@echo 'Executing target #7 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/i2c_write.args" -Objn"Sources/i2c_write_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/keypad_asm.obj: ../Sources/keypad.asm
	@echo 'Building file: $<'
	@echo 'Executing target #8 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/keypad.args" -Objn"Sources/keypad_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/main_asm.obj: ../Sources/main.asm
	@echo 'Building file: $<'
	@echo 'Executing target #9 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/main.args" -Objn"Sources/main_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/prints_asm.obj: ../Sources/prints.asm
	@echo 'Building file: $<'
	@echo 'Executing target #10 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/prints.args" -Objn"Sources/prints_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/read_asm.obj: ../Sources/read.asm
	@echo 'Building file: $<'
	@echo 'Executing target #11 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/read.args" -Objn"Sources/read_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '

Sources/write_to_memory_asm.obj: ../Sources/write_to_memory.asm
	@echo 'Building file: $<'
	@echo 'Executing target #12 $<'
	@echo 'Invoking: HCS08 Assembler'
	"$(HC08ToolsEnv)/ahc08" -ArgFile"Sources/write_to_memory.args" -Objn"Sources/write_to_memory_asm.obj" "$<" -Lm="$(@:%.obj=%.d)" -LmCfg=xilmou
	@echo 'Finished building: $<'
	@echo ' '


