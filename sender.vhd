library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sender is
    port ( clk, en, rst, btn, rdy : in  std_logic;
                             send : out std_logic;
                             char : out std_logic_vector (7 downto 0));
end sender;

architecture fsm of sender is
    -- state type enumeration and state variable
    type state is (idle, busyA, busyB, busyC);
    signal curr : state := idle;

    type str is array (0 to 4) of std_logic_vector(7 downto 0);
    signal NETID : str := (x"48", x"65", x"6C", x"6C", x"6F");
    
    signal i : std_logic_vector(2 downto 0) := (others => '0');
    
begin

    process(clk) begin
    if rising_edge(clk) then

        -- resets the state machine and its outputs
        if rst = '1' then
            i <= (others => '0');
            char <= (others => '0');
            send <= '0';
            curr <= idle;
            
        -- usual operation
        elsif en = '1' then
            case curr is

                when idle =>
                    if rdy = '1' and btn = '1' then
                        if unsigned(i) < 6 then
                            send <= '1';
                            char <= NETID(integer(i));
                            i <= std_logic_vector(unsigned(i) + 1);
                            curr <= busyA;
                        elsif unsigned(i) < 6 then
                            i <= (others => '0');
                        end if;
                    end if;

                when busyA =>
                    curr <= busyB;

                when busyB =>
                    send <= '0';
                    curr <= busyC;
                
                when busyC =>
                    if rdy = '1' and btn = '1' then
                        curr <= idle;
                    end if;

                when others =>
                    curr <= idle;

            end case;
        end if;

    end if;
    end process;



end fsm;