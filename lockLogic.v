//Author: Dominic Sherry
//Student ID: 14366871


module lockLogic(
input clk5,
input reset,
input CleanPBPulse,
input newKey,
input [4:0] keyCode,
output [14:0] led,
output unlock,
output consq
);

wire LockPulse, AttemptPulse;

wire [3:0] PIN;
wire [2:0] AttemptsLED;

assign led[3:0] = PIN; //These LEDs are used to display the number of PIN digits have been inputted
assign led[8] = unlock; //This LED lights up when our door is unlocked
assign led[7:4] = 4'b0;
assign led[11:9] = 4'b0; //These are the 8 LEDs that always stay off
assign led[14:12] = AttemptsLED; //These LEDs are used to display the number of incorrect attempts


MainFSM#( //Simon's big state machine
       .CODE1(5'b10001), //1
	   .CODE2(5'b10010), //2
	   .CODE3(5'b10011), //3
	   .CODE4(5'b10100), //4
	   .CLEAR(5'b11100), //C
	   .ENTER(5'b11110)) //E 
    Main(
	   .clk5(clk5),
	   .reset(reset),
	   .newKey(newKey), //From the keypad, tells us a key was pressed
	   .keyCode(keyCode), //From the keypad, which key was pressed
	   .LockPulse(LockPulse), //Pulses when we want to lock or unlock the door
	   .attempts(AttemptPulse), //Pulses after an incorrect attempt
	   .pinOut(PIN),
	   .override(consq) //Active for a period after 3 or more incorrect attempts are entered
);

LockUnlock LockToggle ( //My module
	.clk5(clk5),
	.reset(reset),
	.CleanPB(CleanPBPulse), //Pulses when the inside button is pressed
	.ToggleLock(LockPulse), //Pulses when a correct code is entered on the keypad
	.override(consq), //Is active when we're blocking access from outside the door
	.unlock(unlock)); //On when the door is unlocked, off when locked

attemptsLeftLED AttemptsLeft ( //David's module
	.clk5(clk5),
	.reset(reset),
	.AttemptIn(AttemptPulse), //Pulses on a bad attempt
	.consq(consq), //Activated after three bad attempts for a period of time
	.CleanPB(CleanPBPulse), //A button press from the inside of the door
	.LockPulse(LockPulse), //Pusles on a good attempt
	.attempts(AttemptsLED) //Outputs the number of bad attempts in thermometer coding to 3 LEDs on the Nexys 4 board
	);

endmodule