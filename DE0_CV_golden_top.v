// ============================================================================
// Copyright (c) 2014 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Yue Yang          :| 08/25/2014:| Initial Revision
// ============================================================================
//`define Enable_CLOCK2
//`define Enable_CLOCK3
//`define Enable_CLOCK4
`define Enable_CLOCK
//`define Enable_DRAM
//`define Enable_GPIO
`define Enable_HEX0
`define Enable_HEX1
`define Enable_HEX2
`define Enable_HEX3
`define Enable_HEX4
`define Enable_HEX5
`define Enable_KEY
`define Enable_LEDR
//`define Enable_PS2
`define Enable_RESET
//`define Enable_SD
`define Enable_SW
//`define Enable_VGA

module DE0_CV_golden_top (

`ifdef Enable_CLOCK2
      ///////// CLOCK2 "3.3-V LVTTL" /////////
      input              CLOCK2_50,
`endif	  

`ifdef Enable_CLOCK3
      ///////// CLOCK3 "3.3-V LVTTL" /////////
      input              CLOCK3_50,
`endif

`ifdef Enable_CLOCK4
      ///////// CLOCK4  "3.3-V LVTTL"  /////////
      inout              CLOCK4_50,
`endif	  
`ifdef Enable_CLOCK
      ///////// CLOCK  "3.3-V LVTTL" /////////
      input              CLOCK_50,
`endif
`ifdef Enable_DRAM
      ///////// DRAM  "3.3-V LVTTL" /////////
      output      [12:0] DRAM_ADDR,
      output      [1:0]  DRAM_BA,
      output             DRAM_CAS_N,
      output             DRAM_CKE,
      output             DRAM_CLK,
      output             DRAM_CS_N,
      inout       [15:0] DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_RAS_N,
      output             DRAM_UDQM,
      output             DRAM_WE_N,
`endif
`ifdef Enable_GPIO
      ///////// GPIO "3.3-V LVTTL" /////////
      inout       [35:0] GPIO_0,
      inout       [35:0] GPIO_1,
`endif
`ifdef Enable_HEX0
      ///////// HEX0  "3.3-V LVTTL" /////////
      output      [6:0]  HEX0,
`endif
`ifdef Enable_HEX1
      ///////// HEX1 "3.3-V LVTTL" /////////
      output      [6:0]  HEX1,
`endif
`ifdef Enable_HEX2
      ///////// HEX2 "3.3-V LVTTL" /////////
      output      [6:0]  HEX2,
`endif
`ifdef Enable_HEX3
      ///////// HEX3 "3.3-V LVTTL" /////////
      output      [6:0]  HEX3,
`endif
`ifdef Enable_HEX4
      ///////// HEX4 "3.3-V LVTTL" /////////
      output      [6:0]  HEX4,
`endif
`ifdef Enable_HEX5
      ///////// HEX5 "3.3-V LVTTL" /////////
      output      [6:0]  HEX5,
`endif
`ifdef Enable_KEY
      ///////// KEY  "3.3-V LVTTL" /////////
      input       [3:0]  KEY,
`endif
`ifdef Enable_LEDR
      ///////// LEDR /////////
      output      [9:0]  LEDR,
`endif
`ifdef Enable_PS2
      ///////// PS2 "3.3-V LVTTL" /////////
      inout              PS2_CLK,
      inout              PS2_CLK2,
      inout              PS2_DAT,
      inout              PS2_DAT2,
`endif
`ifdef Enable_RESET
      ///////// RESET "3.3-V LVTTL" /////////
      input              RESET_N,
`endif
`ifdef Enable_SD
      ///////// SD "3.3-V LVTTL" /////////
      output             SD_CLK,
      inout              SD_CMD,
      inout       [3:0]  SD_DATA,
`endif
`ifdef Enable_SW
      ///////// SW "3.3-V LVTTL"/////////
      input       [9:0]  SW
`endif
`ifdef Enable_VGA
      ///////// VGA  "3.3-V LVTTL" /////////
      output      [3:0]  VGA_B,
      output      [3:0]  VGA_G,
      output             VGA_HS,
      output      [3:0]  VGA_R,
      output             VGA_VS
`endif	 
);


