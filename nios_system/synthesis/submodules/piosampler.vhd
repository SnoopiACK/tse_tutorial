-------------------------------------------------------------------------------
-- PIO Interface with sampler
-- --------
-- Author: Ricardo Cayssials
-- 02/03/2017   ->      MII and RMII selecition
-- 10/5/2016	->		Created
-- 	
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

LIBRARY altera_mf;
USE altera_mf.all;

entity piosampler is


	generic
		(
            RX_DATA_FIFO_DEPTH         : integer := 512;
            RX_DATA_FIFO_WIDTHU        : integer := 9;
            DEVICE_FAMILY            : string  := "Cyclone IV E"
		);

	port (
        -- ****************************************************************************
        -- piosampler ports
        -- ****************************************************************************
        PIO_INPUT   : in  std_logic_vector(31 downto 0);       -- Data to sample
        PIO_INPUT_VALID   : in  std_logic;       -- Signal to sample input        
		SAMPLE_CLK  : in std_logic;                           -- sampling clock

		-- Avalon Bus signals
        AVALON_CLK              : in std_logic;
		RESET                   : in std_logic;             -- system reset
		
		-- control & status registers (CSR) slave
        avs_csr_chipselect:			in std_logic;
		avs_csr_write:	 			in std_logic;
        avs_csr_read:	 			in std_logic;
		avs_csr_address: 			in std_logic_vector (4 downto 0);
        avs_csr_readdata: 			out std_logic_vector (31 downto 0);
        avs_csr_writedata:			in std_logic_vector (31 downto 0);
		
    
        -- write master
        avm_write_master_write:		out std_logic;
        avm_write_master_address:	out std_logic_vector (27 downto 0);
        avm_write_master_writedata:	out std_logic_vector (31 downto 0);
        avm_write_master_waitrequest:in std_logic
        
 
    );                   
end entity piosampler;


architecture ETH1 of piosampler is



-- CLOCK Control 
component clockctrl
	PORT
	(
		ena		    : IN STD_LOGIC  := '1';
		inclk		: IN STD_LOGIC ;
		outclk		: OUT STD_LOGIC 
	);
