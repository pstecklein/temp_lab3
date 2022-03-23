library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
    port ( clk, en, send, rst  : in  std_logic;
           char                : in  std_logic_vector (7 downto 0);
           ready, tx           : out std_logic);
end uart_tx;

architecture fsm of uart_tx is
    -- state type enumeration and state variable
    type state is (idle, start, data);
    signal curr : state := idle;

    -- shift register to read data in
    signal d : std_logic_vector (7 downto 0) := (others => '0');

    -- counter for data state
    signal count : std_logic_vector(2 downto 0) := (others => '0');

begin


    -- FSM process (single process implementation)
    process(clk) begin
    if rising_edge(clk) then

        -- resets the state machine and its outputs
        if rst = '1' then

            curr <= idle;
            d <= (others => '0');
            count <= (others => '0');

        -- usual operation
        elsif en = '1' then
            case curr is

                when idle =>
                    ready <= '1';
                    if send = '1' then
                        curr <= start;
                    end if;

                when start =>
                    d <= char;
                    count <= (others => '0');
                    ready <= '1';
                    curr <= data;

                when data =>
                    if unsigned(count) < 7 then
                        d <= '0' & d(7 downto 1);
                        tx <= d(0);
                        count <= std_logic_vector(unsigned(count) + 1);
                    else
                        ready <= '1';
                        curr <= idle;
                    end if;

                when others =>
                    curr <= idle;

            end case;
        end if;

    end if;
    end process;


end fsm;