assign wbsrom_addr = 10'b0000000000;
assign wbsrom_addr_msk = 10'b1000000000;
assign sel_i_rom = 4'b1111;
assign wbsram_addr = 10'b1000000000;
assign wbsram_addr_msk = 10'b1000000000;


	
localparam DATA_WIDTH   = 32;
localparam ADDR_WIDTH   = 32;
localparam SELECT_WIDTH = DATA_WIDTH / 8;

// Master interface
wire [ADDR_WIDTH-1:0]   wbm_adr_i;
wire [DATA_WIDTH-1:0]   wbm_dat_i;
wire [DATA_WIDTH-1:0]   wbm_dat_o;
wire                    wbm_we_i;
wire [SELECT_WIDTH-1:0] wbm_sel_i;
wire                    wbm_stb_i;
wire                    wbm_ack_o;
wire                    wbm_err_o;
wire                    wbm_rty_o;
wire                    wbm_cyc_i;

// Slave 0 (ROM) interface
wire [ADDR_WIDTH-1:0]   wbs0_adr_o;
wire [DATA_WIDTH-1:0]   wbs0_dat_i;
wire [DATA_WIDTH-1:0]   wbs0_dat_o;
wire                    wbs0_we_o;
wire [SELECT_WIDTH-1:0] wbs0_sel_o;
wire                    wbs0_stb_o;
wire                    wbs0_ack_i;
wire                    wbs0_err_i;
wire                    wbs0_rty_i;
wire                    wbs0_cyc_o;

// Slave 1 (RAM) interface
wire [ADDR_WIDTH-1:0]   wbs1_adr_o;
wire [DATA_WIDTH-1:0]   wbs1_dat_i;
wire [DATA_WIDTH-1:0]   wbs1_dat_o;
wire                    wbs1_we_o;
wire [SELECT_WIDTH-1:0] wbs1_sel_o;
wire                    wbs1_stb_o;
wire                    wbs1_ack_i;
wire                    wbs1_err_i;
wire                    wbs1_rty_i;
wire                    wbs1_cyc_o;

wire [ADDR_WIDTH-1:0]   wbs0_addr     = 32'h00000000;  
wire [ADDR_WIDTH-1:0]   wbs0_addr_msk = 32'h80000000;  

wire [ADDR_WIDTH-1:0]   wbs1_addr     = 32'h80000000;  
wire [ADDR_WIDTH-1:0]   wbs1_addr_msk = 32'h80000000;  


wb_mux_2 #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .SELECT_WIDTH(SELECT_WIDTH)
) wb_mux_inst (
    .clk(outclk),
    .rst(!RESET_N),

    // Master
    .wbm_adr_i(wbm_adr_i),
    .wbm_dat_i(wbm_dat_i),
    .wbm_dat_o(wbm_dat_o),
    .wbm_we_i(wbm_we_i),
    .wbm_sel_i(wbm_sel_i),
    .wbm_stb_i(wbm_stb_i),
    .wbm_ack_o(wbm_ack_o),
    .wbm_err_o(wbm_err_o),
    .wbm_rty_o(wbm_rty_o),
    .wbm_cyc_i(wbm_cyc_i),

    // Slave 0 (ROM)
    .wbs0_adr_o(wbs0_adr_o),
    .wbs0_dat_i(wbs0_dat_i),
    .wbs0_dat_o(wbs0_dat_o),
    .wbs0_we_o(wbs0_we_o),
    .wbs0_sel_o(wbs0_sel_o),
    .wbs0_stb_o(wbs0_stb_o),
    .wbs0_ack_i(wbs0_ack_i),
    .wbs0_err_i(wbs0_err_i),
    .wbs0_rty_i(wbs0_rty_i),
    .wbs0_cyc_o(wbs0_cyc_o),
    .wbs0_addr(wbs0_addr),
    .wbs0_addr_msk(wbs0_addr_msk),

    // Slave 1 (RAM)
    .wbs1_adr_o(wbs1_adr_o),
    .wbs1_dat_i(wbs1_dat_i),
    .wbs1_dat_o(wbs1_dat_o),
    .wbs1_we_o(wbs1_we_o),
    .wbs1_sel_o(wbs1_sel_o),
    .wbs1_stb_o(wbs1_stb_o),
    .wbs1_ack_i(wbs1_ack_i),
    .wbs1_err_i(wbs1_err_i),
    .wbs1_rty_i(wbs1_rty_i),
    .wbs1_cyc_o(wbs1_cyc_o),
    .wbs1_addr(wbs1_addr),
    .wbs1_addr_msk(wbs1_addr_msk)
);

