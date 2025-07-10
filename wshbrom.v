module wishbone_mrom (
	input  wire        clk_i,
	input  wire        rst_i,
	input wire cyc_i,
	input wire stb_i,
	input wire [3:0]  sel_i,
	input wire [31:0] dat_i,
	input wire [9:0] addr_i,
	output reg  [31:0] dat_o,
	output reg  ack_o);

    always @(posedge clk_i or posedge rst_i) begin
        if (rst_i)
            ack_o <= 1'b0;
        else if (cyc_i & stb_i & ~ack_o)
            ack_o <= 1'b1;
        else
            ack_o <= 1'b0;
    end

    mrom rom (
        .clock   (clk_i),
        .address (addr_i),
        .q       (dat_o)
    );

endmodule