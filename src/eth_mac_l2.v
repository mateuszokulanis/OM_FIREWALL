/*
ENGINNER: Mateusz Okulanis
PROJECT: OM_FIREWALL
MODULE: ETH_MAC_L2
DESCRIPTION: DETECTS, PREAMBLE, CHECKING CRC32

*/
`include "src/utils/CRC32_D8.v"
module eth_mac_l2(
   input             Clk, 
   input             Rst_n,

   output reg        M_ETH0_avalonST_valid,
   output reg [7:0]  M_ETH0_avalonST_data,
   output reg [7:0]  M_ETH0_avalonST_channel,
   output reg        M_ETH0_avalonST_error,

   input [7:0]       M_ETH0_avalonST_ready,
   input             S_ETH0_avalonST_valid,
   input [7:0]       S_ETH0_avalonST_data,
   input [7:0]       S_ETH0_avalonST_channel,
   input             S_ETH0_avalonST_error,
   output reg        S_ETH0_avalonST_ready,

   output reg        M_ETH1_avalonST_valid,
   output reg [7:0]  M_ETH1_avalonST_data,
   output reg [7:0]  M_ETH1_avalonST_channel,
   output reg        M_ETH1_avalonST_error,
   input [7:0]       M_ETH1_avalonST_ready,

   input             S_ETH1_avalonST_valid,
   input [7:0]       S_ETH1_avalonST_data,
   input [7:0]       S_ETH1_avalonST_channel,
   input             S_ETH1_avalonST_error,
   output reg        S_ETH1_avalonST_ready,

   input [7:0]      ENET0_RX_DATA,
   input            ENET0_RX_DV,
   input            ENET0_RX_ER,
   output reg [7:0] ENET0_TX_DATA,
   output reg       ENET0_TX_DV,
   output reg       ENET0_TX_ER,

   input [7:0]      ENET1_RX_DATA,
   input            ENET1_RX_DV,
   input            ENET1_RX_ER,
   output reg [7:0] ENET1_TX_DATA,
   output reg       ENET1_TX_DV,
   output reg       ENET1_TX_ER
);




//preambula
//sofd

localparam [4:0] STATE_PREAMBLE  = 1;
localparam [4:0] STATE_SFD       = 2;
localparam [4:0] STATE_PAYLOAD   = 4;
localparam [4:0] STATE_CRC       = 8;
localparam [4:0] STATE_RESET     = 16;

localparam [7:0] PREAMBLE_OCTET = 8'hAA;
localparam [7:0] SFD_OCTET      = 8'hBA;

reg [4:0] state_reg      = STATE_PREAMBLE;
reg [4:0] state_next_reg = STATE_PREAMBLE;
reg       sfd_detected_reg       = 0;
reg       preamble_detected_reg  = 0;
reg [4:0] preamble_octet_cnt     = 0;

reg       sfd_reg        = 0;
reg [7:0] latency1_reg   = 0;
reg [7:0] latency2_reg   = 0;
reg [7:0] latency3_reg   = 0;
reg [7:0] latency4_reg   = 0;

always @ (posedge Clk)
if (!Rst_n)
   state_reg <= STATE_PREAMBLE;
else
   state_reg <= state_next_reg;
always @(*) 
   case (state_reg)
      STATE_PREAMBLE:
         begin     
            if(preamble_detected_reg)
               state_next_reg <= STATE_SFD;
            else
               state_next_reg <= STATE_PREAMBLE;
         end
   STATE_SFD:
      begin     
         if(sfd_detected_reg)
            state_next_reg <= STATE_PAYLOAD;
         else
            state_next_reg <= STATE_SFD;
      end
   STATE_PAYLOAD:
      begin   
         state_next_reg <= STATE_CRC;
      end
   STATE_CRC:
      begin   
         state_next_reg <= STATE_PREAMBLE;
      end
   STATE_RESET:
      begin   
         state_next_reg <= STATE_PREAMBLE;
      end
   default : 
      begin  
         state_next_reg <= STATE_RESET;
      end
   endcase    
     
always @(posedge Clk) 
   begin
      latency1_reg <= M_ETH0_avalonST_data;
      latency2_reg <= latency1_reg;
      latency3_reg <= latency2_reg;
      latency4_reg <= (latency3_reg);
   end

always @(posedge Clk) 
   case (state_reg)
      STATE_PREAMBLE:
      begin     
         if(ENET0_RX_DV)
            begin
               if(ENET0_RX_DATA == PREAMBLE_OCTET)
                  begin
               if(preamble_octet_cnt == 6)
                  begin
                     preamble_detected_reg  <= 1;    
                  end
               else
                  begin
                     preamble_octet_cnt <= preamble_octet_cnt + 1;   
                  end                                    
               end
            end
         else
            begin

            end
      end
   STATE_SFD:
      begin 
         preamble_detected_reg  <= 0;  
         if(ENET0_RX_DV)
         begin
            if(latency1_reg == SFD_OCTET)
               sfd_detected_reg <= 1;
            else
               sfd_detected_reg <= 0;
            end
            else
               sfd_detected_reg <= 0;            
      end
   STATE_PAYLOAD:
      begin   

      end
   STATE_CRC:
      begin   
  
      end
   STATE_RESET:
      begin   

      end
   default : 
   begin 
      state_next_reg <= STATE_RESET;
   end
endcase    
          
 





/////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 1999-2008 Easics NV.
// This source file may be used and distributed without restriction
// provided that this copyright statement is not removed from the file
// and that any derivative work contains the original copyright notice
// and the associated disclaimer.
//
// THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS
// OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
// WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
//
// Purpose : synthesizable CRC function
//   * polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1
//   * data width: 8
//
// Info : tools@easics.be
//        http://www.easics.com
////////////////////////////////////////////////////////////////////////////////
//module CRC32_D8();

// polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1
// data width: 8
// convention: the first serial bit is D[7]
function [31:0] nextCRC32_D8;

    input [7:0] Data;
    input [31:0] crc;
    reg [7:0] d;
    reg [31:0] c;
    reg [31:0] newcrc;
  begin
    d = Data;
    c = crc;

    newcrc[0] = d[6] ^ d[0] ^ c[24] ^ c[30];
    newcrc[1] = d[7] ^ d[6] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[30] ^ c[31];
    newcrc[2] = d[7] ^ d[6] ^ d[2] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[26] ^ c[30] ^ c[31];
    newcrc[3] = d[7] ^ d[3] ^ d[2] ^ d[1] ^ c[25] ^ c[26] ^ c[27] ^ c[31];
    newcrc[4] = d[6] ^ d[4] ^ d[3] ^ d[2] ^ d[0] ^ c[24] ^ c[26] ^ c[27] ^ c[28] ^ c[30];
    newcrc[5] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[27] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    newcrc[6] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    newcrc[7] = d[7] ^ d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[24] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
    newcrc[8] = d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[0] ^ c[24] ^ c[25] ^ c[27] ^ c[28];
    newcrc[9] = d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[1] ^ c[25] ^ c[26] ^ c[28] ^ c[29];
    newcrc[10] = d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[2] ^ c[24] ^ c[26] ^ c[27] ^ c[29];
    newcrc[11] = d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[3] ^ c[24] ^ c[25] ^ c[27] ^ c[28];
    newcrc[12] = d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ d[0] ^ c[4] ^ c[24] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30];
    newcrc[13] = d[7] ^ d[6] ^ d[5] ^ d[3] ^ d[2] ^ d[1] ^ c[5] ^ c[25] ^ c[26] ^ c[27] ^ c[29] ^ c[30] ^ c[31];
    newcrc[14] = d[7] ^ d[6] ^ d[4] ^ d[3] ^ d[2] ^ c[6] ^ c[26] ^ c[27] ^ c[28] ^ c[30] ^ c[31];
    newcrc[15] = d[7] ^ d[5] ^ d[4] ^ d[3] ^ c[7] ^ c[27] ^ c[28] ^ c[29] ^ c[31];
    newcrc[16] = d[5] ^ d[4] ^ d[0] ^ c[8] ^ c[24] ^ c[28] ^ c[29];
    newcrc[17] = d[6] ^ d[5] ^ d[1] ^ c[9] ^ c[25] ^ c[29] ^ c[30];
    newcrc[18] = d[7] ^ d[6] ^ d[2] ^ c[10] ^ c[26] ^ c[30] ^ c[31];
    newcrc[19] = d[7] ^ d[3] ^ c[11] ^ c[27] ^ c[31];
    newcrc[20] = d[4] ^ c[12] ^ c[28];
    newcrc[21] = d[5] ^ c[13] ^ c[29];
    newcrc[22] = d[0] ^ c[14] ^ c[24];
    newcrc[23] = d[6] ^ d[1] ^ d[0] ^ c[15] ^ c[24] ^ c[25] ^ c[30];
    newcrc[24] = d[7] ^ d[2] ^ d[1] ^ c[16] ^ c[25] ^ c[26] ^ c[31];
    newcrc[25] = d[3] ^ d[2] ^ c[17] ^ c[26] ^ c[27];
    newcrc[26] = d[6] ^ d[4] ^ d[3] ^ d[0] ^ c[18] ^ c[24] ^ c[27] ^ c[28] ^ c[30];
    newcrc[27] = d[7] ^ d[5] ^ d[4] ^ d[1] ^ c[19] ^ c[25] ^ c[28] ^ c[29] ^ c[31];
    newcrc[28] = d[6] ^ d[5] ^ d[2] ^ c[20] ^ c[26] ^ c[29] ^ c[30];
    newcrc[29] = d[7] ^ d[6] ^ d[3] ^ c[21] ^ c[27] ^ c[30] ^ c[31];
    newcrc[30] = d[7] ^ d[4] ^ c[22] ^ c[28] ^ c[31];
    newcrc[31] = d[5] ^ c[23] ^ c[29];
    nextCRC32_D8 = newcrc;
  end
endfunction

function [7:0] bit_reverse;
    input [7:0] data;
    begin
        integer i;
        reg[7:0]  bit_order;
        for (i=0; i < 7; i=i+1) 
        begin
            bit_order[7-i] = data[i];
        end
    bit_reverse = data;
    end
endfunction




     
endmodule 