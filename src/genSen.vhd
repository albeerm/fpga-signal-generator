library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity genSen is
  Port( Clk: in STD_LOGIC;
    Reset: in STD_LOGIC;
    per: in STD_LOGIC_VECTOR(1 downto 0);
    led: out SIGNED(7 downto 0);
    dac: out UNSIGNED(7 downto 0));
end genSen;

architecture arch of genSen is  
  SIGNAL max_count: INTEGER range 25000 downto 0; 
  SIGNAL ts_count: UNSIGNED(14 DOWNTO 0) := (OTHERS => '0');  
  SIGNAL sample_count: INTEGER range 15 downto 0; 
  SIGNAL sample_count_enable: STD_LOGIC;    
  SIGNAL led_internal: SIGNED(7 downto 0);
  SIGNAL dac_internal: UNSIGNED(7 downto 0); 
   
  type tROM is array(0 to 15) of integer range -128 to 127;
  constant ROM_data: tROM :=
    (0, 48, 89, 117, 127, 117, 89, 48, 0, -48, -89, -117, -127, -117, -89, -48);
  begin
    sample_count_enable <='1' when ts_count= max_count   else  '0';  
    
    process(Clk, Reset)
    begin
      if Reset= '1' then
        ts_count <=(others => '0');         
      elsif rising_edge(Clk) then 
        if ts_count= max_count then 
          ts_count <=(others=> '0'); 
        else
          ts_count <=ts_count + 1;
        end if;
      end if;
      end process;
        
     process(Clk, Reset)
     begin
       if Reset= '1' then
         sample_count <=0; 
       elsif rising_edge(Clk) then
         if sample_count_enable= '1' then 
           if sample_count= 15 then 
             sample_count <=0; 
           else
             sample_count <=sample_count + 1;            
           end if; 
         end if; 
     end if;     
    end process;
    
    process(per)
    begin
      case per is
        when "00"=>
          max_count <=12499; 
        when "01"=>
          max_count <=6579; 
        when "10"=>
          max_count <=3124; 
        when others=> 
          max_count <=1562; 
        end case;         
      end process;
	  
    led_internal <=to_signed(ROM_data(sample_count),8); 
    dac_internal <=unsigned(led_internal)+128;   
    led <=led_internal;
    dac <=dac_internal;
    
end arch;