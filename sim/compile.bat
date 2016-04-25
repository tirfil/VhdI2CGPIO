set FLAG=-v -Pwork --syn-binding --ieee=synopsys --std=93c -fexplicit

ghdl -a --work=work --workdir=work %FLAG% ../vhdl/gpio8.vhd
ghdl -a --work=work --workdir=work %FLAG% ../vhdl/i2cslave.vhd
ghdl -a --work=work --workdir=work %FLAG% ../vhdl/i2cgpio.vhd
ghdl -a --work=work --workdir=work %FLAG% ../test/tb_i2cgpio.vhd


