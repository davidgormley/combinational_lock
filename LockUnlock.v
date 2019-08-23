//Author: Dominic Sherry
//Student ID: 14366871


module LockUnlock(
	input CleanPB, //This signal pulses when the inside button is pressed
	input ToggleLock, //This signal pulses when a correct PIN is entered on the keypad
	input reset, //This signal pulses when the power is connected to our system, e.g. after a blackout
	input clk5,
	input override, //This signal is active when the keypad is in the blocked state
	output reg unlock //This is on when the door is unlocked
);

localparam LOCKED = 1'b0, UNLOCKED = 1'b1; //States

assign ChangeState = ((ToggleLock && !override) || CleanPB);
//This is the condition necessary for the door to change from locked to unlocked, and from unlocked to locked
//We will always lock/unlock the door when the inside button is pushed, but only lock/unlock it
//from the outside when the keypad is not in the blocked state

reg curr_state = LOCKED, next_state;

always @ (curr_state, CleanPB, ToggleLock, ChangeState)  //State machine logic

	case (curr_state)
		LOCKED: if (ChangeState) next_state = UNLOCKED;
		//We can switch to the unlocked state from the locked state if the ChangeState condition from above holds true
			else next_state = curr_state;
			//Otherwise remain in the locked state
		UNLOCKED: if (ChangeState) next_state = LOCKED;
		//We can switch from the unlocked state to the locked state if the ChangeState condition from above holds true
			else next_state = curr_state;
			
		default: next_state = curr_state; //This default condition is left in to avoid latches
		//We don't strictly need it here as all states have already been accounted for above
	endcase
	
always @ (posedge clk5)
	begin
		if (reset) curr_state <= LOCKED; //We want to go to the locked state after a reset such as a blackout.
		else curr_state <= next_state;
	end
	
always @ (curr_state)
	case (curr_state)
	LOCKED: unlock = 1'b0; //When we are in the locked state we want the output signal to be off
	UNLOCKED: unlock = 1'b1; //When we are in the unlocked state we want the output signal to be on
	endcase
	
endmodule