library IEEE; use IEEE.STD_LOGIC_1164.all;
entity LCD7Segment_tb is
end;

architecture testLCD7Secgment of LCD7Segment_tb is
	component LCD7Segment
		port (I: in STD_LOGIC_VECTOR(3 downto 0);
		segment7: out STD_LOGIC_VECTOR(6 downto 0));
	end component;
	signal Itest: STD_LOGIC_VECTOR(3 downto 0);
	signal Outtest: STD_LOGIC_VECTOR(6 downto 0);
	begin
	DUT: LCD7Segment port map (Itest,Outtest);
	process begin
	Itest <= "0000"; wait for 10ns; assert Outtest = "0000001" report "0000 Fail";
	Itest <= "0001"; wait for 10ns; assert Outtest = "1001111" report "0001 Fail";
	Itest <= "0010"; wait for 10ns; assert Outtest = "0010010" report "0010 Fail";
	Itest <= "0011"; wait for 10ns; assert Outtest = "0000110" report "0011 Fail";
	Itest <= "0100"; wait for 10ns; assert Outtest = "1001100" report "0100 Fail"; 
	Itest <= "0101"; wait for 10ns; assert Outtest = "0100100" report "0101 Fail";
	Itest <= "0110"; wait for 10ns; assert Outtest = "0100000" report "0110 Fail";
	Itest <= "0111"; wait for 10ns; assert Outtest = "0001111" report "0111 Fail";
	Itest <= "1000"; wait for 10ns; assert Outtest = "0000000" report "1000 Fail";
	Itest <= "1001"; wait for 10ns; assert Outtest = "0000100" report "1001 Fail";
	Itest <= "1111"; wait for 10ns; assert Outtest = "1111111" report "1111 Fail";	
	wait;
	end process;
end architecture;