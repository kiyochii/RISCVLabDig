module clockgenerator(
    input clk,
	 input rst,
    input [1:0]SW,
    output reg outclk
);

reg[31:0] counter = 0;

always @(posedge clk, posedge rst)begin
    if(rst)
		counter <= 0;
	 else
		counter <= counter + 1;
		

end
//assign outclk = (SW == 0) ? counter[0]:
//			(SW == 1) ? counter[7]:
//			(SW == 2) ? counter[15]:
//			counter[31];

always@(*)begin
	if(SW == 0)
		outclk = counter[0];
	else if(SW == 1)
		outclk = counter[7];
		
	else if(SW == 2)
		outclk = counter[15];
	else if(SW == 3)
		outclk = counter[24];

end	
			



endmodule