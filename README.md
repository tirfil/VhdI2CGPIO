
8 bit GPIO controlled by I2C
============================

I2C address = 0x38

ADR = 0x01 : R/W : tristate register : bit at 1= input, bit at 0= output, default = 0xFF (all input).

ADR = 0x00 : R/W : data              : R = read GPIO data, W= write byte to output register.

Mockup
======

Using an ALTERA MAX II CPLD (EPM240)

| # GPIO | Size(LE) | Note                        |
|--------|----------|-----------------------------|
| 8      | ~160     | mockup project              |
| 32     | ~260     | doesn't fit in a EPM240     |

See raspi and altera directories

![mockup board](https://github.com/tirfil/VhdI2CGPIO/blob/master/images/board.JPG)