end component;

	COMPONENT dcfifo
	GENERIC (
		intended_device_family		: STRING;
		lpm_numwords		: NATURAL;
		lpm_showahead		: STRING;
		lpm_type		: STRING;
		lpm_width		: NATURAL;
		lpm_widthu		: NATURAL;
		overflow_checking		: STRING;
		rdsync_delaypipe		: NATURAL;
		read_aclr_synch		: STRING;
		underflow_checking		: STRING;
		use_eab		: STRING;
		write_aclr_synch		: STRING;
		wrsync_delaypipe		: NATURAL
	);
	PORT (
			rdclk	: IN STD_LOGIC ;
			wrempty	: OUT STD_LOGIC ;
			wrfull	: OUT STD_LOGIC ;
			q	: OUT STD_LOGIC_VECTOR (lpm_width-1 DOWNTO 0);
			rdempty	: OUT STD_LOGIC ;
			rdfull	: OUT STD_LOGIC ;
			wrreq	: IN STD_LOGIC ;
			wrusedw	: OUT STD_LOGIC_VECTOR (lpm_width-1 DOWNTO 0);
			aclr	: IN STD_LOGIC ;
			data	: IN STD_LOGIC_VECTOR (lpm_width-1 DOWNTO 0);
			rdreq	: IN STD_LOGIC ;
			rdusedw	: OUT STD_LOGIC_VECTOR (lpm_width-1 DOWNTO 0);
			wrclk	: IN STD_LOGIC 
	);
	END COMPONENT;
    
                   
   -- Global Data  Accessed through slave-avalon
	constant ADDR0    : std_logic_vector(4 downto 0) := "00000";
	constant ADDR1    : std_logic_vector(4 downto 0) := "00001";	
	constant ADDR2    : std_logic_vector(4 downto 0) := "00010";  
	constant ADDR3    : std_logic_vector(4 downto 0) := "00011";	
	constant ADDR4    : std_logic_vector(4 downto 0) := "00100";  
	constant ADDR5    : std_logic_vector(4 downto 0) := "00101";	
	constant ADDR6    : std_logic_vector(4 downto 0) := "00110";  
	constant ADDR7    : std_logic_vector(4 downto 0) := "00111";   
	constant ADDR8    : std_logic_vector(4 downto 0) := "01000";
	constant ADDR9    : std_logic_vector(4 downto 0) := "01001";
	constant ADDR10   : std_logic_vector(4 downto 0) := "01010"; 
	constant ADDR11   : std_logic_vector(4 downto 0) := "01011"; 	
	constant ADDR12   : std_logic_vector(4 downto 0) := "01100"; 	
    constant ADDR13   : std_logic_vector(4 downto 0) := "01101";  
    constant ADDR14   : std_logic_vector(4 downto 0) := "01110";	
    constant ADDR15   : std_logic_vector(4 downto 0) := "01111";  
    constant ADDR16   : std_logic_vector(4 downto 0) := "10000";	
    constant ADDR17   : std_logic_vector(4 downto 0) := "10001";  
    constant ADDR18   : std_logic_vector(4 downto 0) := "10010";	
    constant ADDR19   : std_logic_vector(4 downto 0) := "10011";	 	
    constant ADDR20   : std_logic_vector(4 downto 0) := "10100";	
    constant ADDR21   : std_logic_vector(4 downto 0) := "10101";		
    constant ADDR22   : std_logic_vector(4 downto 0) := "10110";	    
    constant ADDR23   : std_logic_vector(4 downto 0) := "10111";	
    constant ADDR24   : std_logic_vector(4 downto 0) := "11000";	
	constant ADDR25   : std_logic_vector(4 downto 0) := "11001";	
	constant ADDR26   : std_logic_vector(4 downto 0) := "11010";	    
	constant ADDR27   : std_logic_vector(4 downto 0) := "11011";	
	constant ADDR28   : std_logic_vector(4 downto 0) := "11100";	    
	constant ADDR29   : std_logic_vector(4 downto 0) := "11101";	        
	constant ADDR30   : std_logic_vector(4 downto 0) := "11110";	            
	constant ADDR31   : std_logic_vector(4 downto 0) := "11111";
	
    signal sampled_pio_input1   : std_logic_vector(31 downto 0);       -- Data to sampled
    signal sampled_pio_input2   : std_logic_vector(31 downto 0);       -- Data to sampled
    signal RXC_RX_DATA_DATA   : std_logic_vector(31 downto 0);       -- Data to sampled    
    signal RXC_RX_DATA_WRREQ_NEW : std_logic;    
    
    signal CONTROL_STATUS_REG    : std_logic_vector(31 downto 0);
    -- alias  CONTROL_STATUS_REG         : std_logic_vector(31 downto 0) is CONTROL_STATUS_REG;

    signal BYTES_TO_TRANSFER_REG : std_logic_vector(31 downto 0);    
    -- alias  BYTES_TO_TRANSFER_REG         : std_logic_vector(31 downto 0) is BYTES_TO_TRANSFER_REG;

    signal ADDRESS_TO_WRITE      : std_logic_vector(31 downto 0);    
    -- alias ADDRESS_TO_WRITE         : std_logic_vector(31 downto 0) is ADDRESS_TO_WRITE;

    signal sampled_counter     : std_logic_vector(31 downto 0);   
    signal sampled_counter2    : std_logic_vector(31 downto 0);       
    signal AVC_ETH_REG_3 : std_logic_vector(31 downto 0);
    
    signal AVC_ETH_REG_4 : std_logic_vector(31 downto 0);
    signal AVC_ETH_REG_5 : std_logic_vector(31 downto 0);
    signal AVC_ETH_REG_6 : std_logic_vector(31 downto 0);
    signal AVC_ETH_REG_7 : std_logic_vector(31 downto 0);

    signal TRANSFER_BYTE_COUNTER   : std_logic_vector(31 downto 0);
    -- Bit 0 hace transferir nuevo burst

     signal ADDRESS                 : std_logic_vector(31 downto 0);
     signal OFFSET_TO_WRITE         : std_logic_vector(31 downto 0);
     signal AVC_RX_DATA_Q           : std_logic_vector(31 downto 0);
     signal WRITTING_STATE          : std_logic_vector(1 downto 0);
     signal RXC_RX_DATA_WRFULL	    : std_logic;
	 signal AVC_BUS_WR              : std_logic;
	 signal AVC_RX_DATA_RDEMPTY     : std_logic;
	 signal AVC_RX_DATA_RDREQ       : std_logic;

    

