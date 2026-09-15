library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_top is

end tb_top;

architecture arch of tb_top is
component top 
   port( 
      tClk: in STD_LOGIC;
      tReset: in STD_LOGIC;
      tper: in STD_LOGIC_VECTOR(1 downto 0);
      tled: out SIGNED(7 downto 0);
      tdac: out UNSIGNED(7 downto 0);
      tdac_pipe: out UNSIGNED(7 downto 0));
    end component;
 
    signal tClk: STD_LOGIC := '0';
    signal tReset: STD_LOGIC := '0';
    signal tper: STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal tled: SIGNED(7 downto 0); 
    signal tdac: UNSIGNED(7 downto 0);
    signal tdac_pipe: UNSIGNED(7 downto 0);
    constant period: time := 10 ns; 
    constant semiPeriod: time := period/2; 
begin  
  COMP: top
    port map (tClk=> tClk,
        tReset=> tReset,
        tper=> tper,
        tled=> tled,
        tdac=> tdac,
        tdac_pipe=> tdac_pipe);

  process
    begin
      tClk <='0';
      wait for semiPeriod;
      tClk <='1';
      wait for semiPeriod;
    end process;
 
   process
     begin 
      tReset <='0';
      wait for 5*semiPeriod;
      tReset <='1';
      wait for 15*semiPeriod;
      tReset <='0';
      wait;
   end process;

    process
    begin
      tper <="00"; 
      wait for 10000 us; 
      tper <="01"; 
      wait for 10000 us;
      tper <="10"; 
      wait for 10000 us;
      tper <="11"; 
      wait for 10000 us;
    end process;
end arch;