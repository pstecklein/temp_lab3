library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port ( clk,TXD : in  std_logic;
               btn : in  std_logic_vector(1 downto 0);
               RXD : out std_logic);
end top;

architecture Structural of top is
    component uart port
    (
     clk, en, send, rx, rst : in  std_logic;
                   charSend : in  std_logic_vector(7 downto 0);
                  ready, tx : out std_logic
    );
    end component;
    component sender port
    (
      clk, en, rst, btn, rdy : in  std_logic;
                        send : out std_logic;
                        char : out std_logic_vector(7 downto 0)
    );
    end component;
    component debounce port
    (
      clk : in  std_logic;
      btn : in  std_logic;
     dbnc : out std_logic
    );
    end component;
    component clock_div port
    (
     clk : in  std_logic;
     div : out std_logic := '0'
    );
    end component;
    
    signal dbnc_res : std_logic_vector(1 downto 0) := (others => '0');
    signal div_res : std_logic := '0';
    signal ready_signal : std_logic := '0';
    signal send_signal : std_logic := '0';
    signal char_signal : std_logic_vector(7 downto 0) := (others => '0');

begin
    u1: debounce port map(
        clk => clk,
        btn => btn(0),
        dbnc => dbnc_res(0));
        
    u2: debounce port map(
        clk => clk,
        btn => btn(1),
        dbnc => dbnc_res(1));
      
    u3: clock_div port map(
        clk => clk,
        div => div_res);
        
    u4: sender port map(
        clk => clk,
        en => div_res,
        rst => dbnc_res(0),
        btn => dbnc_res(1),
        rdy => ready_signal,
        send => send_signal,
        char => char_signal);
    
    u5: uart port map(
        clk => clk,
        en => div_res,
        send => send_signal,
        rx => TXD,
        rst => dbnc_res(0),
        charSend => char_signal,
        ready => ready_signal,
        tx => RXD);

end Structural;
