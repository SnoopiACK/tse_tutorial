#####################################################################################
# Copyright (C) 1991-2009 Altera Corporation
# Any  megafunction  design,  and related netlist (encrypted  or  decrypted),
# support information,  device programming or simulation file,  and any other
# associated  documentation or information  provided by  Altera  or a partner
# under  Altera's   Megafunction   Partnership   Program  may  be  used  only
# to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any
# other  use  of such  megafunction  design,  netlist,  support  information,
# device programming or simulation file,  or any other  related documentation
# or information  is prohibited  for  any  other purpose,  including, but not
# limited to  modification,  reverse engineering,  de-compiling, or use  with
# any other  silicon devices,  unless such use is  explicitly  licensed under
# a separate agreement with  Altera  or a megafunction partner.  Title to the
# intellectual property,  including patents,  copyrights,  trademarks,  trade
# secrets,  or maskworks,  embodied in any such megafunction design, netlist,
# support  information,  device programming or simulation file,  or any other
# related documentation or information provided by  Altera  or a megafunction
# partner, remains with Altera, the megafunction partner, or their respective
# licensors. No other licenses, including any licenses needed under any third
# party's intellectual property, are provided herein.
#####################################################################################

#####################################################################################
# Altera Triple-Speed Ethernet Megacore SDC file for use with the Quartus II 
# TimeQuest Timing Analyzer
#
# To add this SDC file to your Quartus II project execute the following TCL
# command in the Quartus II TCL console:
# set_global_assignment -name SDC_FILE "nios_system_tse_mac"_constraints.sdc
#
# Generated on Fri Nov 16 10:02:51 ART 2018
#
#####################################################################################





# *************************************************************
# Customer modifiable constraints, value is set default by constraints
# *************************************************************

# Hierarchical path to the TSE
set SYSTEM_PATH_PREFIX ""

# Frequency of network-side interface clocks or reference clocks
set TSE_CLOCK_FREQUENCY "125 MHz"

# Frequency of FIFO data interface clocks
set FIFO_CLOCK_FREQUENCY "100 MHz"

# Frequency of control and status interface clock
set DEFAULT_SYSTEM_CLOCK_SPEED "66 MHz"  

# Frequency of phase measure clock
set PHASE_MEASURE_CLOCK_SPEED "66 MHz"   

# Name the clocks that will be coming into the tse core named changed from top level   
set  TX_CLK             "tx_clk"                        
set  RX_CLK             "rx_clk"                        
set  CLK                "clk"
set  FF_TX_CLK          "ff_tx_clk"
set  FF_RX_CLK          "ff_rx_clk"
set  TBI_TX_CLK         "tbi_tx_clk"
set  TBI_RX_CLK         "tbi_rx_clk"
set  REF_CLK            "ref_clk"
set  PCS_PHASE_MEASURE_CLK "pcs_phase_measure_clk"





# **************************************************************************************************
# ********************** Please do not modify anything beyond this line ****************************
# *********** The script might not work correctly if the following lines are modified **************
# **************************************************************************************************

# Generated TSE variation - Do not modify
# General Option
set IS_SOPC 1
set VARIATION_NAME "nios_system_tse_mac"
set DEVICE_FAMILY "CYCLONEIVE"

# MAC Option
set IS_MAC 1
set NUMBER_OF_CHANNEL 1
set IS_SMALLMAC 0
set IS_SMALLMAC_GIGE 0
set IS_FIFOLESS 0
set IS_HALFDUPLEX 32
set MII_INTERFACE "RGMII"
set ENA_HASH 0
set ENABLE_MAGIC_DETECT 0
set STAT_CNT_ENA 1
set ENABLE_EXTENDED_STAT_REG 0
set ENABLE_SUP_ADDR 0
set ENABLE_MAC_FLOW_CTRL 0

# PCS Option
set IS_PCS 0
set IS_SGMII 0

# PMA Option
set IS_PMA 0
set TRANSCEIVER_TYPE 0

# GXB Option
set IS_POWERDOWN 0

# 1588 Option
set IS_1588	0


   
if { [ expr ($TRANSCEIVER_TYPE == 0)]} {
	set CLOCK_1  "U_RXCLK"
	set CLOCK_2 "U_TXCLK"
} else {
	set CLOCK_1 "U_RXCLK"
	set CLOCK_2 "U_TXCLK"
}

