//Simon Grennell
//14368976

//9 state moore machine

module MainFSM #(parameter[4:0]
	CODE1 = 5'b10001, //1
	CODE2 = 5'b10010, //2
	CODE3 = 5'b10011, //3
	CODE4 = 5'b10100, //4
	CLEAR = 5'b11100, //C
	ENTER = 5'b11110) //E
//Parameters easily changeable within the verilog files for a change in the keycode 
(
	input newKey, clk5, reset,//newKey coming from the keyPadInt, represents a new button press per pulse
	input [4:0] keyCode,//keyCode - 5bit number which identifies which button has been pressed
	input override,//override being high will stop keyCode inputs changing these states
	output LockPulse, attempts,//lockpulse to toggle lock open or closed, attemts is an indicator of a bad code being entered
	output reg [3:0] pinOut//these to be mapped onto three LED's, to indicate how many buttons have been pressed
	);

	reg [3:0] currState, nxtState;
	reg goodUnlock, badUnlock, lockRst, count, countNxt;
	wire compare, changeState;
	
	localparam//defining the state values
		NOBUTT = 4'd0,//no buttons pressed
		ONEBUTTG = 4'd1,//first button pressed correct- Good
		TWOBUTTG = 4'd2,//second bu...
		THREEBUTTG = 4'd3,
		FOURBUTTG = 4'd4,
		GOODENTER = 4'd5,//successful code entered
		ONEBUTTB = 4'd6,//first button pressed incorrect- bad
		TWOBUTTB = 4'd7,//second bu...
		THREEBUTTB = 4'd8,
		FOURBUTTB = 4'd9,
		BADENTER = 4'd10;//unsuccessful entered
		
	always@(posedge clk5)//synchronous reset
		begin
			if(reset)
				currState = NOBUTT;
			else
				currState = nxtState;
		end
		
	assign changeState = (newKey&&(!override));//allows override to stop function if high
	
		
	always@(currState, keyCode, changeState, LockPulse, attempts)//next state logic, will only occur while newKey is high
		case(currState)
			
			NOBUTT:		if(changeState && (keyCode == CLEAR)) nxtState = NOBUTT;//if clear is pressed
								else if(changeState && (keyCode == CODE1)) nxtState = ONEBUTTG;//if code button is correct
								else if (changeState && (keyCode != ENTER)) nxtState = ONEBUTTB;//do nothing if enter is pressed
								else nxtState = currState;
			
			ONEBUTTG:	if(changeState && (keyCode == CLEAR)) nxtState = NOBUTT;//if clear is pressed
								else if(changeState && (keyCode == CODE2)) nxtState = TWOBUTTG;//if code button is correct
								else if (changeState && (keyCode != ENTER)) nxtState = TWOBUTTB;//do nothing if enter is pressed
								else nxtState = currState;
						
			TWOBUTTG:	if(changeState && (keyCode == CLEAR)) nxtState = NOBUTT;//if clear is pressed
								else if(changeState && (keyCode == CODE3)) nxtState = THREEBUTTG;//if code button is correct
								else if (changeState && (keyCode != ENTER)) nxtState = THREEBUTTB;//do nothing if enter is pressed
								else nxtState = currState;
			
			THREEBUTTG:	if(changeState && (keyCode == CLEAR)) nxtState = NOBUTT;//if clear is pressed
									else if(changeState && (keyCode == CODE4)) nxtState = FOURBUTTG;//if code button is correct
									else if (changeState && (keyCode != ENTER)) nxtState = FOURBUTTB;//do nothing if enter is pressed
									else nxtState = currState;
			
			FOURBUTTG: 	if(changeState && (keyCode == CLEAR)) nxtState = NOBUTT;//if clear is pressed
									else if(changeState && (keyCode == ENTER)) nxtState = GOODENTER;//all code is good and enter pressed
									else nxtState = currState;
			
			GOODENTER:	if(LockPulse) nxtState = NOBUTT;//return to no button pressed state once lockPulse pulses
									else nxtState = GOODENTER;
			
			ONEBUTTB:	if(changeState && (keyCode == CLEAR)) nxtState = NOBUTT;//if clear is pressed
								else  if (changeState && (keyCode != ENTER)) nxtState = TWOBUTTB;//do nothing if enter is pressed
								else nxtState = currState;
						
			TWOBUTTB: 	if(changeState && (keyCode == CLEAR)) nxtState = NOBUTT;//if clear is pressed
									else if (changeState && (keyCode != ENTER)) nxtState = THREEBUTTB;//do nothing if enter is pressed
									else nxtState = currState;
			
			THREEBUTTB:	if(changeState && (keyCode == CLEAR)) nxtState = NOBUTT;//if clear is pressed
									else if (changeState && (keyCode != ENTER)) nxtState = FOURBUTTB;//do nothing if enter is pressed
									else nxtState = currState;
			
			FOURBUTTB:	if(changeState && (keyCode == CLEAR)) nxtState = NOBUTT;//if clear is pressed
									else if(changeState && (keyCode == ENTER)) nxtState = BADENTER;//some code is wrong and enter pressed
									else nxtState = currState;
			
			BADENTER:	if(attempts) nxtState = NOBUTT;// return to no button pressed state once attempts pulses
								else nxtState = BADENTER;
			
			default: nxtState = NOBUTT;
		endcase
			
		always@(currState)//defining outputs for each state
			case(currState)
				
				NOBUTT:		
							begin
								pinOut = 4'b0000;//no code entered 
								goodUnlock = 1'b0;
								badUnlock = 1'b0;
							end
				
				ONEBUTTG:	
							begin
								pinOut = 4'b0001;//one code digit entered
								goodUnlock = 1'b0;
								badUnlock = 1'b0;
							end
				
				TWOBUTTG:	
							begin
								pinOut = 4'b0011;//two code digits entered
								goodUnlock = 1'b0;
								badUnlock = 1'b0;
							end
				
				THREEBUTTG:	
							begin
								pinOut = 4'b0111; //3 code digit entered
								goodUnlock = 1'b0;
								badUnlock = 1'b0;
							end
				
				FOURBUTTG:	
							begin
								pinOut = 4'b1111; //4 code digit entered
								goodUnlock = 1'b0;
								badUnlock = 1'b0;
							end
				
				GOODENTER:	
							begin
								pinOut = 4'b0000;
								goodUnlock = 1'b1;//successful unlocking attempt
								badUnlock = 1'b0;
							end
										
				ONEBUTTB:	
							begin
								pinOut = 4'b0001;//one code digit entered
								goodUnlock = 1'b0;
								badUnlock = 1'b0;
							end
				
				TWOBUTTB:	
							begin
								pinOut = 4'b0011;//two code digit entered
								goodUnlock = 1'b0;
								badUnlock = 1'b0;
							end
				
				THREEBUTTB:	
							begin
								pinOut = 4'b0111;//three code digit entered
								goodUnlock = 1'b0;
								badUnlock = 1'b0;
							end
				
				FOURBUTTB:	
							begin
								pinOut = 4'b1111;//four code digit entered
								goodUnlock = 1'b0;
								badUnlock = 1'b0;
							end
				
				BADENTER:	
							begin
								pinOut = 4'b0000;
								goodUnlock = 1'b0;
								badUnlock = 1'b1;//unsuccessful unlocking attempt
							end
				default:    
				            begin
				                pinOut = 4'b0000;
                                goodUnlock = 1'b0;
                                badUnlock = 1'b0;
			                 end
		endcase

		
//counter that counts up to 1
//this makes our constant output of the state machine into a pulse output
		
	always@(posedge clk5)//synchronous reset
		begin
            if(reset) count <= 1'b0;
            else count <= countNxt;
        end
		
	always@(count, compare, goodUnlock, badUnlock)//multiplexer
		begin
			if(compare)countNxt = 1'b0;//if reached count value of 1
			else if(goodUnlock || badUnlock) countNxt = count + 1'b1; //if we've had a good/bad unlock attempt
			else countNxt = count;
		end
		
	assign compare = (count==1'b1);//compare is comparitor
	assign LockPulse = (compare&&goodUnlock);//we get a one clock length pulse for lockpulse
	assign attempts = (compare&&badUnlock);//we get a one clock length pulse for attempts
	
endmodule