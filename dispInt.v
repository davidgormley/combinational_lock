//Project:  Combination Lock Design
//Author:   David Gormley
//Date:     3rd Deecember 2016
//Description:  Based on inputs unlock and override, outputs correct 7bit sequence for LOC, UNLC and bLOC

module displayInt (input clk, rst,
					output reg [7:0] dig,   //Output controls which digit visible on display
					output [7:0] seg,       //Outputs combination of segments to match each digit
					input unlock,           //Added this new input to enter the hexStatus multiplexer as a select input for lock/unlock state
					input override          //Added new input to decide if we are in blocked state or not
);
    //Made a small adjustment to hex2seg so that our desired letters could be displayed.
    //The hex value below = the segment that will be displayed once the module hex2seg converts it.
    //O = 0, A = U, B = B, C = C, D = L, E = Blank, F = N
    
    wire[15:0] valLock = 16'hD0CE;      //LOC
	wire[15:0] valUnlock = 16'hAFDC;    //UNLC
	wire[15:0] valBlock = 16'hBD0C;     //BLOC
	reg[15:0] val;                      //input into hexStatus
	reg[11:0] control, controlNext;
	reg[3:0] valOut;
	assign seg[0] = 1'b1;               //So the point marker will always be off
	
	always@(posedge clk)
		begin
			controlNext <= control+1'd1;
			if(rst) control <= 12'd0;
			else control <= controlNext;
		end
	
	always@(control)
		case(control[11:10])            //Two MSB of control as the select inputs means the digits will appear on at the same time to user.
			2'b00:	dig = 8'b11111110;
			2'b01:	dig = 8'b11111101;
			2'b10:	dig = 8'b11111011;
			2'b11:	dig = 8'b11110111;
		endcase
	
	//Multiplexer for choosing what value val will take
	always@(unlock, override, valBlock, valUnlock, valLock)
        begin   
            if(override) val = valBlock;
            else if(unlock) val = valUnlock; 	    
	        else val = valLock;
	    end
	
	//Ensuring that segments and digits match
	always@(control, val)
		case(control[11:10])
			2'b00:	valOut = val[3:0];
			2'b01:	valOut = val[7:4];
			2'b10:	valOut = val[11:8];
			2'b11:	valOut = val[15:12];
		endcase
	
	//hex2seg will convert the hexadecimal value into a 7bit pattern to be used on the display
	hex2seg convert(.number(valOut), .pattern(seg[7:1]));
    
endmodule		