if { [ expr ($IS_SOPC == 1) ]} {
   set FROM_THE_VARIATION_NAME "_from_the_$VARIATION_NAME"
   set TO_THE_VARIATION_NAME "_to_the_$VARIATION_NAME"
} else {
   set FROM_THE_VARIATION_NAME ""
   set TO_THE_VARIATION_NAME ""
}


#**************************************************************
# Time Information
#**************************************************************
# Uncommenting the following derive_pll_clocks lines
# will instruct the TimeQuest Timing Analyzer to automatically
# create derived clocks for all PLL outputs for all PLLs in a
# Quartus design.

# If the PLL inputs and outputs are not constrained elsewhere, 
# uncomment the next line to automatically constrain all PLL input 
# and output clocks.

# derive_pll_clocks 

# If the PLL inputs and outputs are not constrained elsewhere,
# and derive_pll_clocks is not apply, user will get Critical warnings
# Critical Warning: Register-to-register paths between different clock 
# domains is not recommended if one of the clocks is from GXB 
# transmitter channel. 
# Critical Warning: Register-to-register paths between different clock 
# domains is not recommended if one of the clocks is from GXB 
# receiver channel.
# This Critical Warning can be safely ignore and it will gone if 
# PLL inputs and outputs clock are properly constraint. 

#**************************************************************
# Create Clock
#**************************************************************

