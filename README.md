
8 bit GPIO controlled by I2C
============================

I2C address = 0x38

ADR = 0x01 : R/W : tristate register : bit at 1= input, bit at 0= output, default = 0xFF (all input).

ADR = 0x00 : R/W : data              : R = read GPIO data, W= write byte to output register.

