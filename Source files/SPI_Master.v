module Master
(
	input wire clk, reset,
	input wire start,
	input wire [1:0] slaveselect,
	input wire [7:0]  masterDataToSend,
	output [7:0] masterDataReceived,
	
	output reg SCLK,
	output  [0:2]CS,
	output reg MOSI, 
	input wire MISO
	
);

integer counter;
//integer flag;
reg [7:0] MDS;
reg [7:0] MDR;

wire [7:0] MDS_next;
wire [7:0] MDR_next;

always @(posedge clk , posedge reset)
begin

if(reset==1'b1)
	begin
		MDS=0;
		MDR=0;
		SCLK = clk;
		counter = 0;
	end
else if(start==1'b1)
	begin
		MDS = masterDataToSend;
		MOSI = 1'b0;
		counter = 0;
	end
else
	begin

		MDR=MDR_next;
		MDS=MDS_next;	
		counter = counter+1;
	end
end

assign MDS_next=(start==1'b0 && counter < 8)?{ MDS[6:0],1'b0 }:MDS;
assign MDR_next = (start==1'b0 && counter < 8)?{MDR[6:0],MISO}:MDR;
assign MOSI = MDS[7];
assign masterDataReceived = MDR;
assign CS = (slaveselect==2'b00)?3'b011:
	    (slaveselect==2'b01)?3'b101:3'b110;

assign SCLK = clk;

endmodule
