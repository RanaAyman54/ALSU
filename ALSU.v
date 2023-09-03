module ALSU #(parameter INPUT_PERIORITY ="A" , FULL_ADDER = "ON")(

	input CLK,RST_n,
	input [2:0]A,B,opcode,
	input cin,serial_in,direction,
	input red_op_A, red_op_B,
	input bypass_A , bypass_B,

	output reg [5:0] out,
	output reg [15:0] leds
	);

parameter AND=3'b000;
parameter XOR=3'b001;
parameter Add=3'b010;
parameter Mult=3'b011;
parameter shift=3'b100;
parameter rotate=3'b101;
parameter invalid=3'b110;
parameter start=3'b111;

reg [2:0] a,b,op;
reg red_op_a,red_op_b;
reg bypass_a,bypass_b;
reg cin2,si,dir;

reg [2:0]curr_state;
reg [2:0]next_state;

reg [2:0]counter;

always@(posedge CLK ,negedge RST_n)
begin
	if(!RST_n)
  begin
	curr_state<=start;
  out<=6'b000000;
  leds<=16'b0000_0000_0000_0000;
  end
	else begin
		curr_state<=next_state;
	end
end

always@(posedge CLK)
begin
	a<=A;
	b<=B;
	op<=opcode;
	cin2<=cin;
	si<=serial_in;
	dir<=direction;
	red_op_a<=red_op_A;
	red_op_b<=red_op_B;
	bypass_a<=bypass_A;
	bypass_b<=bypass_B;
end

always@(posedge CLK)
begin
    case(curr_state)

     start  : begin

              

               if(bypass_a==1'b1 && bypass_b==1'b1 && INPUT_PERIORITY=="A")
                 out<=a;
               else if(bypass_a==1'b1 && bypass_b==1'b1 && INPUT_PERIORITY=="B")
                 out<=b;
               else if(bypass_a==1'b1 )
                 out<=a;
               else if(bypass_b==1'b1)
                 out<=b;
               else if(op==3'b110 || op==3'b111 || ( (red_op_a==1'b1 || red_op_b==1'b1) && (op!=3'b000 && op!=3'b001) ))
                 begin
                    counter<=3'b000;
                    next_state<=invalid;
                  end 
               else if(op==3'b000)
                begin
                 out<=6'b000000;
                 next_state<=AND;
                end
               else if (op==3'b001)
                 begin
                 out<=6'b000000;
                 next_state<=XOR;
                 end
               else if (op==3'b010)
                begin
                  out<=6'b000000;
                  next_state<=Add;
                end
               else if(op==3'b011)
                begin
                 out<=6'b000000;
                 next_state<=Mult;
                end
               else if(op==3'b100)
                 next_state<=shift;
               else if(op==3'b101)
                 next_state<=rotate;
               
                 

              end

     AND    : begin
               
               if(red_op_a==1'b1 && red_op_b==1'b1 && INPUT_PERIORITY=="A")
                out<=&a;
               else if(red_op_a==1'b1 && red_op_b==1'b1 && INPUT_PERIORITY=="B")
                out<=&b;
               else if(red_op_a)
                out<=&a;
               else if(red_op_b)
                out<=&b;
               else begin
               	 out<=a&b;
               end

               next_state<=start;
          

              end

     XOR    : begin
               
               if(red_op_a==1'b1 && red_op_b==1'b1 && INPUT_PERIORITY=="A")
                out<=^a;
               else if(red_op_a==1'b1 && red_op_b==1'b1 && INPUT_PERIORITY=="B")
                out<=^b;
               else if(red_op_a)
                out<=^a;
               else if(red_op_b)
                out<=^b;
               else begin
               	 out<=a^b;
               end

               next_state<=start;
              end

     Add    : begin

               if(FULL_ADDER=="ON")
               out<=a+b+cin2;
               else begin
                 out<=a+b;
               end

               next_state<=start;

              end

     Mult   : begin

               out<=a*b;
               next_state<=start;

              end

     shift  : begin

               if(dir)
               out<={out[4:0],si};
               else begin
               	out<={si,out[5:1]};
               end

               next_state<=start;

              end

     rotate : begin

               if(dir)
               out<={out[4:0],out[5]};
               else begin
               	out<={out[0],out[5:1]};
               end

               next_state<=start;

              end

    invalid: begin

               out<=6'b000000;

                 counter<=counter+1;
                 if(counter % 2'd2 ==1'b0)
                   leds<=16'b1111_1111_1111_1111;
                 else begin
                   leds<=16'b0000_0000_0000_0000;
                 end
                 if(counter==3'b100)
                  begin
                   next_state<=start;
                  end

              end
    endcase
end
endmodule


