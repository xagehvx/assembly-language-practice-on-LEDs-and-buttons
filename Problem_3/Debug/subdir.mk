################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../problem_3.s 

OBJS += \
./problem_3.o 

S_DEPS += \
./problem_3.d 


# Each subdirectory must supply rules for building sources it contributes
problem_3.o: ../problem_3.s
	arm-none-eabi-gcc -mcpu=cortex-m0plus -g3 -c -x assembler-with-cpp -MMD -MP -MF"problem_3.d" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"

