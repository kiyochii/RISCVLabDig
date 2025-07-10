module wishboneram (
    input wire clk_i,
    input wire rst_i,
	 
    input wire cyc_i,
    input wire stb_i,
    input wire we_i,
    input wire [31:0]  sel_i,
    input wire [31:0] dat_i,
    input wire [31:0] adr_i,
    output reg  [31:0] dat_o,
    output reg ack_o
    
    );
    
    //ONDE EU USO O SEL_I? pode ser ignorado? visto que usamos todos os bits do data_i?


    always @(posedge clk_i or posedge rst_i) begin

        if (cyc_i & stb_i & ~ack_o)
            ack_o <= 1'b1;
        else
            ack_o <= 1'b0;
    end

    dmram u_dmram (
        .clock   (clk_i),
        .address (addr_i),
        .data    (dat_i),
        .wren    (cyc_i & stb_i & we_i),
        .q       (data_o)
    );

endmodule