#Constrain timing for half duplex logic
#  - Direct path as we are confirmed of this path
if { [ expr ( $IS_FIFOLESS == 0 )] } {

#  mac
   if { [ expr ($IS_MAC == 1) && ($IS_PCS == 0) && ($IS_PMA == 0)] } {
      #Constrain MAC control interface clock
      create_clock -period "$DEFAULT_SYSTEM_CLOCK_SPEED" -name altera_tse_${CLK}_$TO_THE_VARIATION_NAME [ get_ports  $CLK]

      #Constrain MAC FIFO data interface clocks
      create_clock -period "$FIFO_CLOCK_FREQUENCY" -name altera_tse_${FF_TX_CLK}_$TO_THE_VARIATION_NAME [ get_ports $FF_TX_CLK]
      create_clock -period "$FIFO_CLOCK_FREQUENCY" -name altera_tse_${FF_RX_CLK}_$TO_THE_VARIATION_NAME [ get_ports $FF_RX_CLK]

      #Constrain MAC network-side interface clocks
      create_clock -period "$TSE_CLOCK_FREQUENCY" -name altera_tse_${TX_CLK}_$TO_THE_VARIATION_NAME [ get_ports $TX_CLK]
      create_clock -period "$TSE_CLOCK_FREQUENCY" -name altera_tse_${RX_CLK}_$TO_THE_VARIATION_NAME [ get_ports $RX_CLK]
   }

   #  macPcs
   if { [ expr ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 0) ] } {
      #Constrain MAC PCS control interface clock
      create_clock -period "$DEFAULT_SYSTEM_CLOCK_SPEED" -name altera_tse_${CLK}_$TO_THE_VARIATION_NAME [ get_ports  $CLK]

      #Constrain MAC PCS FIFO data interface clocks
      create_clock -period "$FIFO_CLOCK_FREQUENCY" -name altera_tse_${FF_TX_CLK}_$TO_THE_VARIATION_NAME [ get_ports $FF_TX_CLK]
      create_clock -period "$FIFO_CLOCK_FREQUENCY" -name altera_tse_${FF_RX_CLK}_$TO_THE_VARIATION_NAME [ get_ports $FF_RX_CLK]

      #Constrain MAC PCS network-side interface clocks 
      create_clock -period "$TSE_CLOCK_FREQUENCY" -name altera_tse_${TBI_RX_CLK}_$TO_THE_VARIATION_NAME [ get_ports $TBI_RX_CLK]
      create_clock -period "$TSE_CLOCK_FREQUENCY" -name altera_tse_${TBI_TX_CLK}_$TO_THE_VARIATION_NAME [ get_ports $TBI_TX_CLK]
   }

   #  macPcsPma
   if { [ expr ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 1) ] } {

      #Constrain transceiver reference clock
      create_clock -period "$TSE_CLOCK_FREQUENCY" -name altera_tse_${REF_CLK}_$TO_THE_VARIATION_NAME [ get_ports  $REF_CLK]

      #Constrain MAC PCS control interface clock
      create_clock -period "$DEFAULT_SYSTEM_CLOCK_SPEED" -name altera_tse_${CLK}_$TO_THE_VARIATION_NAME [ get_ports  $CLK]

      #Constrain MAC PCS FIFO data interface clocks
      create_clock -period "$FIFO_CLOCK_FREQUENCY" -name altera_tse_${FF_TX_CLK}_$TO_THE_VARIATION_NAME [ get_ports $FF_TX_CLK]
      create_clock -period "$FIFO_CLOCK_FREQUENCY" -name altera_tse_${FF_RX_CLK}_$TO_THE_VARIATION_NAME [ get_ports $FF_RX_CLK]
   }

   #  pcs
   if { [ expr ($IS_MAC == 0) && ($IS_PCS == 1) && ($IS_PMA == 0) ] } {

	  #Cut the timing path betweeen unrelated clock domains
	  
   }

   #  pcsPma
   if { [ expr ($IS_MAC == 0) && ($IS_PCS == 1) && ($IS_PMA == 1) ] } {
      #Constrain PCS control interface clock
      create_clock -period "$DEFAULT_SYSTEM_CLOCK_SPEED" -name altera_tse_${CLK}_$TO_THE_VARIATION_NAME [ get_ports $CLK]

      #Constrain transceiver reference clock
      create_clock -period "$TSE_CLOCK_FREQUENCY" -name altera_tse_${REF_CLK}_$TO_THE_VARIATION_NAME [ get_ports  $REF_CLK]
   }

   #  macPcsSgmii
   if { [ expr ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 0) && ($IS_SGMII == 1)] } {
   }

   # macPcsNoSgmii
   if { [ expr ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 0) && ($IS_SGMII == 0)] } {

   }

   #  macPcsPmaSgmii
   if { [ expr ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 1)] } {
   }

   #  macPcsPmaNoSgmii
   if { [ expr ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 0)] } {
   }

   #  pmaAlt4Gxb
   if { [expr ($TRANSCEIVER_TYPE == 0) && ($IS_PMA == 1) && (([string match $DEVICE_FAMILY "STRATIXIV"]) || ([string match $DEVICE_FAMILY "ARRIAIIGX"]) || ([string match $DEVICE_FAMILY "HARDCOPYIV"]) ) ] } {
   }

   #  pcsSgmii
   if { [ expr ($IS_MAC == 0) && ($IS_PCS == 1) && ($IS_PMA == 0) && ($IS_SGMII == 1)] } {
      #Constrain PCS GMII/MII interface clocks 
      create_clock -period "$DEFAULT_SYSTEM_CLOCK_SPEED" -name altera_tse_REG_CLK_$TO_THE_VARIATION_NAME [ get_ports reg_clk]
      create_clock -period "$TSE_CLOCK_FREQUENCY" -name altera_tse_${TBI_RX_CLK}_$TO_THE_VARIATION_NAME [ get_ports $TBI_RX_CLK]
      create_clock -period "$TSE_CLOCK_FREQUENCY" -name altera_tse_${TBI_TX_CLK}_$TO_THE_VARIATION_NAME [ get_ports $TBI_TX_CLK]
    }

   #  pcsNoSgmii
   if { [ expr ($IS_MAC == 0) && ($IS_PCS == 1) && ($IS_PMA == 0) && ($IS_SGMII == 0)] } {
      #Constrain PCS control interface clock
      create_clock -period "$DEFAULT_SYSTEM_CLOCK_SPEED" -name altera_tse_REG_CLK_$TO_THE_VARIATION_NAME [ get_ports reg_clk]

      #Constrain PCS network-side interface clocks
      create_clock -period "$TSE_CLOCK_FREQUENCY" -name altera_tse_${TBI_RX_CLK}_$TO_THE_VARIATION_NAME [ get_ports $TBI_RX_CLK]
      create_clock -period "$TSE_CLOCK_FREQUENCY" -name altera_tse_${TBI_TX_CLK}_$TO_THE_VARIATION_NAME [ get_ports $TBI_TX_CLK]
	  
   }

   #  pcsPmaSgmii
   if { [ expr ($IS_MAC == 0) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 1)] } {
      #Constrain PCS GMII/MII interface clocks 
   } 
   

   #  pcsPmaNoSgmii
   if { [ expr ($IS_MAC == 0) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 1)] } {
   }

   #  macPcsPmaLvdsSgmii
   if { [ expr ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 1) && ($TRANSCEIVER_TYPE == 1)] } {
     #Cut the timing path betweeen unrelated clock domains
   }

   #  macPcsPmaLvdsNoSgmii
   if { [ expr ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 0) && ($TRANSCEIVER_TYPE == 1)] } {
   }

   #  macPcsPmaTransceiverSgmii=
   if { [ expr ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 1) && ($TRANSCEIVER_TYPE == 0) && (([string match $DEVICE_FAMILY "STRATIXIIGX"]) || ([string match $DEVICE_FAMILY "ARRIAGX"]))] } {

   }

   #  macPcsPmaTransceiverNoSgmii=
   if { [ expr ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 0) && ($TRANSCEIVER_TYPE == 0) && (([string match $DEVICE_FAMILY "STRATIXIIGX"]) || ([string match $DEVICE_FAMILY "ARRIAGX"]))] } {

   }

   #  pcsPmaLvdsSgmii=
   if { [ expr ($IS_MAC == 0) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 1) && ($TRANSCEIVER_TYPE == 1)] } {
   }

   #  pcsPmaLvdsNoSgmii
   if { [ expr ($IS_MAC == 0) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 0) && ($TRANSCEIVER_TYPE == 1)] } {
   }

   #  pcsPmaTransceiverSgmii
   if { [ expr ($IS_MAC == 0) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 1) && ($TRANSCEIVER_TYPE == 0) && (([string match $DEVICE_FAMILY "STRATIXIIGX"]) || ([string match $DEVICE_FAMILY "ARRIAGX"])) ] } {
   }

   #  pcsPmaTransceiverNoSgmii
   if { [ expr ($IS_MAC == 0) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 0) && ($TRANSCEIVER_TYPE == 0) && (([string match $DEVICE_FAMILY "STRATIXIIGX"]) || ([string match $DEVICE_FAMILY "ARRIAGX"]))] } {
   }

} else {

#  multiChannelFifoless


#**************************************************************
# Set Parameter
#**************************************************************
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
#**************************************************************

#All clocks used by TSE is named with prefix "altera_tse"
#Constrain MAC PCS control interface clock

if { [ expr $IS_SOPC == 0 ] } {
	create_clock -period "$DEFAULT_SYSTEM_CLOCK_SPEED" -name altera_tse_sys_clk [ get_ports "$CLK"]
}

if { [ expr ($IS_FIFOLESS == 1) ] } {
   for {set x 0} {$x < $NUMBER_OF_CHANNEL} {incr x} {
   		if { [ expr ($IS_SOPC == 0) ] } {
			create_clock -period "$TSE_CLOCK_FREQUENCY" -name "altera_tse_mac_tx_clk_${x}" [ get_ports "${SYSTEM_PATH_PREFIX}mac_tx_clk_${x}${FROM_THE_VARIATION_NAME}" ]
			create_clock -period "$TSE_CLOCK_FREQUENCY" -name "altera_tse_mac_rx_clk_${x}" [ get_ports "${SYSTEM_PATH_PREFIX}mac_rx_clk_${x}${FROM_THE_VARIATION_NAME}" ]
		} else {
			create_clock -period "$TSE_CLOCK_FREQUENCY" -name "altera_tse_mac_tx_clk_${x}" [ get_ports "${SYSTEM_PATH_PREFIX}${VARIATION_NAME}_mac_rx_clk_${x}_out" ]
			create_clock -period "$TSE_CLOCK_FREQUENCY" -name "altera_tse_mac_rx_clk_${x}" [ get_ports "${SYSTEM_PATH_PREFIX}${VARIATION_NAME}_mac_tx_clk_${x}_out" ]
		}
   }
}

# Mac
if { [ expr ($IS_FIFOLESS == 1) && ($IS_MAC == 1) && ($IS_PCS == 0) && ($IS_PMA == 0) ] } {
   for {set x 0} {$x < $NUMBER_OF_CHANNEL} {incr x} {
		create_clock -period "$TSE_CLOCK_FREQUENCY" -name "altera_tse_tx_clk_${x}" [ get_ports "${SYSTEM_PATH_PREFIX}tx_clk_${x}$TO_THE_VARIATION_NAME" ]
		create_clock -period "$TSE_CLOCK_FREQUENCY" -name "altera_tse_rx_clk_${x}" [ get_ports "${SYSTEM_PATH_PREFIX}rx_clk_${x}$TO_THE_VARIATION_NAME" ]
   }}

# MacPcs
if { [ expr ($IS_FIFOLESS == 1) && ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 0) ] } {
   for {set x 0} {$x < $NUMBER_OF_CHANNEL} {incr x} {
		create_clock -period "$TSE_CLOCK_FREQUENCY" -name "altera_tse_tbi_tx_clk_${x}" [ get_ports "${SYSTEM_PATH_PREFIX}tbi_tx_clk_${x}$TO_THE_VARIATION_NAME" ]
		create_clock -period "$TSE_CLOCK_FREQUENCY" -name "altera_tse_tbi_rx_clk_${x}" [ get_ports "${SYSTEM_PATH_PREFIX}tbi_rx_clk_${x}$TO_THE_VARIATION_NAME" ]
   }}

