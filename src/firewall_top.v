


module firewall_top(
input            Clk,
input            Rst_n,
input            Enet0_Rx_Data,
input            Enet0_Rx_Dv,
input            Enet0_Rx_Er,
output reg [7:0] Enet0_Tx_Data,
output reg       Enet0_Tx_Dv,
output reg       Enet0_Tx_Er,
input      [7:0] Enet1_Rx_Data,
input            Enet1_Rx_Dv,
input            Enet1_Rx_Er,
output reg [7:0] Enet1_Tx_Data,
output reg       Enet1_Tx_Dv,
output reg       Enet1_Tx_Er
);


wire avalonST_1_valid_wire;
wire [7:0] avalonST_1_data_wire;
wire avalonST_1_channel_wire; 
wire avalonST_1_error_wire;
wire avalonST_1_ready_wire;

wire avalonST_2_valid_wire;
wire [7:0] avalonST_2_data_wire;
wire avalonST_2_channel_wire; 
wire avalonST_2_error_wire;
wire avalonST_2_ready_wire;

wire avalonST_3_valid_wire;
wire [7:0] avalonST_3_data_wire;
wire avalonST_3_channel_wire; 
wire avalonST_3_error_wire;
wire avalonST_3_ready_wire;

wire avalonST_4_valid_wire;
wire [7:0] avalonST_4_data_wire;
wire avalonST_4_channel_wire; 
wire avalonST_4_error_wire;
wire avalonST_4_ready_wire;

eth_mac_l2 eth_mac_inst(
.Clk(Clk),     // 125 MHz clock for GMII signals
.Rst_n(Rst_n),   // active-high sync reset
.M_ETH0_avalonST_valid(avalonST_1_valid_wire),
.M_ETH0_avalonST_data(avalonST_1_data_wire),
.M_ETH0_avalonST_channel(avalonST_1_channel_wire),
.M_ETH0_avalonST_error(avalonST_1_error_wire),
.M_ETH0_avalonST_ready(avalonST_1_ready_wire),
.S_ETH0_avalonST_valid(avalonST_2_valid_wire),
.S_ETH0_avalonST_data(avalonST_2_data_wire),
.S_ETH0_avalonST_channel(avalonST_2_channel_wire),
.S_ETH0_avalonST_error(avalonST_2_error_wire),
.S_ETH0_avalonST_ready(avalonST_2_ready_wire),
.M_ETH1_avalonST_valid(avalonST_3_valid_wire),
.M_ETH1_avalonST_data(avalonST_3_data_wire),
.M_ETH1_avalonST_channel(avalonST_3_channel_wire),
.M_ETH1_avalonST_error(avalonST_3_error_wire),
.M_ETH1_avalonST_ready(avalonST_3_ready_wire),
.S_ETH1_avalonST_valid(avalonST_4_valid_wire),
.S_ETH1_avalonST_data(avalonST_4_data_wire),
.S_ETH1_avalonST_channel(avalonST_4_channel_wire),
.S_ETH1_avalonST_error(avalonST_4_error_wire),
.S_ETH1_avalonST_ready(avalonST_4_ready_wire),
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