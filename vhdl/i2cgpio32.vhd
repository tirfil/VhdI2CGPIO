--###############################
--# Project Name : 
--# File         : 
--# Project      : 
--# Engineer     : 
--# Modification History
--###############################

library IEEE;
use IEEE.std_logic_1164.all;

entity I2CGPIO32 is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		SCL			: inout	std_logic;
		SDA			: inout	std_logic;
		GPIOA		: inout	std_logic_vector(7 downto 0);
		GPIOB		: inout	std_logic_vector(7 downto 0);
		GPIOC		: inout	std_logic_vector(7 downto 0);
		GPIOD		: inout	std_logic_vector(7 downto 0)
	);
end I2CGPIO32;

architecture rtl of I2CGPIO32 is
-- COMPONENTS --
	component I2CSLAVE
		port(
			MCLK		: in	std_logic;
			nRST		: in	std_logic;
			SDA_IN		: in	std_logic;
			SCL_IN		: in	std_logic;
			SDA_OUT		: out	std_logic;
			SCL_OUT		: out	std_logic;
			ADDRESS		: out	std_logic_vector(7 downto 0);
			DATA_OUT		: out	std_logic_vector(7 downto 0);
			DATA_IN		: in	std_logic_vector(7 downto 0);
			WR		: out	std_logic;
			RD		: out	std_logic
		);
	end component;
	
	component gpio8
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
	end component;
	
	signal SDA_IN		: std_logic;
	signal SCL_IN		: std_logic;
	signal SDA_OUT		: std_logic;
	signal SCL_OUT		: std_logic;
	signal ADDRESS		: std_logic_vector(7 downto 0);
	signal DATA_OUT		: std_logic_vector(7 downto 0);
	signal DATA_IN		: std_logic_vector(7 downto 0);
	signal WR			: std_logic;
	signal ONE			: std_logic;
	signal CS0, CS1, CS2, CS3 : std_logic;
	signal DOUT0, DOUT1, DOUT2, DOUT3 : std_logic_vector(7 downto 0);

begin

	ONE <= '1';

-- PORT MAP --
	I_I2CSLAVE_0 : I2CSLAVE
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			SDA_IN		=> SDA_IN,
			SCL_IN		=> SCL_IN,
			SDA_OUT		=> SDA_OUT,
			SCL_OUT		=> SCL_OUT,
			ADDRESS		=> ADDRESS,
			DATA_OUT	=> DATA_OUT,
			DATA_IN		=> DATA_IN,
			WR			=> WR,
			RD			=> open
		);
		
	I_gpio8_0 : gpio8
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			CS			=> CS0,
			ADDR		=> ADDRESS(0),
			WR			=> WR,
			DIN			=> DATA_OUT,
			DOUT		=> DOUT0,
			GPIO		=> GPIOA
		);
		
	I_gpio8_1 : gpio8
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			CS			=> CS1,
			ADDR		=> ADDRESS(0),
			WR			=> WR,
			DIN			=> DATA_OUT,
			DOUT		=> DOUT1,
			GPIO		=> GPIOB
		);
		
	I_gpio8_2 : gpio8
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			CS			=> CS2,
			ADDR		=> ADDRESS(0),
			WR			=> WR,
			DIN			=> DATA_OUT,
			DOUT		=> DOUT2,
			GPIO		=> GPIOC
		);
		
	I_gpio8_3 : gpio8
		port map (
			MCLK		=> MCLK,
			nRST		=> nRST,
			CS			=> CS3,
			ADDR		=> ADDRESS(0),
			WR			=> WR,
			DIN			=> DATA_OUT,
			DOUT		=> DOUT3,
			GPIO		=> GPIOD
		);
		
	CS0 <= not ADDRESS(1) and not ADDRESS(2);
	CS1 <= ADDRESS(1) and not ADDRESS(2);
	CS2 <= not ADDRESS(1) and ADDRESS(2);
	CS3 <= ADDRESS(1) and ADDRESS(2);
	
	DATA_IN <= 	DOUT0 when CS0='1' else
				DOUT1 when CS1='1' else
				DOUT2 when CS2='1' else
				DOUT3;
		
	--  open drain PAD pull up 1.5K needed
	SCL <= 'Z' when SCL_OUT='1' else '0';
	SCL_IN <= to_UX01(SCL);
	SDA <= 'Z' when SDA_OUT='1' else '0';
	SDA_IN <= to_UX01(SDA);

end rtl;