# MacPcsPma
if { [ expr ($IS_FIFOLESS == 1) && ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 1) ] } {
	#Constrain transceiver reference clock
	create_clock -period "$TSE_CLOCK_FREQUENCY" -name altera_tse_ref_clk [ get_ports  "${SYSTEM_PATH_PREFIX}ref_clk$TO_THE_VARIATION_NAME" ]
}

# MacPcs+SGMII
if { [ expr ($IS_FIFOLESS == 1) && ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 0) && ($IS_SGMII == 1)] } {
	#Constrain transceiver reference clock
	create_clock -period "$TSE_CLOCK_FREQUENCY" -name altera_tse_ref_clk [ get_ports  "${SYSTEM_PATH_PREFIX}ref_clk$TO_THE_VARIATION_NAME" ]
}

# MacPcs+SGMII ( with or without PMA )
if { [ expr ($IS_FIFOLESS == 1) && ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_SGMII == 1)] } {

}

#  pmaAlt4Gxb
if { [expr ($TRANSCEIVER_TYPE == 0) && ($IS_PMA == 1) && (([string match $DEVICE_FAMILY "STRATIXIV"]) || ([string match $DEVICE_FAMILY "ARRIAIIGX"]) || ([string match $DEVICE_FAMILY "HARDCOPYIV"]) ) ] } {
  
}

