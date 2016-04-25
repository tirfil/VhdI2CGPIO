--###############################
--# Project Name : 
--# File         : 
--# Project      : 
--# Engineer     : 
--# Modification History
--###############################

library IEEE;
use IEEE.std_logic_1164.all;

entity TB_I2CGPIO is
end TB_I2CGPIO;

architecture stimulus of TB_I2CGPIO is

-- COMPONENTS --
	component I2CGPIO
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			SCL		: inout	std_logic;
			SDA		: inout	std_logic;
			GPIO		: inout	std_logic_vector(7 downto 0)
		);
	end component;

--
-- SIGNALS --
	signal MCLK		: std_logic;
	signal nRST		: std_logic;
	signal SCL		: std_logic;
	signal SDA		: std_logic;
	signal GPIO		: std_logic_vector(7 downto 0);

--
	signal RUNNING	: std_logic := '1';
	signal result	: std_logic_vector(7 downto 0);

begin

-- PORT MAP --
	I_I2CGPIO_0 : I2CGPIO
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			SCL		=> SCL,
			SDA		=> SDA,
			GPIO		=> GPIO
		);

--
	CLOCK: process
	begin
		while (RUNNING = '1') loop
			MCLK <= '1';
			wait for 10 ns;
			MCLK <= '0';
			wait for 10 ns;
		end loop;
		wait;
	end process CLOCK;

	GO: process
			procedure SendData(data : in std_logic_vector(7 downto 0)) is
			variable d : std_logic_vector(7 downto 0);
		begin
			d := data;
			SCL <= '0';
			for i in 0 to 7 loop
				if (d(7) = '1') then
					SDA <= 'H';
				else
					SDA <= '0';
				end if;
				wait for 200 ns;
				SCL <= 'H';
				wait for 200 ns;
				SCL <= '0';
				d(7 downto 1) := d(6 downto 0);
				wait for 200 ns;
			end loop;
			SDA <= 'H';
			wait for 200 ns;
			SCL <= 'H';
			wait for 200 ns;
			SCL <= '0';
			wait for 200 ns;	
		end SendData;
		procedure ReadData(nack: in std_logic)  is
			variable d: std_logic_vector(7 downto 0);
		begin
			SCL <= '0';
			for i in 0 to 7 loop
				d(7 downto 1) := d(6 downto 0); 
				wait for 200 ns;
				SCL <= 'H';
				d(0) := SDA;
				wait for 200 ns;
				SCL <= '0';
				wait for 200 ns;
			end loop;
			SDA <= nack;
			result <= d;
			wait for 200 ns;
			SCL <= 'H';
			wait for 200 ns;
			SCL <= '0';
			wait for 200 ns;
			SDA <= 'H';
		end ReadData;
	begin
		result <= x"FF";
		GPIO <= "10101010";
		wait for 1 ns;
		nRST <= '0';
		SDA <= 'H';
		SCL <= 'H';
		wait for 1000 ns;
		nRST <= '1';
		SDA <= '0'; -- start
		wait for 200 ns;
		SendData(x"70"); -- 38 << 1 + write
		SendData(x"00"); -- address
		SDA <= 'H';
		wait for 200 ns;
		SCL <= 'H';
		wait for 200 ns;
		SDA <= '0'; -- start
		wait for 200 ns;
		SendData(x"71"); -- 38 << 1 + read
		-- read GPIO
		ReadData('1'); -- nack 
		SCL <= 'H';
		wait for 200 ns;
		SDA <= 'H'; -- stop
		GPIO <= "ZZZZZZZZ";
		wait for 200 ns;
		SDA <= '0'; -- start
		wait for 200 ns;
		SendData(x"70"); -- 38 << 1 + write
		SendData(x"01"); -- address
		-- all output
		SendData(x"00"); 
		SDA <= 'H';
		wait for 200 ns;
		SCL <= 'H';
		wait for 200 ns;
		SDA <= '0'; -- start2
		wait for 200 ns;
		SendData(x"70"); -- 38 < 1 + write
		SendData(x"00"); -- address
		-- send C3
		SendData(x"C3");
		SDA <= '0';
		wait for 200 ns;		
		SCL <= 'H';
		wait for 200 ns;
		SDA <= 'H'; -- stop
		wait for 2000 ns;
		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;
