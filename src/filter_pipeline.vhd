library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity filter_pipeline is
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
end filter_pipeline;

architecture arch of filter_pipeline is
    type t_array_coefs is array(9 downto 0) of signed(7 downto 0); 
    type t_data is array(9 downto 0) of signed(16 downto 0);
    type t_sum1 is array(4 downto 0) of signed(17 downto 0);
    type t_sum2 is array(2 downto 0) of signed(18 downto 0);
	type t_sum3 is array(1 downto 0) of signed(18 downto 0);

    signal filter_data: t_data;
    signal DataIn_reg: t_array_coefs; 
    signal sum1: t_sum1;
    signal sum2: t_sum2;
	signal sum3: t_sum3;
    signal sum_final: signed(18 downto 0);      
    
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
      if Reset='1' then
        DataIn_reg <=(others=> (others=> '0'));
      elsif Clk'event and Clk= '1' then
        if Enable= '1' then 
         
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
    
    Process(Clk, Reset)
     begin 
        if Reset= '1' then
          filter_data <=(others=> (others=> '0'));     
        elsif Clk'event and Clk= '1' then
        filter_data(0) <=resize(a(0)*DataIn_reg(0),17);
        filter_data(1) <=resize(a(1)*DataIn_reg(1),17);
        filter_data(2) <=resize(a(2)*DataIn_reg(2),17);
        filter_data(3) <=resize(a(3)*DataIn_reg(3),17);
        filter_data(4) <=resize(a(4)*DataIn_reg(4),17);
        filter_data(5) <=resize(a(5)*DataIn_reg(5),17);
        filter_data(6) <=resize(a(6)*DataIn_reg(6),17);
        filter_data(7) <=resize(a(7)*DataIn_reg(7),17);
		filter_data(8) <=resize(a(8)*DataIn_reg(8),17);
		filter_data(9) <=resize(a(9)*DataIn_reg(9),17);
		
        end if;
    end Process;  

    Process(Clk, Reset)
    begin 
       if Reset= '1' then
          sum1 <=(others=> (others=> '0'));     
        elsif Clk'event and Clk= '1' then
          sum1(0) <=resize(filter_data(0)+ filter_data(1),18);
          sum1(1) <=resize(filter_data(2)+ filter_data(3),18);
          sum1(2) <=resize(filter_data(4)+ filter_data(5),18);
          sum1(3) <=resize(filter_data(6)+ filter_data(7),18);
		  sum1(4) <=resize(filter_data(8)+ filter_data(9),18);
          
            sum2(0) <=resize(sum1(0)+ sum1(1),19);
            sum2(1) <=resize(sum1(2)+ sum1(3),19);
             sum2(2) <=resize(sum1(4),19);
				
				sum3(0) <=resize(sum2(0)+ sum2(1),19);
				sum3(1) <=sum2(2);
           
        end if;
     end Process;
     
    Process(Clk, Reset)
    begin 
       if Reset= '1' then
         sum_final <=(others=> '0');     
        elsif Clk'event and Clk= '1' then
          sum_final <=resize(sum3(0)+ sum3(1),19);
        end if;
     end Process;

   DataOut <=sum_final(16 downto 9);
    
end arch;