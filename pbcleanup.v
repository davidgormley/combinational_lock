//Project:      Stopwatch Design (Reusing for this Combination Lock Design)
//Author:       David Gormley
//Date:         13 November 2016
//Description:  Ensuring bounce does not affect the one start/stop puch button design

module PBCleanUp
	#(parameter comparePB = 13'd7499, holdVal = 13'd7500)   //7500 clock cycles refers to 1.5ms (chosen becasue bounce will never last this long)
	(  input PBin,                                          //Single push button input
		input clk5,
		input reset,
		output PBClean);                                    //Filtered out bounce and interprets input as a single press of buton

    //Bit width of 13 chosen so that count can count up to 7500
	reg[12:0] count;
	reg[12:0] countNxt;
	//holdOut is output that determines if count is held at holdVal
	wire holdOut;
	
	//Register with synchronous reset
	always@(posedge clk5)
        begin
            if(reset) count <= 13'd0;
            else count <= countNxt;
        end
      
    //Multiplexer with select inputs PBin and holdOut
    always@(PBin, count, holdOut)
        begin
            if (!PBin) countNxt = 13'd0; //We want it so every time the PB goes high, it starts from zero and counts up. For each bounce.
            else if(!holdOut) countNxt = count + 1'd1;
            else countNxt = count;
        end
    
    //We compare to 7499 because at this point the clock will have counted up to 1.5ms which is long enough to make sure there are no bounces.
    assign PBClean = (count == comparePB);
    
    //We compare to 7500 because at this point the counter will hold its value until the button is released.
    assign holdOut = (count == holdVal);
    
endmodule