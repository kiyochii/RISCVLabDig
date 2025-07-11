`timescale 1ns / 1ps

module tb_poliriscv_sc32;

    reg clk, rst;
    reg ACK_I;
    reg ERR_I;
    reg [31:0] DAT_I;
    wire [31:0] DAT_O;
    wire [31:0] ADR_O;
    wire CYC_O, STB_O;
    wire [3:0] SEL_O;
    wire WE_O;
    wire TGC_O, TGA_O;

    wire [31:0] pcdebug, nextpcdebug, aluoutdebug;

    // Instantiate DUT
    poliriscv_sc32 dut (
        .clk(clk),
        .rst(rst),
        .ACK_I(ACK_I),
        .ERR_I(ERR_I),
        .DAT_I(DAT_I),
        .DAT_O(DAT_O),
        .ADR_O(ADR_O),
        .CYC_O(CYC_O),
        .STB_O(STB_O),
        .SEL_O(SEL_O),
        .WE_O(WE_O),
        .TGC_O(TGC_O),
        .TGA_O(TGA_O),
        .pcdebug(pcdebug),
        .nextpcdebug(nextpcdebug),
        .aluoutdebug(aluoutdebug)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Instruction memory mock
    reg [31:0] instruction_mem [0:15];

    // Data memory mock
    reg [31:0] data_mem [0:15];

    initial begin
        $dumpfile("tb_poliriscv_sc32.vcd");
        $dumpvars(0, tb_poliriscv_sc32);

        // Initialize
        clk = 0;
        rst = 1;
        ACK_I = 0;
        ERR_I = 0;
        DAT_I = 0;

        instruction_mem[0] = 32'b000000000101_00000_010_00000_0100011; // sw x5, 0(x0)
        instruction_mem[1] = 32'b000000000000_00000_010_00110_0000011; // lw x6, 0(x0)

        #20;
        rst = 0;
    end

    integer instr_ptr = 0;
    always @(posedge clk) begin
        if (dut.CYC_O && dut.STB_O) begin
            if (dut.state == 3'b001) begin
                // Provide instruction
                DAT_I <= instruction_mem[instr_ptr];
                instr_ptr <= instr_ptr + 1;
                ACK_I <= 1;
            end else if (dut.state == 3'b100) begin
                // Accept write
                data_mem[dut.ADR_O >> 2] <= dut.DAT_O;
                ACK_I <= 1;
            end else if (dut.state == 3'b001 && instr_ptr >= 2) begin
                // Provide data on read
                DAT_I <= data_mem[dut.ADR_O >> 2];
                ACK_I <= 1;
            end else begin
                ACK_I <= 0;
            end
        end else begin
            ACK_I <= 0;
        end
    end

endmodule
