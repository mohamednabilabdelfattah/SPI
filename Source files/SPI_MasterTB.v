
module Master_tb();

reg clk, reset;
reg start;
reg [7:0]  MDS[0:5];
wire [7:0] masterDataReceived;
reg [7:0]masterDataToSend;
reg [1:0] slaveselect;
wire SCLK,MOSI;
reg MISO;
reg [1:0]select [0:2];
wire [0:2]CS;
//masterDataToSend
reg [7:0] DataSend[0:5];
reg[7:0]SDS;
reg [7:0] Recieve;
reg[0:2] csex;
integer i;
integer j;
initial
begin
select[0]=2'b00;
select[1]=2'b01;
select[2]=2'b10;

slaveselect=0;
DataSend[0] = 8'b10110101;
DataSend[1] = 8'b11110000;
DataSend[2] = 8'b11001100;
DataSend[3] = 8'b00100010;
DataSend[4] = 8'b10000011;
DataSend[5] = 8'b11000010;

MDS [0] = 8'b11001010;
MDS [1] = 8'b11010110;
MDS [2] = 8'b10110101;
MDS [3] = 8'b01010011;
MDS [4] = 8'b00100101;
MDS [5] = 8'b00111100;

for(j=0;j<6;j=j+1)
begin
slaveselect=select[j%3];
SDS=DataSend[j];
masterDataToSend = MDS[j];
clk = 0;
MISO=SDS[7];
reset = 1;
#1
reset = 0;
#1
start = 1;
#1
masterDataToSend= MDS[j];
clk=1;
#1
clk =0;
#1
start=0;

#1
clk= 1;
masterDataToSend= MDS[j];
Recieve[7]=MOSI;
#1
clk=0;
// masterDataToSend= 8'b11001010;
// Recieve[7]=MOSI;
csex =  (select[j%3]==2'b00)?3'b011:
	(select[j%3]==2'b01)?3'b101:3'b110;
for(i=6;i>=0;i=i-1)
	begin
		#1
		MISO = SDS[i];
		Recieve[i]=MOSI;
		#1
		clk = ~clk;
		MISO = SDS[i];
		#1
		clk = ~clk;

		

	end
	$display("**************************************************\nTestCase : %1d ", j+1);
	if(Recieve==masterDataToSend)
		$display("MOSI SUCCESS");
	else
		$display("MOSI FAILED");
	if (masterDataReceived==SDS)
		$display("masterDataReceived SUCCESS");
	
	else
		$display ("masterDataReceived FAILED");
	if(csex==CS)
		$display("CS SUCCESS");
	else
		$display("CS FAILED");

	#1
	clk = ~clk;
	#1
	clk = ~clk;

end
	$finish;
end




Master M1(clk,reset,start,slaveselect,masterDataToSend,masterDataReceived,SCLK,CS,MOSI,MISO);

endmodule





