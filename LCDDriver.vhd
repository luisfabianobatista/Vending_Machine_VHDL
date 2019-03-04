library IEEE; use IEEE.STD_LOGIC_1164.all;
entity LCDDriver is
port (I: in STD_LOGIC_VECTOR(3 downto 0);
		LCDOutLow, LCDOutHigh: out STD_LOGIC_VECTOR(6 downto 0));
end;


architecture codage of LCDDriver is
component LCD7Segment
port (I: in STD_LOGIC_VECTOR(3 downto 0);
		segment7: out STD_LOGIC_VECTOR(6 downto 0));
end component;
--Ilow and Ihigh are the signals that will drive the LCD7Segment component
signal Ilow, Ihigh: STD_LOGIC_VECTOR(3 downto 0);
begin
	--lowLCD: LCD7Segment port map (Ilow, Olow);
	--highLCD: LCD7Segment port map (Ihigh, Ohigh);
	lowLCD: LCD7Segment port map (Ilow, LCDOutLow);
	highLCD: LCD7Segment port map (Ihigh, LCDOutHigh);
process(I) begin
	if I = "1000" then -- beverage dispensed - no coin returned
		Ilow <= "0000";
		Ihigh <= "1111"; -- turn off all segments
	elsif I = "1001" then -- beverage dispensed - 5 cents returned
		Ilow <= "0101";
		Ihigh <= "1111";
	elsif I = "1010" then -- beverage dispensed - 10 cents returned
		Ilow <= "0000";
		Ihigh <= "0001";
	elsif I = "1011" then -- beverage dispensed - 10 cents returned
		Ilow <= "0101";
		Ihigh <= "0001";		
	elsif I = "1100" then -- beverage dispensed - 2x 10 cents returned
		Ilow <= "0000";
		Ihigh <= "0010";
	else
		Ilow <= "1111";
		Ihigh <= "1111";  --nothing is displayed when a number more than 9 is given as input. 
	end if;
end process;

end architecture;