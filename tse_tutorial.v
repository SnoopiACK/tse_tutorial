module tse_tutorial(
	// Clock
	input         CLOCK_50,
	
	// KEY
	input  [3: 0] KEY,
	
	// SW
	input [17:0] SW,
	
	// LEDR Y LEDG
    output [17:0] LEDR,
	 output [8:0] LEDG,
    
    // ADC   
	 output ADC_CLK_A,           //                                     Clock de salida al ADC A
    output ADC_CLK_B,           //                                     Clock de salida al ADC B
    input [13:0] ADC_DA,        //  sincronizado con clk_sampling 	  14 bits que ingresan desde la salida del ADC A
    input [13:0] ADC_DB,        //  sincronizado con clk_sampling 	  14 bits que ingresan desde la salida del ADC B
    output ADC_OEB_A,           //                                     Salida al Output Enable del ADC A. Activo bajo.
    output ADC_OEB_B,           //                                     Salida al Output Enable del ADC B. Activo bajo.

    // PS2
    input PS2_CLK,              //  sincronizado con clk_sampling      input  HM_sig
    input PS2_DAT,              //  sincronizado con clk_sampling      input  TRG_sig
    input PS2_CLK2,             //  sincronizado con clk_sampling      not used
    input PS2_DAT2,             //  sincronizado con clk_sampling      input  BI_sig
    
	 
	// GPIO
	input [35:0] GPIO,	
	
	// Ethernet 0
	output        NET0_MDC,
	inout         NET0_MDIO,
	output        NET0_RESET_N,
	
	// Ethernet 1
	output        NET1_GTX_CLK,
	output        NET1_MDC,
	inout         NET1_MDIO,
	output        NET1_RESET_N,
	input         NET1_RX_CLK,
	input  [3: 0] NET1_RX_DATA,
	input         NET1_RX_DV,
	output [3: 0] NET1_TX_DATA,
	output        NET1_TX_EN
);

	wire sys_clk, clk_125, clk_25, clk_2p5, tx_clk;
	wire core_reset_n;
	wire mdc, mdio_in, mdio_oen, mdio_out;
	wire eth_mode, ena_10;
	wire clk_sampling;
	wire [31:0] SAMPLES_GPIO;
    
	reg [13:0] ADC_DA_sinc;       
	reg [13:0] ADC_DB_sinc;        
	reg PS2_CLK_sinc;              
	reg PS2_DAT_sinc;             
	reg PS2_CLK2_sinc;             
	reg PS2_DAT2_sinc; 	 
	 
	wire decision_sig, rdy_sig, HM_sig, BI_sig, TRG_sig, out_rdy_sig, HMS_out_sig, BIS_out_sig, TRGS_out_sig, video_sig;
    wire [31:0] out_palabra_sig;    

	assign mdio_in   = NET1_MDIO;
	assign NET0_MDC  = mdc;
	assign NET1_MDC  = mdc;
	assign NET0_MDIO = mdio_oen ? 1'bz : mdio_out;
	assign NET1_MDIO = mdio_oen ? 1'bz : mdio_out;
	
	assign NET0_RESET_N = core_reset_n;
	assign NET1_RESET_N = core_reset_n;
	
	// Asignacion de los pines a muestrear
	assign SAMPLES_GPIO = {32'b0,GPIO[15],GPIO[14],GPIO[13],GPIO[12],GPIO[11],GPIO[10],GPIO[9],GPIO[8],GPIO[7],GPIO[6],GPIO[5],GPIO[4],GPIO[3],GPIO[2],GPIO[1],GPIO[0]};
	

	 // Sincronizacion de las senales a muestrear
	 always @ (posedge clk_sampling)
    begin
		ADC_DA_sinc   <= ADC_DA;       
		ADC_DB_sinc   <= ADC_DB;        
		PS2_CLK_sinc  <= PS2_CLK;              
		PS2_DAT_sinc  <= PS2_DAT;             
		PS2_CLK2_sinc <= PS2_CLK2;             
		PS2_DAT2_sinc <= PS2_DAT2; 	 
    end
            

	
	 my_pll pll_inst(
		.areset	(~KEY[0]),
		.inclk0	(CLOCK_50),
		.c0		(sys_clk),
		.c1		(clk_125),
		.c2		(clk_25),
		.c3		(clk_2p5),
		.c4      (clk_sampling),
		.locked	(core_reset_n)
	); 
	
	assign tx_clk = eth_mode ? clk_125 :       // GbE Mode   = 125MHz clock
	                ena_10   ? clk_2p5 :       // 10Mb Mode  = 2.5MHz clock
	                           clk_25;         // 100Mb Mode = 25 MHz clock
	
	my_ddio_out ddio_out_inst(
		.datain_h(1'b1),
		.datain_l(1'b0),
		.outclock(tx_clk),
		.dataout(NET1_GTX_CLK)
	);
	
	nios_system system_inst(
		.clk_clk                                (sys_clk),      //             clk.clk
		.reset_reset_n                          (core_reset_n), //           reset.reset_n	

		.tse_mac_conduit_connection_rx_control  (NET1_RX_DV),   // tse_mac_conduit.rx_control
		.tse_mac_conduit_connection_rx_clk      (NET1_RX_CLK),  //                .rx_clk
		.tse_mac_conduit_connection_tx_control  (NET1_TX_EN),   //                .tx_control
		.tse_mac_conduit_connection_tx_clk      (tx_clk),       //                .tx_clk
		.tse_mac_conduit_connection_rgmii_out   (NET1_TX_DATA), //                .rgmii_out
		.tse_mac_conduit_connection_rgmii_in    (NET1_RX_DATA), //                .rgmii_in
		.tse_mac_conduit_connection_ena_10      (ena_10),       //                .ena_10
		.tse_mac_conduit_connection_eth_mode    (eth_mode),     //                .eth_mode
		.tse_mac_conduit_connection_mdio_in     (mdio_in),      //                .mdio_in
		.tse_mac_conduit_connection_mdio_out    (mdio_out),     //                .mdio_out
		.tse_mac_conduit_connection_mdc         (mdc),          //                .mdc
		.tse_mac_conduit_connection_mdio_oen    (mdio_oen),     //                .mdio_oen
		
      .piosampler_sampler_PIO_INPUT          (out_palabra_sig),          //         piosampler_sampler.PIO_INPUT era SAMPLES_GPIO
      .piosampler_sampler_SAMPLE_CLK         (clk_sampling),          //                           .SAMPLE_CLK		
      .piosampler_sampler_PIO_INPUT_VALID  (out_rdy_sig)     //                           .PIO_INPUT_VALID
	);

    palabra palabra_inst
    ( 
        .clk(clk_sampling) ,	// input  clk_sig
        .rst(~KEY[1]) ,	// input  rst_sig
        .in_CFAR(decision_sig) ,	// input  in_CFAR_sig
        .in_rdy(rdy_sig) ,	// input  in_rdy_sig
        .HM(HM_sig) ,	// input  HM_sig
        .BI(BI_sig) ,	// input  BI_sig
        .TRG(TRG_sig) ,	// input  TRG_sig
        .out_palabra(out_palabra_sig) ,	// output [31:0] out_palabra_sig
        .out_rdy(out_rdy_sig) 	// output  out_rdy_sig
    );

    defparam palabra_inst.BITSCFAR = 19;
    
    conversor conversor_inst
    (
        .CLOCK(clk_sampling),
        .ADC_CLK_A(ADC_CLK_A),
        .ADC_CLK_B(ADC_CLK_B),
        .ADC_DA(ADC_DA_sinc[13:0]),
        .ADC_DB(ADC_DB_sinc[13:0]),
        .ADC_OEB_A(ADC_OEB_A),
        .ADC_OEB_B(ADC_OEB_B),
        .VIDEO(video_sig)		 
    );
    
    
	cfar cfar_inst
    (
        .in_video(video_sig),	// input [data_width-1:0] in_video_sig
        .alpha(SW[13:0]),	// input [data_width-1:0] alpha_sig
        .clk(clk_sampling),	// input  clk_sig
        .rst(~KEY[1]),	    // input  rst_sig
        .TRG_in(TRGS_out_sig),	// input  TRG_in_sig
        .HM_in(HMS_out_sig),	// input  HM_in_sig
        .BI_in(BIS_out_sig),	// input  BI_in_sig
        .decision(decision_sig),	// output  decision_sig
        .rdy(rdy_sig),	// output  rdy_sig
        .TRG_out(TRG_sig),	// output  TRG_out_sig
        .HM_out(HM_sig),	// output  HM_out_sig
        .BI_out(BI_sig) 	// output  BI_out_sig
    );

    defparam cfar_inst.DATA_WIDTH = 14;
    defparam cfar_inst.N = 16;
    defparam cfar_inst.G = 2;

    sincronizacion sincronizacion_inst
    (
        .clk(clk_sampling) ,	// input  clk_sig
        .rst(~KEY[1]) ,	// input  rst_sig
        .HM(PS2_CLK_sinc) ,	// input  HM_sig
        .BI(PS2_DAT2_sinc) ,	// input  BI_sig
        .TRG(PS2_DAT_sinc) ,	// input  TRG_sig
        .HM_out(HMS_out_sig) ,	// output  HM_out_sig
        .BI_out(BIS_out_sig) ,	// output  BI_out_sig
        .TRG_out(TRGS_out_sig) 	// output  TRG_out_sig
    ); 

    defparam sincronizacion_inst.DELAY_ADC = 8;
    
endmodule