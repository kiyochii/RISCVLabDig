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


wire [9:0]IM_ADDR;
wire [9:0]DM_ADDR;

wire [31:0] IM_DATA;
wire [31:0] DM_DATAIN;
wire [31:0] DM_DATAOUT;
wire wren;

mrom im(IM_ADDR, CLOCK_50, IM_DATA);
dmram dm(DM_ADDR, CLOCK_50, DM_DATAIM, wren, DM_DATAOUT);



//module poliriscv_sc32 #(
//    parameter instructions = 1024, // Number of instructions (32 bits each)
//    parameter datawords = 1024     // Number of words (32 bits each)
//)(                  
//    input clk, rst,
//    input [31:0] IM_data, DM_data_i,
//    output [ $clog2(instructions * 4) - 1 : 0 ] IM_address, DM_address,
//    output [31:0] DM_data_o,
//    output DM_write_enable,
    
    
//DEBUG
//    output wire [31:0] pcdebug,
//    output wire [31:0] nextpcdebug,
//    output wire [31:0] aluoutdebug
//
//);

wire [9:0]   wb_adr_o;  // ADR_O() address
wire [31:0]   wb_dat_i;   // DAT_I() data in
wire [31:0]   wb_dat_o;   // DAT_O() data out
wire  wb_we_o;    // WE_O write enable output
wire [31:0] wb_sel_o;   // SEL_O() select output
wire  wb_stb_o;   // STB_O strobe output
wire  wb_ack_i;   // ACK_I acknowledge input
wire  wb_err_i;   // ERR_I error input
wire  wb_cyc_o;   // CYC_O 
wire [9:0]   wbsrom_addr;     // Slave address prefix
wire [9:0]   wbsrom_addr_msk; // Slave address prefix mask
wire [3:0] sel_i_rom;

assign wbsrom_addr = 10'b0000000000;

assign wbsrom_addr_msk = 10'b1111111111;
assign sel_i_rom = 4'b1111;

assign wbsram_addr = 10'b1000000000;
assign wbsram_addr_msk = 10'b0111111111;

wishbone_mrom wshrom (
    .clk_i(outclk),        // Connects 'clk_i' port of wishbone_mrom to 'outclk' signal in current module
    .rst_i(!RESET_N),      // Connects 'rst_i' port to inverted 'RESET_N'
    .cyc_i(wb_cyc_o),
    .stb_i(wb_stb_o),
    .sel_i(sel_i_rom),     // sel_i is 4 bits wide [3:0]
    .dat_i(wb_dat_i),      // dat_i is 32 bits wide [31:0]
    .addr_i(wb_adr_o),     // addr_i is 10 bits wide [9:0]
    .dat_o(wb_dat_o),      // dat_o is 32 bits wide [31:0]
    .ack_o(wb_ack_i)
);

	
localparam [2:0]
	STATE_IDLE = 3'b000,
	STATE_HEADER = 3'b001,
	STATE_READ_ROM = 3'b010,
	STATE_READ_RAM = 3'b011,
	STATE_WRITE_RAM = 3'b100;

reg[2:0] state_reg = STATE_IDLE;
reg[2:0] state_next;
	
	
	
always@(*)begin
	
		
	
	
end
		
	
	poliriscv_sc32	proc(outclk, !RESET_N, IM_DATA, DM_DATAIN,IM_ADDR, DM_ADDR,
	DM_DATAOUT, wren,
	//SAIDAS DE DEBUG
	pc,
	nextpc,
	aluout);
	
	
	wire [31:0] pc;
	wire [31:0] nextpc;
	wire [31:0] aluout;
	
	
	wire [3:0]hex1out; 
	assign hex1out= 	(SW[3:0] == 0) ? pc[3:0]:
							(SW[3:0] == 1) ? nextpc[3:0]:
							(SW[3:0] == 2) ? aluout[3:0]:
							IM_DATA[3:0];
	
	wire [3:0]hex2out; 
	assign hex2out  = 	(SW[3:0] == 0) ? pc[7:4]:
								(SW[3:0] == 1) ? nextpc[7:4]:
								(SW[3:0] == 2) ? aluout[7:4]:
								IM_DATA[7:4];
	
	wire [3:0]hex3out;
	assign hex3out= 	(SW[3:0] == 0) ? pc[11:8]:
							(SW[3:0] == 1) ? nextpc[11:8]:
							(SW[3:0] == 2) ? aluout[11:8]:
							IM_DATA[11:8];
								
	wire [3:0]hex4out;
	assign hex4out = 	(SW[3:0] == 0) ? pc[15:12]:	
							(SW[3:0] == 1) ? nextpc[15:12]:
							(SW[3:0] == 2) ? aluout[15:12]:
							IM_DATA[15:12];
	
	wire [3:0]hex5out;
	assign hex5out	= 	(SW[3:0] == 0) ? pc[19:16]:	
							(SW[3:0] == 1) ? nextpc[19:16]:
							(SW[3:0] == 2) ? aluout[19:16]:
							IM_DATA[19:16];
	
	hexdecoder hex5(hex5out, HEX4);
	hexdecoder hex4(hex4out, HEX3);
	hexdecoder hex3(hex3out, HEX2);
	hexdecoder hex2(hex2out, HEX1);
	hexdecoder hex1(hex1out, HEX0);
	//hexdecoder hex1(SW[3:0], HEX0);
	
	
	
	
	clockgenerator clkg(CLOCK_50,!RESET_N, SW[5:4], outclk);
	//hexdecoder hex2({{3{1'b0}}, {outclk}}, HEX1);

endmodule

