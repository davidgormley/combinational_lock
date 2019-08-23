//Simon Grennell
//14368976


module topLock(
        input clk100,// 100 MHz clock from oscillator on board
        input rstPBn,// reset signal, active low, from CPU RESET pushbutton
        input PBin,//single push button as our input
        input [5:0] kpcol,// inputs from keypad columns
        output [7:0] digit,// digit controls - active low (7 on left, 0 on right)
        output [7:0] segment,// segment controls - active low (a b c d e f g dp)
        output [14:0] led,//Output led's to represent attempts, unlock and digits displayed
        output [3:0] kprow,// outputs to drive keyad rows
        output unlock//main unlocking output, mapped onto an led in the end put in real life could be mapped onto a door magnet
        );
        
wire [4:0]keycode;       
        
clockReset clockReset(//Clock Reset module given to us
     .clk100(clk100),// 100 MHz input clock
     .rstPBn(rstPBn),// input from reset pushbutton, active low
     .clk5(clk5),// 5 MHz output clock, buffered
     .reset(reset)  // reset output, active high
     );        
        
        
PBCleanUp Cleaner (//PBCleanUp, designed in previous assignment
    .clk5(clk5),    // clock signal at 5 MHz
    .reset(reset),  // active-high reset
    .PBin(PBin),    //input from centre Push Button
    .PBClean(CleanPBPulse)  //output of clean PB w/out bounce
    );

keypad keypadInt(//keyPadInt - module given to us
    .clk(clk5), // clock signal at 5 MHz
    .rst(reset),    // active-high asynchronous reset
    .kpcol(kpcol),  // inputs from keypad columns
    .kprow(kprow),  // outputs to drive keyad rows
    .newkey(newkey),    //output pulse for one cycle for each new keypress
    .keycode(keycode)); //output code to represent key - valid during newkey	 


lockLogic lockInt(//lock logic module - Dominic Sherry
    .clk5(clk5),    // clock signal at 5 MHz
    .reset(reset),  // active-high reset
    .CleanPBPulse(CleanPBPulse),    //input of clean PB w/out bounce
    .newKey(newkey),    //input high for one cycle for each new keypress
    .keyCode(keycode),  //input code to represent key - valid during newkey
    .led(led),  //Output led's to represent attempts, unlock and digits displayed
    .unlock(unlock),//final output of design, also input for displayInt
    .consq(consq));//input for displayInt
    
displayInt display(
    .clk(clk5),// clock signal at 5MHz
    .rst(reset),// active-high reset
    .dig(digit),    //outputs which of the 8 digits are being displayed.
	.seg(segment), //tells board which segments on 7seg display to light up - active low
	.unlock(unlock),//input to tell module to display LOC or UnLC
	.override(consq));//input which overrides unlock input to tell module to display BLOC
    
endmodule