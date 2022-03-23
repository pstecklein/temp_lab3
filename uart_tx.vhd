library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
port ( clk, en, send, rst  : in  std_logic;
       char                : in  std_logic_vector (7 downto 0);
       ready, tx           : out std_logic);
end uart_tx;

architecture Behavioral of uart_tx is

begin


end Behavioral;
