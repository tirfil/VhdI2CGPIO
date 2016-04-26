--###############################
--# Project Name : 
--# File         : 
--# Project      : 
--# Engineer     : 
--# Modification History
--###############################

library IEEE;
use IEEE.std_logic_1164.all;

entity gpio8 is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		CS			: in	std_logic;
		ADDR		: in	std_logic;
		WR			: in	std_logic;
		DIN			: in	std_logic_vector(7 downto 0);
		DOUT		: out	std_logic_vector(7 downto 0);
		GPIO		: inout	std_logic_vector(7 downto 0)
	);
end gpio8;

architecture rtl of gpio8 is

	signal tristate_reg		: std_logic_vector(7 downto 0);
	signal output_reg		: std_logic_vector(7 downto 0);
	signal tristate_write	: std_logic;
	signal output_write		: std_logic;
	signal gpio_q			: std_logic_vector(7 downto 0);
	signal gpio_qq			: std_logic_vector(7 downto 0);

begin

	TRISREG: process(MCLK,nRST)
	begin
		if ( nRST = '0') then
			tristate_reg <= (others=>'1');
		elsif ( MCLK'event and MCLK = '1' ) then
			if (tristate_write = '1' ) then
				tristate_reg <= DIN;
			end if;
		end if;
	end process TRISREG;
	
	tristate_write <= CS and ADDR and WR;

	OUTREG: process(MCLK,nRST)
	begin
		if ( nRST = '0') then
			output_reg <= (others=>'0');
		elsif ( MCLK'event and MCLK = '1' ) then
			if (output_write = '1' ) then
				output_reg <= DIN;
			end if;
		end if;
	end process OUTREG;

	output_write <= CS and not ADDR and WR;

	RESYNC: process(MCLK,nRST)
	begin
		if ( MCLK'event and MCLK = '1' ) then
			gpio_q <= to_UX01(GPIO);
			gpio_qq <= gpio_q;
		end if;
	end process RESYNC;

	GENOUT: 
	for i in 0 to 7 generate
		OUT_GPIO : GPIO(i) <= output_reg(i) when tristate_reg(i)='0' else 'Z';
	end generate GENOUT;

	DOUT <= gpio_qq when ADDR='0' else tristate_reg;

end rtl;

