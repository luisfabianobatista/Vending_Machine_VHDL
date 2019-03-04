library IEEE; use IEEE.STD_LOGIC_1164.all;
entity MachineDistributrice is
	port (clk, reset: in STD_LOGIC;
			distr: out STD_LOGIC;
			I: in STD_LOGIC_VECTOR(1 downto 0); 
			OutLCDlow, OutLCDHigh: out STD_LOGIC_VECTOR(6 downto 0));
end;

architecture synth of MachineDistributrice is
	component LCDDriver
		port (I: in STD_LOGIC_VECTOR(3 downto 0);
				LCDOutLow, LCDOutHigh: out STD_LOGIC_VECTOR(6 downto 0));
	end component;

	type statetype is (M25, M20, M15, M10, M5);
	signal state, nextstate: statetype := M25; --declaring states and giving initial state for power on
	signal O: STD_LOGIC_VECTOR(3 downto 0);
	begin
		LCDBar: LCDDriver port map (O,OutLCDlow,OutLCDHigh);
		process (clk,reset,state) begin
			if reset='0' then
			
				if clk'event and clk='0' then
					state <= nextstate;
				end if;
				
				if clk'event and clk ='1' then
					case state is
						when M5 => if I = "00" then
							nextstate <= M25;
							O <= "1000";
							elsif I = "01" then
								nextstate <= M25;
								O <= "1001";
							elsif I = "10" then
								nextstate <= M25;
								O <= "1100";
							elsif I = "11" then
								O <= "0000";
							end if;
						when M10 => if I = "00" then
								nextstate <= M5;
								O <= "0000";
							elsif I = "01" then
								nextstate <= M25;
								O <= "1000";
							elsif I = "10" then
								nextstate <= M25;
								O <= "1011";
							elsif I = "11" then
								O <= "0000";
							end if;
						when M15 => if I = "00" then
								nextstate <= M10;
								O <= "0000";
							elsif I = "01" then
								nextstate <= M5;
								O <= "0000";
							elsif I = "10" then
								nextstate <= M25;
								O <= "1010";
							elsif I = "11" then
								O <= "0000";
							end if;				
						when M20 => if I = "00" then
								nextstate <= M15;
								O <= "0000";
							elsif I = "01" then
								nextstate <= M10;
								O <= "0000";
							elsif I = "10" then
								nextstate <= M25;
								O <= "1001";
							elsif I = "11" then
								O <= "0000";
							end if;
						when M25 => if I = "00" then
								nextstate <= M20;
								O <= "0000";
							elsif I = "01" then
								nextstate <= M15;
								O <= "0000";
							elsif I = "10" then
								nextstate <= M25;
								O <= "1000";
							elsif I = "11" then
								O <= "0000";
							end if;
					end case;
				end if;
			else 
				state <= M25;
				nextstate <= M25;
				O <= "0000";
			end if;
		end process;
	distr <= O(3);
end;	
