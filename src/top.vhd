library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
  Port ( tClk: in STD_LOGIC;
    tReset: in STD_LOGIC;
    tper: in STD_LOGIC_VECTOR (1 downto 0);
    tled: out SIGNED (7 downto 0);
    tdac: out UNSIGNED (7 downto 0);
    tdac_pipe: out UNSIGNED (7 downto 0));

end top;

architecture arch of top is
 
  component genSen 
   is port( 
      Clk: in STD_LOGIC;
      Reset: in STD_LOGIC;
      per: in STD_LOGIC_VECTOR (1 downto 0);
      led: out SIGNED (7 downto 0);
      dac: out UNSIGNED (7 downto 0));
    end component;
  
  component filter
      generic(
          a0: integer;
          a1: integer;
          a2: integer;
          a3: integer;
          a4: integer;
          a5: integer;
          a6: integer;
          a7: integer;
		  a8: integer;
		  a9: integer
        );
    port(
      Clk: in STD_LOGIC;    
      Reset: in STD_LOGIC;     
      Enable: in STD_LOGIC;   
      DataIn: in SIGNED(7 downto 0);   
      DataOut: out SIGNED(7 downto 0)); 
    end component;
    
    component filter_pipeline
      generic(
          a0: integer;
          a1: integer;
          a2: integer;
          a3: integer;
          a4: integer;
          a5: integer;
          a6: integer;
          a7: integer;
		  a8: integer;
		  a9: integer
        );
    port(
      Clk: in STD_LOGIC;              
      Reset: in STD_LOGIC;             
      Enable: in STD_LOGIC;            
      DataIn: in SIGNED(7 downto 0);   
      DataOut: out SIGNED(7 downto 0)); 
    end component;
    
    constant filter_max_count: INTEGER := 9999;
    signal filter_count: UNSIGNED(14 DOWNTO 0);
    signal filter_enable: STD_LOGIC; 
    signal led_internal: SIGNED(7 downto 0); 
    signal dac_internal: SIGNED(7 downto 0) ;
    signal dac_internal_pipe: SIGNED(7 downto 0) ;
    
    begin
    
   GEN_SEN: genSen
     port map(
       Clk=> tClk,
       Reset=> tReset,
       per=> tper,
       led=> led_internal,
       dac=> open
       );

  FIR: filter
    generic map(

       a0=> 0,
       a1=> 2,
       a2=> 9,  
       a3=> 21,
       a4=> 31,
       a5=> 31,
       a6=> 21,
       a7=> 9,
	   a8=> 2,
	   a9=> 0

    )
    port map(
       Clk=> tClk,
       Reset=> tReset,
       Enable=> filter_enable, 
       DataIn=> led_internal,
       DataOut=> dac_internal 
       );
       
        FIR_pipe: filter_pipeline
    generic map(
       a0=> 0,
       a1=> 2,
       a2=> 9,  
       a3=> 21,
       a4=> 31,
       a5=> 31,
       a6=> 21,
       a7=> 9,
	   a8=> 2,
	   a9=> 0

    )
    port map(
       Clk=> tClk,
       Reset=> tReset,
       Enable=> filter_enable, 
       DataIn=> led_internal,
       DataOut=> dac_internal_pipe
       );
       
   process(tClk, tReset)
   begin 
     if tReset= '1' then
        filter_count <=(others=> '0');
      elsif rising_edge(tClk) then 
        if filter_count= filter_max_count then 
          filter_enable <='1';
          filter_count <=(others=> '0'); 
        else
          filter_count <=filter_count+ 1;
          filter_enable <='0';
        end if;
      end if;
   end process;
   
   tdac <=unsigned(dac_internal)+ 128;
   tdac_pipe <=unsigned(dac_internal_pipe)+ 128;
   tled <=led_internal;
      
   end arch;