begin

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Access to Global Registers through slave_avalon
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
	WITH avs_csr_address SELECT
	    avs_csr_readdata <= std_logic_vector(CONTROL_STATUS_REG) when ADDR0,
							std_logic_vector(BYTES_TO_TRANSFER_REG) when ADDR1,
							std_logic_vector(ADDRESS_TO_WRITE) when ADDR2,
							std_logic_vector(sampled_counter + 1) when ADDR3,
                            std_logic_vector(ADDRESS) when ADDR4,
                            std_logic_vector(OFFSET_TO_WRITE) when ADDR5,
                            std_logic_vector(AVC_RX_DATA_Q) when ADDR6,
                            std_logic_vector("00000000000000000000000000" & WRITTING_STATE & RXC_RX_DATA_WRFULL & AVC_BUS_WR & AVC_RX_DATA_RDEMPTY & AVC_RX_DATA_RDREQ) when ADDR7,
                            std_logic_vector(TRANSFER_BYTE_COUNTER) when ADDR8,
							(others => '-') when others;
											
AVS_CSR_Avalon_Write:
	process(RESET, AVALON_CLK) is 
	begin 
		if (RESET = '1') then
			CONTROL_STATUS_REG <= "00000000000000000000000000000000";
			BYTES_TO_TRANSFER_REG <= "00000000000000000000000000000010"; 
			ADDRESS_TO_WRITE <= "00000000000000000000000000000011";
			AVC_ETH_REG_3 <= "00000000000000000000000000000100";
			AVC_ETH_REG_4 <= "00000000000000000000000000000101";
			AVC_ETH_REG_5 <= "00000000000000000000000000000110";
			AVC_ETH_REG_6 <= "00000000000000000000000000000111";
			AVC_ETH_REG_7 <= "00000000000000000000000000001000";
		elsif (AVALON_CLK'event and AVALON_CLK = '1') then
            -- Modify register from avalon slave bus
            if CONTROL_STATUS_REG(0) = '1' and TRANSFER_BYTE_COUNTER /= 0 then
                CONTROL_STATUS_REG(0) <= '0';
            end if;
            if (avs_csr_write = '1' and avs_csr_chipselect = '1') then
                case avs_csr_address is
                    when ADDR0 => 
                        CONTROL_STATUS_REG <= avs_csr_writedata;
                    when ADDR1 => 
                        BYTES_TO_TRANSFER_REG <= avs_csr_writedata; 
                    when ADDR2 => 
                        ADDRESS_TO_WRITE <= avs_csr_writedata;
                    when ADDR3 => 
                        AVC_ETH_REG_3 <= avs_csr_writedata;
                    when ADDR4 => 
                        AVC_ETH_REG_4 <= avs_csr_writedata;
                    when ADDR5 => 
                        AVC_ETH_REG_5 <= avs_csr_writedata;
                    when ADDR6 => 
                        AVC_ETH_REG_6 <= avs_csr_writedata;
                    when ADDR7 => 
                        AVC_ETH_REG_7 <= avs_csr_writedata;
                    when others =>
                end case;
            end if;
		end if;
	end process; 	


	process(SAMPLE_CLK) is 
	begin 
        if (SAMPLE_CLK'event and SAMPLE_CLK = '1') then
            sampled_counter <= sampled_counter + 1;
            sampled_counter2 <= sampled_counter;
            sampled_pio_input1 <= PIO_INPUT;
            sampled_pio_input2 <= sampled_pio_input1;
        end if;
    end process;

--RXC_RX_DATA_DATA  <= sampled_counter(7 downto 0) & sampled_pio_input1(23 downto 0);
--RXC_RX_DATA_DATA  <= sampled_counter(3 downto 0) & sampled_pio_input1(11 downto 0) & sampled_counter2(3 downto 0) & sampled_pio_input2(11 downto 0);

RXC_RX_DATA_DATA  <= PIO_INPUT;

--RXC_RX_DATA_WRREQ_NEW <= '0' when RXC_RX_DATA_WRFULL = '1' else
--                         sampled_counter(0);

RXC_RX_DATA_WRREQ_NEW <= '0' when RXC_RX_DATA_WRFULL = '1' else
                         PIO_INPUT_VALID;

-- Avalon Master
-- write master             
avm_write_master_write     <= AVC_BUS_WR;
avm_write_master_address   <= ADDRESS(27 downto 0);
avm_write_master_writedata <= AVC_RX_DATA_Q;

ADDRESS <= ADDRESS_TO_WRITE + OFFSET_TO_WRITE;

	process(RESET, AVALON_CLK) is 
	begin 
		if (RESET = '1') then
            AVC_BUS_WR <= '0';
            WRITTING_STATE <= "00";
            OFFSET_TO_WRITE <= (others => '0');
			TRANSFER_BYTE_COUNTER <= (others => '0');
		elsif (AVALON_CLK'event and AVALON_CLK = '1') then
            -- AVC_BUS_WR <= '0';   
            if ADDRESS_TO_WRITE /= 0 then				
                if (WRITTING_STATE = "00" and TRANSFER_BYTE_COUNTER /= 0 and AVC_RX_DATA_RDEMPTY = '0') then
                     -- Comienzo ciclo de escritura
                     AVC_BUS_WR <= '1';
                     WRITTING_STATE <= "01";
                end if;
                if (WRITTING_STATE = "01" and avm_write_master_waitrequest = '0') then
                     AVC_BUS_WR <= '0';   
                     WRITTING_STATE <= "00";
                     OFFSET_TO_WRITE <= OFFSET_TO_WRITE + 4;
                     TRANSFER_BYTE_COUNTER <= TRANSFER_BYTE_COUNTER - 1;
                end if;
                if WRITTING_STATE = "00" and CONTROL_STATUS_REG(0) = '1' and TRANSFER_BYTE_COUNTER = 0 then
                     TRANSFER_BYTE_COUNTER <= BYTES_TO_TRANSFER_REG;
                     OFFSET_TO_WRITE <= (others => '0');
                end if;
			end if;
        end if;
    end process;
    
    AVC_RX_DATA_RDREQ <= '1' when WRITTING_STATE = "01" and avm_write_master_waitrequest = '0' else
                         '0';
    
	RX_DATA_FIFO_inst : dcfifo
	GENERIC MAP (
		intended_device_family => DEVICE_FAMILY, --"Cyclone IV E",
		lpm_numwords => RX_DATA_FIFO_DEPTH,
		lpm_showahead => "ON",
		lpm_type => "dcfifo",
		lpm_width => 32,
		lpm_widthu => RX_DATA_FIFO_WIDTHU,
		overflow_checking => "ON",
		rdsync_delaypipe => 6,
		read_aclr_synch => "ON",
		underflow_checking => "ON",
		use_eab => "ON",
		write_aclr_synch => "ON",
		wrsync_delaypipe => 6
	)
	PORT MAP (
		rdclk   => AVALON_CLK,
		wrclk   => SAMPLE_CLK,
		wrreq   => RXC_RX_DATA_WRREQ_NEW,
		aclr    => RESET,
		data    => RXC_RX_DATA_DATA,
		rdreq   => AVC_RX_DATA_RDREQ,  -- 
		wrfull  => RXC_RX_DATA_WRFULL, 
		q       => AVC_RX_DATA_Q,      
		rdempty => AVC_RX_DATA_RDEMPTY 
	);    
    
     
end architecture ETH1;	

