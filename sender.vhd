library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sender is
    port ( clk, en, rst, btn, rdy : in  std_logic;
                             send : out std_logic;
                             char : out std_logic_vector (7 downto 0));
end sender;

architecture fsm of sender is

begin



end fsm;