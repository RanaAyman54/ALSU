module ALSU_tb;

parameter INPUT_PERIORITY_tb ="A" , FULL_ADDER_tb = "ON";

reg CLK_tb,RST_n_tb;
reg [2:0]A_tb,B_tb,opcode_tb;
reg	cin_tb,serial_in_tb,direction_tb;
reg	red_op_A_tb, red_op_B_tb;
reg	bypass_A_tb , bypass_B_tb;

wire [5:0] out_tb;
wire [15:0] leds_tb;

ALSU #(.INPUT_PERIORITY(INPUT_PERIORITY_tb),.FULL_ADDER(FULL_ADDER_tb)) dut(.CLK(CLK_tb),.RST_n(RST_n_tb),.A(A_tb),.B(B_tb),.opcode(opcode_tb),.cin(cin_tb),.serial_in(serial_in_tb),
	.direction(direction_tb),.red_op_A(red_op_A_tb),.red_op_B(red_op_B_tb),.bypass_A(bypass_A_tb),.bypass_B(bypass_B_tb),.out(out_tb),.leds(leds_tb));

always #2 CLK_tb=~CLK_tb;

initial begin
	RST_n_tb=1;
	#4;
	RST_n_tb=0;
	#4;
	RST_n_tb=1;
end

initial begin
	CLK_tb=0;
    A_tb=0;
    B_tb=0;
    opcode_tb=0;
	cin_tb=0;
	serial_in_tb=0;
	direction_tb=0;
	red_op_A_tb=0;
	red_op_B_tb=0;
	bypass_A_tb=0; 
	bypass_B_tb=0;
	#6;

	bypass_A_tb=1;     //pass a
	opcode_tb=3'b001;
	A_tb=3'b101;
	B_tb=3'b011;
	red_op_A_tb=1;
    #20;

    bypass_A_tb=0;   //pass b
	bypass_B_tb=1;
	opcode_tb=3'b001;
	A_tb=3'b101;
	B_tb=3'b011;
	red_op_A_tb=0;
	#20;

	bypass_A_tb=1;   //pass priority
	bypass_B_tb=1;
	opcode_tb=3'b001;
	A_tb=3'b101;
	B_tb=3'b011;
	red_op_B_tb=0;
	#20;

	bypass_A_tb=0;
	bypass_B_tb=0;
	opcode_tb=3'b010;  //add
	A_tb=3'b110;
	B_tb=3'b101;
	cin_tb=1;  //12
	#20;


	opcode_tb=3'b100;  //shift left
	serial_in_tb=1;
	direction_tb=1;
	#20;

	direction_tb=0;  //shift right
	#20;

	
	opcode_tb=3'b101;  //rotate right
	#20;

	direction_tb=1;  //rotate left
	#20;


	opcode_tb=3'b011; //multiplication
	A_tb=3'b100;
	B_tb=3'b101;  //20
	#20;


	opcode_tb=3'b110;  //invalid
	#20;


	opcode_tb=3'b000;  //and  &a
	A_tb=3'b101;
	B_tb=3'b110;
	red_op_A_tb=1;
	red_op_B_tb=0;
	#20;

	red_op_A_tb=0;   //and &b
	red_op_B_tb=1;
	#20;

	red_op_A_tb=0;   //and a&b
	red_op_B_tb=0;
	#20;

	red_op_A_tb=1;   //and priority
	red_op_B_tb=1;
	#20;


	opcode_tb=3'b111;  //invalid
	#20;


	opcode_tb=3'b001;   //xor  ^a
	A_tb=3'b101;
	B_tb=3'b110;
	red_op_A_tb=1;
	red_op_B_tb=0;
	#20;

	red_op_A_tb=0;  //^b
	red_op_B_tb=1;
	#20;

	red_op_A_tb=0;  //a^b
	red_op_B_tb=0;
	#20;

	red_op_A_tb=1;  //xor priority
	red_op_B_tb=1;
	#20;


	
	opcode_tb=3'b101;  //invalid
	#20;


$stop;

end
endmodule
