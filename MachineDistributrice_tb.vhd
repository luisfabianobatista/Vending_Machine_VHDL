library IEEE; use IEEE.STD_LOGIC_1164.all;
entity MachineDistributrice_tb is
end;

architecture analysis of MachineDistributrice_tb is
	component MachineDistributrice
		port (clk, reset: in STD_LOGIC;
				distr: out STD_LOGIC;
				I: in STD_LOGIC_VECTOR(1 downto 0); 
				OutLCDlow, OutLCDHigh: out STD_LOGIC_VECTOR(6 downto 0));
	end component;

	signal clk, reset: STD_LOGIC :='0';
	signal distr: STD_LOGIC;
	signal I: STD_LOGIC_VECTOR(1 downto 0); 
	signal OutLCDlow, OutLCDHigh: STD_LOGIC_VECTOR(6 downto 0);
	begin
		DUT: MachineDistributrice port map (clk, reset, distr, I, OutLCDlow, OutLCDHigh);
		
		-- ############ SIMULATION DESCRIPTION ################
		-- Input signal I will be synthetized to verify the machine state dynamic behavior and outputs
		--  Input signal I will be generated in the falling edge of the system clock signal, because
		-- it is necessary to make sure the signals (next state and I) are stable in the flip-flop inputs
		-- The ¨state¨ variable will receive the value of ¨nextstate¨ when the clock´s falling edge
		-- In the clock risign edge the ¨state¨ and ¨I¨ variables are evaluateed to calculate the next state. 
		-- At the same time, the output signals are determined.
		-- In this test, the output signals will be evaluated at 75% of the clock period, because the signals
		-- will not be stable in the clock edge. Since the clock period is 20ns, the output signal will be
		-- asserted 15ns after the clock rising edge.
		
		--simulation of a clock signal with a 20ns period
		process begin
			wait for 10ns; clk <= not clk; 
		end process;
		
		process begin
		
		-- #################################################################
		-- Initialization test: M25--> M25, no coin,  no change returned, no beverage distribution
		I <="11"; --> void signal (no coin inserted)
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 0: OutLCDlow failed for I=11, staying at same state";
		assert OutLCDHigh="1111111" report "Test 0: OutLCDHigh failed for I=11, staying at same state";
		assert distr='0' report "Test 2: distr failed for I=11, staying at same state";
		wait for 5ns;
		
		-- #################################################################
		-- First test: M25--> M25, distribute,  no change returned
		-- State M25, inserting 25cents, going to M25 	
		
		I <= "10";
		wait for 15ns;
		assert OutLCDlow = "0000001" report "Test 1: OutLCDlow failed for I=10, from state M25 to M25";
		assert OutLCDHigh = "1111111" report "Test 1: OutLCDHigh failed for I=10, from state M25 to M25";
		assert distr='1' report "Test 1: distr failed for I=10, from state M25 to M25";
		wait for 5ns;
		
 
		-- #################################################################
		-- Second test: M25--> M20 --> M25, distribute,  return 5 cents
		-- State M25, inserting 5cents, going to M20	
		I <= "00"; 
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 2: OutLCDlow failed for I=00, from state M25 to M20";
		assert OutLCDHigh="1111111" report "Test 2: OutLCDHigh failed for I=00, from state M25 to M20";
		assert distr='0' report "Test 2: distr failed for I=00, from state M25 to M20";
		wait for 5ns;
		
		-- State M20, staying at same state for once clock cycle
		I <="11"; --> void signal (no coin inserted)
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 0: OutLCDlow failed for I=11, staying at same state";
		assert OutLCDHigh="1111111" report "Test 0: OutLCDHigh failed for I=11, staying at same state";
		assert distr='0' report "Test 2: distr failed for I=11, staying at same state";
		wait for 5ns;
			
		
		-- State M20, inserting 25cents, going to M25	
		I <= "10"; 
		wait for 15ns;
		assert OutLCDlow="0100100" report "Test 2: OutLCDlow failed for I=10, from state M20 to M25";
		assert OutLCDHigh="1111111" report "Test 2: OutLCDHigh failed for I=10, from state M20 to M25";
		assert distr='1' report "Test 2: distr failed for I=10, from state M20 to M25";
		wait for 5ns;
		
		-- #################################################################
		-- Third test: M25--> M15 --> M25, distribute,  return 10 cents
		-- State M25, inserting 10cents, going to M15	
		I <= "01"; 
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 3: OutLCDlow failed for I=01, from state M25 to M15";
		assert OutLCDHigh="1111111" report "Test 3: OutLCDHigh failed for I=01, from state M25 to M15";
		assert distr='0' report "Test 3: distr failed for I=01, from state M25 to M15";
		wait for 5ns;
		
		-- State M15, staying at same state for once clock cycle
		I <="11"; --> void signal (no coin inserted)
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 0: OutLCDlow failed for I=11, staying at same state";
		assert OutLCDHigh="1111111" report "Test 0: OutLCDHigh failed for I=11, staying at same state";
		assert distr='0' report "Test 2: distr failed for I=11, staying at same state";
		wait for 5ns;
		
		-- State M15, inserting 25cents, distribute, going to M25
		I <= "10"; 
		wait for 15ns;
		assert OutLCDlow="0000001" report "Test 3: OutLCDlow failed for I=10, from state M15 to M25";
		assert OutLCDHigh="1001111" report "Test 3: OutLCDHigh failed for I=10, from state M15 to M25";
		assert distr='1' report "Test 3: distr failed for I=10, from state M15 to M25";
		wait for 5ns;
		
		-- #################################################################
		-- Fourth test: M25--> M20 --> M10 --> M25, distribute,  no change returned
		-- State M25, inserting 5cents, going to M20	
		I <= "00"; 
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 4: OutLCDlow failed for I=00, from state M25 to M20";
		assert OutLCDHigh="1111111" report "Test 4: OutLCDHigh failed for I=00, from state M5 to M20";
		assert distr='0' report "Test 4: distr failed for I=00, from state M25 to M20";
		wait for 5ns;
		
		-- State M20, inserting 10cents, going to M10	
		I <= "01"; 
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 4: OutLCDlow failed for I=01, from state M20 to M10";
		assert OutLCDHigh="1111111" report "Test 4: OutLCDHigh failed for I=01, from state M20 to M10";
		assert distr='0' report "Test 4: distr failed for I=01, from state M20 to M10";
		wait for 5ns;
		
		-- State M10, staying at same state for once clock cycle
		I <="11"; --> void signal (no coin inserted)
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 0: OutLCDlow failed for I=11, staying at same state";
		assert OutLCDHigh="1111111" report "Test 0: OutLCDHigh failed for I=11, staying at same state";
		assert distr='0' report "Test 2: distr failed for I=11, staying at same state";
		wait for 5ns;
		
		-- State M10, inserting 10cents, going to M25	
		I <= "01"; 
		wait for 15ns;
		assert OutLCDlow="0000001" report "Test 4: OutLCDlow failed for I=01, from state M10 to M25";
		assert OutLCDHigh="1111111" report "Test 4: OutLCDHigh failed for I=01, from state M10 to M25";
		assert distr='1' report "Test 4: distr failed for I=01, from state M10 to M25";
		wait for 5ns;
		
		-- #################################################################
		-- Fifth test: M25--> M15 --> M10 --> M25, distribute,  return 5 and 10 
		-- State M25, inserting 10cents, going to M15	
		I <= "01"; 
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 5: OutLCDlow failed for I=01, from state M25 to M15";
		assert OutLCDHigh="1111111" report "Test 5: OutLCDHigh failed for I=01, from state M25 to M15";
		assert distr='0' report "Test 5: distr failed for I=01, from state M25 to M15";
		wait for 5ns;
		
		-- State M15, inserting 5cents, going to M10	
		I <= "00"; 
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 5: OutLCDlow failed for I=00, from state M15 to M10";
		assert OutLCDHigh="1111111" report "Test 5: OutLCDHigh failed for I=00, from state M15 to M10";
		assert distr='0' report "Test 5: distr failed for I=00, from state M15 to M10";
		wait for 5ns;
		
		-- State M10, inserting 25cents, going to M25	
		I <= "10"; 
		wait for 15ns;
		assert OutLCDlow="0100100" report "Test 5: OutLCDlow failed for I=10, from state M10 to M25";
		assert OutLCDHigh="1001111" report "Test 5: OutLCDHigh failed for I=10, from state M10 to M25";
		assert distr='1' report "Test 5: distr failed for I=00, from state M10 to M25";
		wait for 5ns;
		
		-- #################################################################
		-- Sixth test: M25--> M15 --> M5 --> M25, distribute,  no return 
		-- State M25, inserting 10cents, going to M15	
		I <= "01"; 
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 6: OutLCDlow failed for I=01, from state M25 to M15";
		assert OutLCDHigh="1111111" report "Test 6: OutLCDHigh failed for I=01, from state M25 to M15";
		assert distr='0' report "Test 6: distr failed for I=01, from state M25 to M15";
		wait for 5ns;
		
		-- State M15, inserting 10cents, going to M5	
		I <= "01"; 
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 6: OutLCDlow failed for I=01, from state M15 to M5";
		assert OutLCDHigh="1111111" report "Test 6: OutLCDHigh failed for I=01, from state M15 to M5";
		assert distr='0' report "Test 6: distr failed for I=01, from state M15 to M5";
		wait for 5ns;
		
		-- State M5, staying at same state for once clock cycle
		I <="11"; --> void signal (no coin inserted)
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 0: OutLCDlow failed for I=11, staying at same state";
		assert OutLCDHigh="1111111" report "Test 0: OutLCDHigh failed for I=11, staying at same state";
		assert distr='0' report "Test 2: distr failed for I=11, staying at same state";
		wait for 5ns;
		
		-- State M5, inserting 5cents, going to M25	
		I <= "00"; 
		wait for 15ns;
		assert OutLCDlow="0000001" report "Test 6: OutLCDlow failed for I=00, from state M5 to M25";
		assert OutLCDHigh="1111111" report "Test 6: OutLCDHigh failed for I=00, from state M5 to M25";
		assert distr='1' report "Test 6: distr failed for I=00, from state M5 to M25";
		wait for 5ns;
		
		-- #################################################################
		-- Seventh test: M25--> M15 --> M5 --> M25, distribute,  return 5 cents
		-- State M25, inserting 10cents, going to M15	
		I <= "01"; 
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 7: OutLCDlow failed for I=01, from state M25 to M15";
		assert OutLCDHigh="1111111" report "Test 7: OutLCDHigh failed for I=01, from state M25 to M15";
		assert distr='0' report "Test 7: distr failed for I=01, from state M25 to M15";
		wait for 5ns;
		
		-- State M15, inserting 10cents, going to M5	
		I <= "01"; 
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 7: OutLCDlow failed for I=01, from state M15 to M5";
		assert OutLCDHigh="1111111" report "Test 7: OutLCDHigh failed for I=01, from state M15 to M5";
		assert distr='0' report "Test 7: distr failed for I=01, from state M15 to M5";
		wait for 5ns;
		
		-- State M5, inserting 10 cents, going to M25	
		I <= "01"; 
		wait for 15ns;
		assert OutLCDlow="0100100" report "Test 7: OutLCDlow failed for I=01, from state M5 to M25";
		assert OutLCDHigh="1111111" report "Test 7: OutLCDHigh failed for I=01, from state M5 to M25";
		assert distr='1' report "Test 7: distr failed for I=01, from state M5 to M25";
		wait for 5ns;
		
		-- #################################################################
		-- Eighth test: M25--> M20 --> M15 --> M10 --> M5 --> M25, distribute,  return 2X 10 cents
		-- State M25, inserting 5cents, going to M20	
		I <= "00"; 
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 8: OutLCDlow failed for I=00, from state M25 to M20";
		assert OutLCDHigh="1111111" report "Test 8: OutLCDHigh failed for I=00, from state M5 to M20";
		assert distr='0' report "Test 8: distr failed for I=00, from state M25 to M20";
		wait for 5ns;
		
		-- State M20, inserting 5cents, going to M15	
		I <= "00"; 
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 8: OutLCDlow failed for I=00, from state M20 to M15";
		assert OutLCDHigh="1111111" report "Test 8: OutLCDHigh failed for I=00, from state M20 to M15";
		assert distr='0' report "Test 8: distr failed for I=00, from state M20 to M15";
		wait for 5ns;
		
		-- State M15, inserting 5 cents, going to M10	
		I <= "00";
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 8: OutLCDlow failed for I=00, from state M15 to M10";
		assert OutLCDHigh="1111111" report "Test 8: OutLCDHigh failed for I=00, from state M15 to M10";
		assert distr='0' report "Test 8: distr failed for I=00, from state M15 to M10";
		wait for 5ns;
		
		-- State M10, inserting 5 cents, going to M5	
		I <= "00"; 
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 8: OutLCDlow failed for I=00, from state M10 to M5";
		assert OutLCDHigh="1111111" report "Test 8: OutLCDHigh failed for I=01, from state M10 to M5";
		assert distr='0' report "Test 8: distr failed for I=00, from state M10 to M5";
		wait for 5ns;
		
		-- State M5, inserting 25 cents, going to M25	
		I <= "10"; 
		wait for 15ns;
		assert OutLCDlow="0000001" report "Test 8: OutLCDlow failed for I=10, from state M5 to M25";
		assert OutLCDHigh="0010010" report "Test 8: OutLCDHigh failed for I=01, from state M5 to M25";
		assert distr='1' report "Test 8: distr failed for I=10, from state M5 to M25";
		wait for 5ns;
		
		--#################################################
		-- This final test will evaluate if the RESET function works properly
		-- Nineth test: M25 -> M20 -> RESET -> M25 --> M25, distribute, no return
		
		-- State M25, inserting 5cents, going to M20	
		I <= "00"; 
		wait for 15ns;
		assert OutLCDlow="1111111" report "Test 9: OutLCDlow failed for I=00, from state M25 to M20";
		assert OutLCDHigh="1111111" report "Test 9: OutLCDHigh failed for I=00, from state M5 to M20";
		assert distr='0' report "Test 9: distr failed for I=00, from state M25 to M20";
		wait for 5ns;
		
		-- reset pulse (arbitrary duration, in this case 37ns)
		reset <= '1'; 
		assert OutLCDlow="1111111" report "Test 9: OutLCDlow failed for reset";
		assert OutLCDHigh="1111111" report "Test 9: OutLCDHigh failed for reset";
		assert distr='0' report "Test 9: distr failed for reset";
		wait for 37ns; 
		reset <= '0';
		
		
		-- State M25, inserting 25cents, going to M25 	
		
		I <= "10";
		wait for 15ns;
		assert OutLCDlow = "0000001" report "Test 1: OutLCDlow failed for I=10, from state M25 to M25";
		assert OutLCDHigh = "1111111" report "Test 1: OutLCDHigh failed for I=10, from state M25 to M25";
		assert distr='1' report "Test 1: distr failed for I=10, from state M25 to M25";
		wait for 5ns;
		--
		
		wait; -- wait forever
		end process;
end;
