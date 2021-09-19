module Slave_tb();

reg reset;
reg [7:0]slaveDataToSend;
wire [7:0]slaveDataReceived;
reg SCLK, CS, MOSI;
wire MISO;

reg [7:0] DataSend[0:5];
reg[7:0]MDS;
reg [7:0] Recieve;
reg [7:0]  SDS[0:5];

integer i;
integer j;
initial
begin


DataSend[0] = 8'b10110101;
DataSend[1] = 8'b11110000;
DataSend[2] = 8'b11001100;
DataSend[3] = 8'b10101010;
DataSend[4] = 8'b01010011;
DataSend[5] = 8'b10000011;

SDS [0] = 8'b11001010;
SDS [1] = 8'b11010110;
SDS [2] = 8'b10110101;
SDS [3] = 8'b11111111;
SDS [4] = 8'b10011000;
SDS [5] = 8'b11000010;

for(j=0;j<6;j=j+1)
begin
MDS=DataSend[j];
slaveDataToSend = SDS[j];
SCLK = 0;
MOSI=MDS[7];
CS = 1;
reset = 1;
#1
reset = 0;
#1
CS = 1;
#1
slaveDataToSend= SDS[j];
MOSI=MDS[7];
#1
SCLK=1;
#1
MOSI=MDS[7];
SCLK =0;
#1
CS=0;
MOSI=MDS[7];
#1
SCLK= 1;
slaveDataToSend= SDS[j];

#1
SCLK=0;

for(i=6;i>=0;i=i-1)
	begin
		#1
		MOSI = MDS[i];
		Recieve[i+1]=MISO;
		#1
		SCLK = ~SCLK;
		MOSI = MDS[i];
		#1
		SCLK = ~SCLK;
	end
	#1
	Recieve[0]=MISO;
		$display("**************************************************\nTestCase : %1d ", j+1);
	if(Recieve==slaveDataToSend)
		$display("MISO SUCCESS");
	else
		$display("MISO FAILED");
	if (slaveDataReceived==MDS)
		$display("slaveDataReceived SUCCESS");
	
	else
		$display ("slaveDataReceived FAILED");
	
	end
	$finish;
end




Slave M1(reset,slaveDataToSend,slaveDataReceived,SCLK,CS,MOSI,MISO);

endmodule
