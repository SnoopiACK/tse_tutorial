--Bloque conversor: permite configurar los pines del ADC y entrega a la salida la señal de video digitalizada.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conversor is
	 port(CLOCK					   : in 	 std_logic;		                    --Entrada de clock para los conversores
			ADC_CLK_A              : out     std_logic;		                    --Clock de salida al ADC A
			ADC_CLK_B              : out     std_logic;		                    --Clock de salida al ADC B
			ADC_DA           	   : in 	 std_logic_vector(13 downto 0);	    --14 bits que ingresan desde la salida del ADC A
			ADC_DB           	   : in 	 std_logic_vector(13 downto 0);	    --14 bits que ingresan desde la salida del ADC B
			ADC_OEB_A              : out     std_logic;		                    --Salida al Output Enable del ADC A. Activo bajo.
			ADC_OEB_B              : out     std_logic;		                    --Salida al Output Enable del ADC B. Activo bajo.
			VIDEO				   : out 	 std_logic_vector(13 downto 0)      --Señal de salida con los 14 bits de video.
            );
end conversor;

                
architecture ar_conversor of conversor is
   
begin

	ADC_CLK_A <= CLOCK;	--Clock de captura del ADC = 16,667MHz
	ADC_OEB_A <= '0';   --Habilito Salida del ADC A
	ADC_CLK_B <= '0';	--Deshabilito Salida del ADC B
	ADC_OEB_B <= '1';
	VIDEO <= ADC_DA(13 downto 0); --Toma los 14 bits de salida del ADC A

end ar_conversor; 