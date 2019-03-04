library IEEE; use IEEE.STD_LOGIC_1164.all;
entity LCDDriver_tb is
end;


architecture TestLCDDriver of LCDDriver_tb is
component LCDDriver
port port (I: in STD_LOGIC_VECTOR(3 downto 0);
		LCDOutLow, LCDOutHigh: out STD_LOGIC_VECTOR(6 downto 0));
end component;
--Ilow and Ihigh are the signals that will drive the LCD7Segment component
-- signal that will be connected to the input of the LCD Driver
signal InLCD: STD_LOGIC_VECTOR(3 downto 0);
-- Ilow corresponds to the output of the LCD7Segment
signal OutLCDlow, OutLCDHigh: STD_LOGIC_VECTOR(6 downto 0);
begin
DUT: LCDDriver port map (InLCD,OutLCDlow,OutLCDHigh);
	--lowLCD: LCD7Segment port map (Ilow, Olow);
	--highLCD: LCD7Segment port map (Ihigh, Ohigh);
	lowLCD: LCD7Segment port map (Ilow, LCDOutLow);
	highLCD: LCD7Segment port map (Ihigh, LCDOutHigh);
process(I) begin
	if I(3) = '1' then -- this is when the beverage is dispensed
		Ilow <= "0000";
		Ihigh <= "1111"; -- turn off all segments
	elsif I = "0001" then
		Ilow <= "0101";
		Ihigh <= "1111";
	elsif I = "0010" then
		Ilow <= "0000";
		Ihigh <= "0001";
	elsif I = "0100" then
		Ilow <= "0000";
		Ihigh <= "0010";
	else --for I=¨0000¨ and any other unknown state
		Ilow <= "1111";
		Ihigh <= "1111";  --nothing is displayed when a number more than 9 is given as input. 
	end if;
end process;
--LCDOutLow <= Olow;
--LCDOutHigh <= Ohigh;
end architecture;