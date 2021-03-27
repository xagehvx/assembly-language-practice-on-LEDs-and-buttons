################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../problem_2.s 

OBJS += \
./problem_2.o 

S_DEPS += \
./problem_2.d 


# Each subdirectory must supply rules for building sources it contributes
problem_2.o: ../problem_2.s
	arm-none-eabi-gcc -mcpu=cortex-m0plus -g3 -c -x assembler-with-cpp -MMD -MP -MF"problem_2.d" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@" "$<"

