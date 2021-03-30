--Bloque palabra: forma una palabra de 32 bits con las señales de sincronismo y la
--salida de decisión del bloque CFAR. Dicha palabra es la que se transmite por Ethernet.

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

entity palabra is
	generic (
      BITSCFAR: natural := 19 --Cantidad de bits del CFAR en la palabra
		);
	port(
		-- entradas
		clk, rst                : in std_logic;                      --Entrada del clock y reset del sistema
		in_CFAR                 : in std_logic;                      --Bit de la salida de decision del CFAR
		in_rdy                  : in std_logic;                      --La salida del CFAR es válida
		HM, BI, TRG             : in std_logic;                      --Entrada de señales de sincronismo de radar
		-- salidas
		out_palabra             : out std_logic_vector(31 downto 0); --Palabra de 32 bits a ser transmitida por Ethernet
		out_rdy                 : out std_logic                      --Palabra completa (lista para transmitirse)
		);
end palabra;


architecture ar_palabra of palabra is

	signal s_palabra_CFAR : std_logic_vector(BITSCFAR-1 downto 0); --Subpalabra con los bits CFAR 
    signal s_palabra_SINC : std_logic_vector(31-BITSCFAR-2 downto 0); --Subpalabra con los bits de las señales de sincronismo
    signal s_palabra_SEQ  : std_logic_vector(1 downto 0); --Subpalabra con la secuencia
    signal s_out_rdy : std_logic;
    signal contador: unsigned (4 downto 0); --cuenta hasta BITSCFAR-1 para formar una palabra con los bits entrantes
    signal contador_seq: unsigned(1 downto 0); --cuenta hasta 3 para asignarle el valor a la secuencia

begin
	
	process(clk,rst)
	
	begin
		if (rst = '1') then --reset
			s_palabra_CFAR <= (others => '0');
         s_palabra_SINC <= (others => '0');
         s_palabra_SEQ  <= (others => '0');
         s_out_rdy <= '0';
         contador<= (others => '0');
         contador_seq <= (others => '0');

		elsif( clk'event and clk = '1' ) then 
			if(s_out_rdy = '1') then     --pulso que va al write de la memoria
                s_out_rdy <= '0';   --Para que no escriba mas de una vez
         end if;   
         
			if(contador = "00000") then
				s_palabra_CFAR <= (0 => in_CFAR, others => '0'); --Bit 0 : entrada de CFAR , Bits restantes=0
				s_palabra_SINC <= (others => '0');
			else
				s_palabra_CFAR <= s_palabra_CFAR(BITSCFAR-2 downto 0) & in_CFAR; --Desplazamiento
			end if;
				
			if(contador = to_unsigned(BITSCFAR-1, 5)) then --18
				contador <= (others => '0'); --Reinicia contador
            s_out_rdy <= '1'; --Palabra completa
            s_palabra_SEQ <= std_logic_vector(contador_seq); --Actualizo secuencia
            if(contador_seq = "11") then
					contador_seq <= (others => '0');
            else  
               contador_seq <= contador_seq+1;
            end if;      
         else
				contador <= contador + 1;
			end if;
            
         if (TRG='1') then
				s_palabra_SINC(4 downto 0)<= std_logic_vector(contador+1); --Se registra cuando ocurrio el TRG
			end if;
			
			if (BI='1') then
				s_palabra_SINC(9 downto 5)<= std_logic_vector(contador+1); --Se registra cuando ocurrio el BI
			end if;
			
			if (HM='1') then
				s_palabra_SINC(10)<= '1'; --Se registra si ocurrio el HM
			end if;
      end if;
	end process;
	
   out_rdy 	<= s_out_rdy;
	out_palabra <= s_palabra_SEQ & s_palabra_SINC & s_palabra_CFAR; --Palabra final como suma de las tres subpalabras
	
end ar_palabra;