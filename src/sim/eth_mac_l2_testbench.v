/*
ENGINNER: Mateusz Okulanis
PROJECT: OM_FIREWALL
MODULE: eth_mac_l2_testbench
SCENARIO: 
1. PREAMBLE
2. SFD
*/




module eth_mac_l2_testbench();

reg Clk;
reg Rst_n;
reg Enet0_Rx_Data;
reg Enet0_Rx_Dv;
reg Enet0_Rx_Er;
wire avalonST_1_valid_wire;
wire [7:0] avalonST_1_data_wire;
wire avalonST_1_channel_wire; 
wire avalonST_1_error_wire;
reg  avalonST_1_ready_reg;


eth_mac_l2 eth_mac_inst(
.Clk(),     // 125 MHz clock for GMII signals
.Rst_n(),   // active-high sync reset
.M_ETH0_avalonST_valid(avalonST_1_valid_wire),
.M_ETH0_avalonST_data(avalonST_1_data_wire),
.M_ETH0_avalonST_channel(avalonST_1_channel_wire),
.M_ETH0_avalonST_error(avalonST_1_error_wire),
.M_ETH0_avalonST_ready(avalonST_1_ready_reg),
.S_ETH0_avalonST_valid(),
.S_ETH0_avalonST_data(),
.S_ETH0_avalonST_channel(),
.S_ETH0_avalonST_error(),
.S_ETH0_avalonST_ready(),
.M_ETH1_avalonST_valid(),
.M_ETH1_avalonST_data(),
.M_ETH1_avalonST_channel(),
.M_ETH1_avalonST_error(),
.M_ETH1_avalonST_ready(),
.S_ETH1_avalonST_valid(),
.S_ETH1_avalonST_data(),
.S_ETH1_avalonST_channel(),
.S_ETH1_avalonST_error(),
.S_ETH1_avalonST_ready(),
.ENET0_RX_DATA(ENET0_RX_DATA),
.ENET0_RX_DV(ENET0_RX_DV),
.ENET0_RX_ER(ENET0_RX_ER),
.ENET0_TX_DATA(ENET0_TX_DATA),
.ENET0_TX_DV(ENET0_TX_DV),
.ENET0_TX_ER(ENET0_TX_ER),
.ENET1_RX_DATA(ENET1_RX_DATA),
.ENET1_RX_DV(ENET1_RX_DV),
.ENET1_RX_ER(ENET1_RX_ER),
.ENET1_TX_DATA(ENET1_TX_DATA),
.ENET1_TX_DV(ENET1_TX_DV),
.ENET1_TX_ER(ENET1_TX_ER)
);


endmodule