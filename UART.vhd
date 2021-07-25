--Library
library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.numeric_std.all;

--Entity
entity UART is
	generic (
		MAINCLKF	: positive := 40000000;	--40MHz
		UARTCLK		: positive := 1000000	--1MHz
	);
	port (
		clk 		: in 	std_logic;
		reset		: in	std_logic;
		txstart		: in 	std_logic;
		rxstart		: in 	std_logic;
		tx_busy		: out	std_logic;
		rx_busy		: out	std_logic;
		tx_data	    : in 	std_logic_vector(7 downto 0);
		rx_data	    : out 	std_logic_vector(7 downto 0);
		tx_line  	: out 	std_logic;
		rx_line		: in 	std_logic;
		rx_flag		: out 	std_logic;
		tx_flag		: out 	std_logic
	);
end entity UART;

--Architecture
architecture logic of UART is

component Rx is
	generic (
		MAINCLKF	: positive := 40000000;	--40MHz
		UARTCLK		: positive := 1000000	--1MHz
	);
	port (
		clk 		: in  std_logic;
		start		: in  std_logic;
		rx_line		: in  std_logic;
		data 		: out std_logic_vector(7 downto 0);
		new_data	: out std_logic;
		busy 		: out std_logic
	);
end component Rx;

component Tx is
	generic (
		MAINCLKF	: positive := 40000000;	--40MHz
		UARTCLK		: positive := 1000000	--1MHz
	);
	port (
		clk 		: in  std_logic;
		start 		: in  std_logic;
		busy		: out std_logic;
		done		: out std_logic;
		data	    : in  std_logic_vector(7 downto 0);
		tx_line  	: out std_logic
	);
end component Tx;

begin

Rx_inst : Rx
	generic map(
		MAINCLKF	=> MAINCLKF,
		UARTCLK		=> UARTCLK
	)
	port map(
		clk 		=> clk,
		start		=> rxstart,
		rx_line		=> rx_line,
		data 		=> rx_data,
		new_data	=> rx_flag,
		busy 		=> rx_busy
	);

Tx_inst : Tx
	generic map(
		MAINCLKF	=> MAINCLKF,
		UARTCLK		=> UARTCLK
	)
	port map(
		clk 		=> clk,
		start 		=> txstart,
		busy		=> tx_busy,
		done 		=> tx_flag,
		data	    => tx_data,
		tx_line  	=> tx_line
	);
end architecture logic;