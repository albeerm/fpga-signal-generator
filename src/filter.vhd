library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity filter is
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
        DataOut: out SIGNED(7 downto 0) 
    );
end filter;

architecture arch of filter is
    type t_array_coefs is array(9 downto 0) of signed(7 downto 0);
    type t_data is array(9 downto 0) of signed(27 downto 0);
    signal DataOut_reg: signed(7 downto 0);
    signal filter_data: t_data;
    signal DataIn_reg: t_array_coefs; 
    
    constant a: t_array_coefs :=(   
    to_signed(a0,8), 
    to_signed(a1,8),
    to_signed(a2,8),
    to_signed(a3,8),
    to_signed(a4,8),
    to_signed(a5,8),
    to_signed(a6,8),
    to_signed(a7,8),
	to_signed(a8,8),
	to_signed(a9,8)
    );

    begin
    process(Clk,Reset)
    begin
      if Reset= '1' then
        DataIn_reg <=(others=> (others=> '0'));
      elsif Clk'event and Clk= '1' then
        if Enable= '1' then  
          DataOut_reg <=filter_data(9)(16 downto 9);  
		  DataIn_reg(9) <=DataIn_reg(8);
		  DataIn_reg(8) <=DataIn_reg(7);
          DataIn_reg(7) <=DataIn_reg(6);
          DataIn_reg(6) <=DataIn_reg(5);
          DataIn_reg(5) <=DataIn_reg(4); 
          DataIn_reg(4) <=DataIn_reg(3);
          DataIn_reg(3) <=DataIn_reg(2);
          DataIn_reg(2) <=DataIn_reg(1);
          DataIn_reg(1) <=DataIn_reg(0);
          DataIn_reg(0) <=DataIn; 
		  
        end if;
      end if;
    end Process;
    
    filter_data(0) <=resize(a(0)*DataIn_reg(0),28);
    filter_data(1) <=filter_data(0)+ resize(a(1)*DataIn_reg(1),28);
    filter_data(2) <=filter_data(1)+ resize(a(2)*DataIn_reg(2),28);
    filter_data(3) <=filter_data(2)+ resize(a(3)*DataIn_reg(3),28);
    filter_data(4) <=filter_data(3)+ resize(a(4)*DataIn_reg(4),28);
    filter_data(5) <=filter_data(4)+ resize(a(5)*DataIn_reg(5),28);
    filter_data(6) <=filter_data(5)+ resize(a(6)*DataIn_reg(6),28);
    filter_data(7) <=filter_data(6)+ resize(a(7)*DataIn_reg(7),28);
	filter_data(8) <=filter_data(7)+ resize(a(8)*DataIn_reg(8),28);
	filter_data(9) <=filter_data(8)+ resize(a(9)*DataIn_reg(9),28);

    DataOut <=DataOut_reg; 
    
end arch;