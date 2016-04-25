set FLAG=-v -Pwork --syn-binding --ieee=synopsys --std=93c -fexplicit

ghdl -e --work=work --workdir=work %FLAG% tb_i2cgpio
