import smbus
import time

bus = smbus.SMBus(1)
adr = 0x38

# all outputs
bus.write_byte_data(adr,0x01,0x00) 

while True:
	bus.write_byte_data(adr,0x00,0xAA)
	time.sleep(1)
	bus.write_byte_data(adr,0x00,0x55)
	time.sleep(1)


	