wishboneram u_ram (
    .clk_i(outclk),
    .rst_i(rst),
    .cyc_i(wbs1_cyc_o),
    .stb_i(wbs1_stb_o),
    .we_i(wbs1_we_o),
    .sel_i(wbs1_sel_o),     // 4 bits (SELECT_WIDTH)
    .dat_i(wbs1_dat_o),     // dados de saída do mux para o RAM (entrada da RAM)
    .adr_i(wbs1_adr_o),     // endereço completo de 32 bits
    .dat_o(wbs1_dat_i),     // dados de saída da RAM
    .ack_o(wbs1_ack_i)
);
	

wishbone_mrom u_rom (
    .clk_i(outclk),
    .rst_i(!RESET_N),
    .cyc_i(wbs0_cyc_o),
    .stb_i(wbs0_stb_o),
    .sel_i(wbs0_sel_o),
    .dat_i(wbs0_dat_o),
    .addr_i(wbs0_adr_o[9:0]),
    .dat_o(wbs0_dat_i),
    .ack_o(wbs0_ack_i)
);

poliriscv_sc32 #(
    .instructions(1024),
    .datawords(1024),
    .datawidth(32),
    .addrwidth(32)
) u_poliriscv (
    .clk(outclk),
    .rst(!RESET_N),

    .pcdebug(pc),
    .nextpcdebug(nextpc),
    .aluoutdebug(aluout),

    // Wishbone interface
    .ACK_I(wbm_ack_o),
    .ERR_I(wbm_err_o),
    .DAT_I(wbm_dat_o),

    .DAT_O(wbm_dat_i),
    .ADR_O(wbm_adr_i),
    .CYC_O(wbm_cyc_i),
    .STB_O(wbm_stb_i),
    .SEL_O(wbm_sel_i),
    .WE_O(wbm_we_i)
);

wire [31:0] pc;
wire [31:0] nextpc;
wire [31:0] aluout;
	
	
wire [3:0]hex1out; 
assign hex1out=   
			(SW[3:0] == 0) ? pc[3:0]:
      	      (SW[3:0] == 1) ? nextpc[3:0]:
			(SW[3:0] == 2) ? aluout[3:0]:
			wbm_dat_i[3:0];

wire [3:0]hex2out; 
assign hex2out  =
			(SW[3:0] == 0) ? pc[7:4]:
			(SW[3:0] == 1) ? nextpc[7:4]:
			(SW[3:0] == 2) ? aluout[7:4]:
			wbm_dat_i[7:4];
	
wire [3:0]hex3out;
assign hex3out= 	
			(SW[3:0] == 0) ? pc[11:8]:
			(SW[3:0] == 1) ? nextpc[11:8]:
			(SW[3:0] == 2) ? aluout[11:8]:
			wbm_dat_i[11:8];
								
wire [3:0]hex4out;
assign hex4out = 	
			(SW[3:0] == 0) ? pc[15:12]:	
			(SW[3:0] == 1) ? nextpc[15:12]:
			(SW[3:0] == 2) ? aluout[15:12]:
			wbm_dat_i[15:12];
	
wire [3:0]hex5out;
assign hex5out =  (SW[3:0] == 0) ? pc[19:16]:	
			(SW[3:0] == 1) ? nextpc[19:16]:
			(SW[3:0] == 2) ? aluout[19:16]:
			wbm_dat_i[19:16];
	
hexdecoder hex5(hex5out, HEX4);
hexdecoder hex4(hex4out, HEX3);
hexdecoder hex3(hex3out, HEX2);
hexdecoder hex2(hex2out, HEX1);
hexdecoder hex1(hex1out, HEX0);
//hexdecoder hex1(SW[3:0], HEX0);

	
	
	
clockgenerator clkg(CLOCK_50,!RESET_N, SW[5:4], outclk);
//hexdecoder hex2({{3{1'b0}}, {outclk}}, HEX1);

endmodule