#  macPcsPmaLvdsSgmii
if { [ expr ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 1) && ($TRANSCEIVER_TYPE == 1)] } {
	#Cut the timing path betweeen unrelated clock domains
}

#  macPcsPmaLvdsNoSgmii
if { [ expr ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 0) && ($TRANSCEIVER_TYPE == 1)] } {
}

#  macPcsPmaTransceiverSgmii=
if { [ expr ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 1) && ($TRANSCEIVER_TYPE == 0) && (([string match $DEVICE_FAMILY "STRATIXIIGX"]) || ([string match $DEVICE_FAMILY "ARRIAGX"]))] } {
	#Cut the timing path betweeen unrelated clock domains
}

#  macPcsPmaTransceiverNoSgmii=
if { [ expr ($IS_MAC == 1) && ($IS_PCS == 1) && ($IS_PMA == 1) && ($IS_SGMII == 0) && ($TRANSCEIVER_TYPE == 0) && (([string match $DEVICE_FAMILY "STRATIXIIGX"]) || ([string match $DEVICE_FAMILY "ARRIAGX"]))] } {
	#Cut the timing path betweeen unrelated clock domains
}

if { [ expr ($IS_SOPC == 0) ] } {
	if { [ expr ($IS_FIFOLESS == 1) ] } {
		create_clock -period "$DEFAULT_SYSTEM_CLOCK_SPEED" -name altera_tse_rx_afull_clk  [get_ports "${SYSTEM_PATH_PREFIX}rx_afull_clk$TO_THE_VARIATION_NAME" ]
	}
}

if { [ expr $IS_1588 == 1 ] } {
	create_clock -period "$PHASE_MEASURE_CLOCK_SPEED" -name altera_tse_pcs_phase_measure_clk [ get_ports "$PCS_PHASE_MEASURE_CLK"]
}

#**************************************************************
# Set False Path
#**************************************************************
if { [ expr ($IS_SGMII == 1)] } {
    set_false_path -from [get_registers {*|altera_tse_a_fifo_24:U_DSW|altera_tse_gray_cnt:U_RD|g_out[*]}] -to [get_registers {*|altera_tse_a_fifo_24:U_DSW|rd_g_wptr[*]}]
    set_false_path -from [get_registers {*|altera_tse_a_fifo_24:U_DSW|altera_tse_gray_cnt:U_RD|b_out[*]}] -to [get_registers {*|altera_tse_a_fifo_24:U_DSW|rd_g_wptr[*]}]
    set_false_path -from [get_registers {*|altera_tse_a_fifo_24:U_DSW|altera_tse_gray_cnt:U_WRT|g_out[*]}] -to [get_registers {*|altera_tse_a_fifo_24:U_DSW|wr_g_rptr[*]}]
    set_false_path -from [get_registers {*|altera_tse_top_sgmii*:U_SGMII|altera_tse_colision_detect:U_COL|state*}] -to [get_registers {*|altera_tse_fifoless_mac_tx:U_TX|gm_rx_col_reg*}]
}

}

