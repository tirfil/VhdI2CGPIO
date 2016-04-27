--###############################
--# Project Name : i2cgpio
--# File         : i2cgpio.vhd
--# Project      : i2c utilities
--# Copyright	 : Philippe THIRION
--# Modification History
--###############################

library IEEE;
use IEEE.std_logic_1164.all;

entity I2CGPIO is
	port(
		MCLK		: in	std_logic;
		nRST		: in	std_logic;
		SCL			: inout	std_logic;
		SDA			: inout	std_logic;
		GPIO		: inout	std_logic_vector(7 downto 0)
	);
end I2CGPIO;

architecture rtl of I2CGPIO is
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
			CS			=> ONE,
			ADDR		=> ADDRESS(0),
			WR			=> WR,
			DIN			=> DATA_OUT,
			DOUT		=> DATA_IN,
			GPIO		=> GPIO
		);
		
	--  open drain PAD pull up 1.5K needed
	SCL <= 'Z' when SCL_OUT='1' else '0';
	SCL_IN <= to_UX01(SCL);
	SDA <= 'Z' when SDA_OUT='1' else '0';
	SDA_IN <= to_UX01(SDA);

end rtl;

