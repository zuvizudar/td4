module cpu(clk,btn,led);
	input clk;
	input[3:0] btn;
	output[3:0]led;
	
	wire [3:0] ld, op,nbtn,im,nled;
	wire [7:0] dout;
	reg [3:0]addr=4'b0000;
	assign nbtn=~btn;

	reg[3:0] b=4'b0000,out_data=4'b0000,in_data=4'b0000;
	reg[4:0]a=5'b00000;
	reg c_flag=1'b0;
	
	rom memory(dout, addr);

	assign im=dout[3:0];
	assign op=dout[7:4];
	
	assign led=~out_data;
	
	
	always @(posedge clk) begin
		case(op)
			4'b0000:begin
				a<=a+im; //add
				if(a>=5'b01111)
					c_flag<=1'b1;
					
				else
					c_flag<=1'b0;
			end
			4'b0101:b<=b+im;
			
			4'b0011:a<=b;//mov 
			4'b0100:b<=a;
			
			4'b1111:addr<=im;//jmp
			
			4'b1110:begin //jnc				
				if(c_flag==1'b1)begin
					a<=5'b00000;
					addr<=addr+1;
				end
				
				else
					addr<=im;
			end			

			4'b1001:out_data<=b;//out b
			
			4'b1011:out_data<=im;//out im
		endcase
		if(op!=4'b1111 && op!=4'b1110)
			addr<=addr+1;
		
	end

endmodule 