if { [ expr ($IS_HALFDUPLEX == 8) ] } {
#Constrain timing for half duplex logic
   if { [ expr ($IS_FIFOLESS == 0) ] } {
      set_multicycle_path -setup 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_altsyncram_dpm_fifo:U_RTSM|altsyncram*] -to [ get_registers *]
      set_multicycle_path -setup 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*] -to [ get_registers *]
      set_multicycle_path -setup 5 -from [ get_registers *] -to [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*]
      set_multicycle_path -setup 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_a_fifo_opt*:TX_DATA|altera_tse_altsyncram_dpm_fifo:U_RAM*|altsyncram*] -to [ get_registers *]
      set_multicycle_path -hold 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_altsyncram_dpm_fifo:U_RTSM|altsyncram*] -to [ get_registers *]
      set_multicycle_path -hold 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*] -to [ get_registers *]
      set_multicycle_path -hold 5 -from [ get_registers *] -to [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*]
      set_multicycle_path -hold 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_a_fifo_opt*:TX_DATA|altera_tse_altsyncram_dpm_fifo:U_RAM*|altsyncram*] -to [ get_registers *]
      set_max_delay 7.5 -from [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_a_fifo_opt*:TX_DATA|altera_tse_altsyncram_dpm_fifo:U_RAM*|altsyncram*] -to [get_registers *|altera_tse_mac_tx:U_TX|eop[1]]
      set_max_delay 7.5 -from [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_a_fifo_opt*:TX_DATA|altera_tse_altsyncram_dpm_fifo:U_RAM*|altsyncram*] -to [get_registers *|altera_tse_mac_tx:U_TX|sop[1]]
      set_max_delay 7.5 -from [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_a_fifo_opt*:TX_DATA|altera_tse_altsyncram_dpm_fifo:U_RAM*|altsyncram*] -to [get_registers  *|altera_tse_mac_tx:U_TX|rd_1[*]]
      set_multicycle_path -setup 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|*col*] -to [ get_registers *]
      set_multicycle_path -hold 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|*col*] -to [ get_registers *]
   }
}

if { [ expr ($IS_HALFDUPLEX == 32) ] } {
#Constrain timing for half duplex logic
   if { [ expr ($IS_FIFOLESS == 0) ] } {
      set_multicycle_path -setup 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_altsyncram_dpm_fifo:U_RTSM|altsyncram*] -to [ get_registers *]
      set_multicycle_path -setup 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*] -to [ get_registers *]
      set_multicycle_path -setup 5 -from [ get_registers *] -to [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*]
      set_multicycle_path -hold 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_altsyncram_dpm_fifo:U_RTSM|altsyncram*] -to [ get_registers *]
      set_multicycle_path -hold 5 -from [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*] -to [ get_registers *]
      set_multicycle_path -hold 5 -from [ get_registers *] -to [ get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*]
      set_max_delay 7 -from [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|dout_reg_sft*] -to [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|*]
      set_max_delay 7 -from [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|eop_sft*] -to [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|*]
      set_max_delay 7 -from [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|sop_reg*] -to [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|*]
   }
}

if { [ expr ($IS_HALFDUPLEX == 8) ] } {
#Constrain timing for half duplex logic
   if { [ expr ($IS_FIFOLESS == 1) ] } {
      set_multicycle_path -setup 5 -from [ get_registers *|altera_tse_fifoless_mac_tx:U_TX|altera_tse_altsyncram_dpm_fifo:U_RTSM|altsyncram*] -to [ get_registers *]
      set_multicycle_path -setup 5 -from [ get_registers *|altera_tse_fifoless_mac_tx:U_TX|altera_tse_retransmit_cntl:U_RETR|*] -to [ get_registers *]
      set_multicycle_path -setup 5 -from [ get_registers *] -to [ get_registers *|altera_tse_fifoless_mac_tx:U_TX|altera_tse_retransmit_cntl:U_RETR|*]
      
      set_multicycle_path -hold 5 -from [ get_registers *|altera_tse_fifoless_mac_tx:U_TX|altera_tse_altsyncram_dpm_fifo:U_RTSM|altsyncram*] -to [ get_registers *]
      set_multicycle_path -hold 5 -from [ get_registers *|altera_tse_fifoless_mac_tx:U_TX|altera_tse_retransmit_cntl:U_RETR|*] -to [ get_registers *]
      set_multicycle_path -hold 5 -from [ get_registers *] -to [ get_registers *|altera_tse_fifoless_mac_tx:U_TX|altera_tse_retransmit_cntl:U_RETR|*]
   }
}

