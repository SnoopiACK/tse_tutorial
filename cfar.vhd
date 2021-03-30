--Bloque CFAR: realiza el filtrado CA-CFAR para detección de blancos y retrasa las señales
--de sincronismo para que coincidan con la señal de video.

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;   --signed, unsigned
	

entity cfar is

	generic (
		DATA_WIDTH           : natural :=	14;	        --Tamaño en bits de cada dato del registro de desplazamiento (14 bits de video)
		N          	         : natural :=	16;         --Cantidad de celdas de referencia (potencia de 2)
		G                    : natural :=	2           --Cantidad de celdas de guarda (potencia de 2)
		 );
	port
	(
		-- Entradas
		in_video              : in unsigned (DATA_WIDTH-1 downto 0);   --Entrada de video --> conversor de 14 bits
		alpha                 : in unsigned (DATA_WIDTH-1 downto 0);   --Constante CFAR
		clk                   : in std_logic;                          --Entrada de reloj
		rst                   : in std_logic;                          --Reset
		TRG_in,HM_in,BI_in    : in std_logic;                          --Señales de sincronismo: Trigger,BI,HM (sincronizadas con clk)
        
		-- Salida
		decision              : out std_logic;				           --Salida de decision del CFAR, '1' hay blanco, '0' no hay blanco
		rdy                   : out std_logic;                         --Salida de indicación de llenado del registro de desplazamiento
        TRG_out,HM_out,BI_out : out std_logic                          --Señales de sincronismos atrasadas

	);
end cfar;


architecture ar_cfar of cfar is

type shift_register is array (N+G downto 0) of unsigned (DATA_WIDTH-1 downto 0);
signal Q: shift_register;                                  --Registro de desplazamiento (video)
signal QTRG, QBI, QHM: std_logic_vector(N/2+G/2 downto 0); --Registro de desplazamiento (señales de sincronismo)
signal cont: natural;                                      --Contador
signal promedio : unsigned(DATA_WIDTH+N downto 0);
signal U	: unsigned(2*DATA_WIDTH-1 downto 0);           -- UMBRAL, resultado de la multiplicacion (largo 2*DATA_WIDTH bits)

signal s_TRG_out, s_BI_out, s_HM_out : std_logic;

signal sumaIzq, sumaIzq_a : unsigned(DATA_WIDTH+N-1 downto 0);
signal sumaDer, sumaDer_a : unsigned(DATA_WIDTH+N-1 downto 0);

begin
	process(clk,rst)
		begin
			if (rst='1') then	                       --reset
				Q    <= (others => (others => '0'));
				cont <= 0;
            QTRG <= (others => '0');
            QBI  <= (others => '0');
            QHM  <= (others => '0');
				
			elsif(clk'event and clk='1') then
				
				if (TRG_in = '1') then 
					Q <= (others => (others => '0')); --Se reinicia el video cuando llega TRG (se vacia el registro)
					cont <= 0;
					sumaDer <= (others => '0');
					sumaIzq <= (others => '0');
				else
					Q <= in_video & Q(N+G downto 1); --Desplazamiento
					cont <= cont+1;
					sumaDer <= sumaDer_a + Q(N/2) - Q(0); --Suma=Suma_anterior + nuevo elemento - elemento saliente
					sumaIzq <= sumaIzq_a + in_video - Q(N/2+G+1); --Suma=Suma_anterior + nuevo elemento - elemento saliente
            end if;           
					
				QTRG <= TRG_in & QTRG(N/2+G/2 downto 1); --Desplazamiento
            QBI  <= BI_in  & QBI (N/2+G/2 downto 1);
            QHM  <= HM_in  & QHM (N/2+G/2 downto 1);
					
				s_TRG_out <= QTRG(0); --Elemento saliente a la salida
            s_HM_out  <= QHM(0);
            s_BI_out  <= QBI(0);

			end if;	
	end process;
	
   TRG_out <= s_TRG_out;
	BI_out  <= s_BI_out;
	HM_out  <= s_HM_out;
	sumaDer_a <= sumaDer; --Actualizacion de la suma
	sumaIzq_a <= sumaIzq;
    
	process(sumaDer,sumaIzq,alpha,promedio)
		begin
			promedio <= (('0' & sumaDer) + ('0' & sumaIzq))/N;    
			U <= promedio(DATA_WIDTH-1 downto 0)*alpha; --Umbral
		end process;
        
   rdy <= '1' when (cont >= ( N + G )) else '0'; --Salida valida si el registro esta lleno
	decision <= '0' when (
								(Q( N/2 + G/2 ) < U) or (cont < ( N + G ))) 
								 else '1';
   
end ar_cfar;