--Bloque sincronizacion: recibe las señales de sincronismo del radar y les aplica el
--mismo delay (en pulsos de reloj) que tiene el conversor analógico digital al 
--digitalizar la señal de video. 

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity sincronizacion is
	generic (
		DELAY_ADC      : natural :=	8	    --Delay ADC
		 );
    
    port(
		-- entradas
		clk, rst                : in std_logic; --!Entrada del clock y reset del sistema
		HM, BI, TRG             : in std_logic; --!Entrada de señales de sincronismo de radar
		-- salidas
		HM_out, BI_out, TRG_out : out std_logic --!Salida de pulsos sincronizados de HM, BI y TRG
		);
end sincronizacion;


architecture ar_sinc of sincronizacion is

	signal auxBI,flancoBI,auxTRG,flancoTRG,auxHM,flancoHM : std_logic; --son señales usadas para detectar flancos
	signal s_TRG_out,s_BI_out,s_HM_out : std_logic; 
	signal QTRG, QBI, QHM: std_logic_vector(DELAY_ADC-1 downto 0); --registro de desplazamiento
	 	  
begin

	--Auxiliares para deteccion de flancos
	flancoBI	<= (not auxBI)  and BI;
	flancoTRG	<= (not auxTRG) and TRG;
	flancoHM	<= (not auxHM)  and HM;

	process(clk,rst)
	begin
		if (rst = '1') then --reset
			s_TRG_out <= '0';
			s_BI_out <= '0';
			s_HM_out <= '0';
			auxBI <= '0';
			auxTRG <= '0';
			auxHM <= '0';
			QTRG <= (others => '0');
			QBI <= (others => '0');
			QHM <= (others => '0');

		elsif( clk'event and clk = '1' ) then 
		      --deteccion de flancos
				auxBI  <= BI;
				auxTRG <= TRG;
				auxHM  <= HM;
					
				QTRG <= flancoTRG & QTRG(DELAY_ADC-1 downto 1); --desplazamiento
				QBI  <= flancoBI  & QBI (DELAY_ADC-1 downto 1);
				QHM  <= flancoHM  & QHM (DELAY_ADC-1 downto 1);
					
				s_TRG_out <= QTRG(0); --elemento saliente a la salida
				s_HM_out  <= QHM(0);
				s_BI_out  <= QBI(0);
				
		end if;
							
	end process;
	
	TRG_out <= s_TRG_out;
	BI_out  <= s_BI_out;
	HM_out  <= s_HM_out;
	
end ar_sinc;