# False paths for MAC registers
if {[expr ($IS_MAC == 1)]} {
   if {[expr ($IS_FIFOLESS == 0)]} {
      if {[expr $IS_SMALLMAC == 1]} {
         # Small MAC
         set_false_path -from [get_registers {*|altera_tse_register_map_small:U_REG|command_config[9]}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
         set_false_path -from [get_registers {*|altera_tse_register_map_small:U_REG|mac_0[*]}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
         set_false_path -from [get_registers {*|altera_tse_register_map_small:U_REG|mac_1[*]}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
   
         set_false_path -from [get_registers {*|altera_tse_register_map_small:U_REG|mac_0[*]}] -to [get_registers {*|altera_tse_mac_rx:U_RX|*}]
         set_false_path -from [get_registers {*|altera_tse_register_map_small:U_REG|mac_1[*]}] -to [get_registers {*|altera_tse_mac_rx:U_RX|*}]
      } else {
         # MAC with FIFO
         set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|command_config[9]}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
         set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|mac_0[*]}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
         set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|mac_1[*]}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
   
         set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|mac_0[*]}] -to [get_registers {*|altera_tse_mac_rx:U_RX|*}]
         set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|mac_1[*]}] -to [get_registers {*|altera_tse_mac_rx:U_RX|*}]
         set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|frm_length[*]}] -to [get_registers {*|altera_tse_mac_rx:U_RX|*}]
   
         if {[expr ($ENABLE_SUP_ADDR == 1)]} {
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|command_config[16]}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|command_config[17]}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|command_config[18]}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
   
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|smac_0*}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|smac_1*}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|smac_2*}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|smac_3*}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
   
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|smac_0*}] -to [get_registers {*|altera_tse_mac_rx:U_RX|*}]
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|smac_1*}] -to [get_registers {*|altera_tse_mac_rx:U_RX|*}]
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|smac_2*}] -to [get_registers {*|altera_tse_mac_rx:U_RX|*}]
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|smac_3*}] -to [get_registers {*|altera_tse_mac_rx:U_RX|*}]
   
         }
   
         if {[expr ($ENABLE_MAC_FLOW_CTRL == 1)]} {
            set_false_path -from [get_registers *|altera_tse_mac_rx:*|pause_quant_val*] -to [get_registers *|altera_tse_mac_tx:*|pause_latch*]
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|pause_quant_reg*}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|pause_quant_reg*}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|holdoff_quant*}] -to [get_registers {*|altera_tse_mac_tx:U_TX|*}]
         }

         # Magic packet detection 
         if {[expr ($ENABLE_MAGIC_DETECT == 1)]} {
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|mac_0[*]}] -to [get_registers {*|altera_tse_magic_detection:U_MAGIC|*}]
            set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|mac_1[*]}] -to [get_registers {*|altera_tse_magic_detection:U_MAGIC|*}]

            if {[expr ($ENABLE_SUP_ADDR == 1)]} {
               set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|smac_0*}] -to [get_registers {*|altera_tse_magic_detection:U_MAGIC|*}]
               set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|smac_1*}] -to [get_registers {*|altera_tse_magic_detection:U_MAGIC|*}]
               set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|smac_2*}] -to [get_registers {*|altera_tse_magic_detection:U_MAGIC|*}]
               set_false_path -from [get_registers {*|altera_tse_register_map:U_REG|smac_3*}] -to [get_registers {*|altera_tse_magic_detection:U_MAGIC|*}]
            }
         }
      }
   } else {
      # MAC without FIFO
      set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|command_config[9]}] -to [get_registers {*altera_tse_fifoless_mac_tx:U_TX|*}]
      set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|mac_0[*]}] -to [get_registers {*|altera_tse_fifoless_mac_tx:U_TX|*}]
      set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|mac_1[*]}] -to [get_registers {*|altera_tse_fifoless_mac_tx:U_TX|*}]
   
      set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|mac_0[*]}] -to [get_registers {*|altera_tse_fifoless_mac_rx:U_RX|*}]
      set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|mac_1[*]}] -to [get_registers {*|altera_tse_fifoless_mac_rx:U_RX|*}]
      set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|frm_length[*]}] -to [get_registers {*|altera_tse_fifoless_mac_rx:U_RX|*}]

      if {[expr ($ENABLE_SUP_ADDR == 1)]} {
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|command_config[16]}] -to [get_registers {*|altera_tse_fifoless_mac_tx:U_TX|*}]
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|command_config[17]}] -to [get_registers {*|altera_tse_fifoless_mac_tx:U_TX|*}]
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|command_config[18]}] -to [get_registers {*|altera_tse_fifoless_mac_tx:U_TX|*}]
   
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|smac_0*}] -to [get_registers {*|altera_tse_fifoless_mac_tx:U_TX|*}]
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|smac_1*}] -to [get_registers {*|altera_tse_fifoless_mac_tx:U_TX|*}]
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|smac_2*}] -to [get_registers {*|altera_tse_fifoless_mac_tx:U_TX|*}]
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|smac_3*}] -to [get_registers {*|altera_tse_fifoless_mac_tx:U_TX|*}]
   
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|smac_0*}] -to [get_registers {*|altera_tse_fifoless_mac_rx:U_RX|*}]
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|smac_1*}] -to [get_registers {*|altera_tse_fifoless_mac_rx:U_RX|*}]
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|smac_2*}] -to [get_registers {*|altera_tse_fifoless_mac_rx:U_RX|*}]
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|smac_3*}] -to [get_registers {*|altera_tse_fifoless_mac_rx:U_RX|*}]
      }

      if {[expr ($ENABLE_MAC_FLOW_CTRL == 1)]} {
         set_false_path -from [get_registers *|altera_tse_fifoless_mac_rx:*|pause_quant_val*] -to [get_registers *|altera_tse_fifoless_mac_tx:*|pause_latch*]
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|pause_quant_reg*}] -to [get_registers {*|altera_tse_fifoless_mac_tx:U_TX|*}]
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|pause_quant_reg*}] -to [get_registers {*|altera_tse_fifoless_mac_tx:U_TX|*}]
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|holdoff_quant*}] -to [get_registers {*|altera_tse_fifoless_mac_tx:U_TX|*}]

      }

      # Magic packet detection 
      if {[expr ($ENABLE_MAGIC_DETECT == 1)]} {
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|mac_0[*]}] -to [get_registers {*|altera_tse_magic_detection:U_MAGIC|*}]
         set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|mac_1[*]}] -to [get_registers {*|altera_tse_magic_detection:U_MAGIC|*}]

         if {[expr ($ENABLE_SUP_ADDR == 1)]} {
            set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|smac_0*}] -to [get_registers {*|altera_tse_magic_detection:U_MAGIC|*}]
            set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|smac_1*}] -to [get_registers {*|altera_tse_magic_detection:U_MAGIC|*}]
            set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|smac_2*}] -to [get_registers {*|altera_tse_magic_detection:U_MAGIC|*}]
            set_false_path -from [get_registers {*|altera_tse_shared_register_map:U_REG|smac_3*}] -to [get_registers {*|altera_tse_magic_detection:U_MAGIC|*}]
         }
      }
   }
}

#**************************************************************
# Set False Path for altera_tse_reset_synchronizer
#**************************************************************
set tse_aclr_counter 0
set tse_clrn_counter 0
set tse_aclr_collection [get_pins -compatibility_mode -nocase -nowarn *|altera_tse_reset_synchronizer:*|altera_tse_reset_synchronizer_chain*|aclr]
set tse_clrn_collection [get_pins -compatibility_mode -nocase -nowarn *|altera_tse_reset_synchronizer:*|altera_tse_reset_synchronizer_chain*|clrn]
foreach_in_collection tse_aclr_pin $tse_aclr_collection {
    set tse_aclr_counter [expr $tse_aclr_counter + 1]
}
foreach_in_collection tse_clrn_pin $tse_clrn_collection {
    set tse_clrn_counter [expr $tse_clrn_counter + 1]
}
if {$tse_aclr_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *|altera_tse_reset_synchronizer:*|altera_tse_reset_synchronizer_chain*|aclr]
}

if {$tse_clrn_counter > 0} {
    set_false_path -to [get_pins -compatibility_mode -nocase *|altera_tse_reset_synchronizer:*|altera_tse_reset_synchronizer_chain*|clrn]
}

