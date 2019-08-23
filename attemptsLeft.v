//Project:  Combination Lock Design
//Date:     30/11/2016
//Author:   David Gormley
// This block of hardware takes in a pulse from the entering
// of the incorrect passcode. Each time a wrong passcode
// is entered I want to inform the user that they have used a certain
// number of attempts. We do this by lighting a bulb on the board
// for each incorrect passcode entered. Moore Machine.
 
module attemptsLeftLED
                (   input clk5,
                    input reset,
                    input AttemptIn,        //Signals that an incorrect attempt has been made
					input CleanPB,          //Inside door button signal
					input LockPulse,        //Signal to say code enter correctly
                    output reg consq,       //Output to say that user is blocked from using keypad
                    output reg [2:0] attempts); //Signal to the three LEDs that represent number of attempts
                    
    reg [2:0] currState, nextState;
    reg [24:0] count, countNxt;
    wire compare;                       //Signal that returns from counter to signal to leave restricted state and return to ATTEMPT3
	wire AttemptsReset = (CleanPB || LockPulse);    //Return to ATTEMPT3 when it goes high
                    
    localparam [1:0] ATTEMPT3 = 2'b00,
            ATTEMPT2 = 2'b01,
            ATTEMPT1 = 2'b10,
            NOATTEMPTS = 2'b11;
            
    always@(posedge clk5)
        begin
            if(reset)
                currState <= ATTEMPT3;     //If power outage, we would want the reset default to be no attempts entered.
            else
                currState <= nextState;
        end
        
    always@(currState, AttemptIn, AttemptsReset, compare)
        case(currState)
            ATTEMPT3: if (AttemptIn) nextState = ATTEMPT2;
							else if (AttemptsReset) nextState = ATTEMPT3;
                            else nextState = ATTEMPT3;
                            
            ATTEMPT2: if (AttemptIn) nextState = ATTEMPT1;
							else if (AttemptsReset) nextState = ATTEMPT3;
                            else nextState = ATTEMPT2;
                            
            ATTEMPT1:  if (AttemptIn) nextState = NOATTEMPTS;
							else if (AttemptsReset) nextState = ATTEMPT3;
                            else nextState = ATTEMPT1;
                            
            NOATTEMPTS: if (compare) nextState = ATTEMPT3;
                            else nextState = NOATTEMPTS;
                            
            default:        nextState = ATTEMPT3;
        endcase
 
    always@(currState)
        case(currState)
            ATTEMPT3:  begin
                            attempts = 3'b000;  //No LEDs lighting
                            consq = 1'b0;
                        end
            
            ATTEMPT2:  begin
                            attempts = 3'b001;  //1 LED
                            consq = 1'b0;
                        end
                        
            ATTEMPT1:  begin
                            attempts = 3'b011;  //2 LEDs
                            consq = 1'b0;
                        end
                        
            NOATTEMPTS:  begin
                            attempts = 3'b111;  //3 LEDs
                            consq = 1'b1;
                        end
            default:
                    begin    
                        attempts = 3'b000;
                        consq = 1'b0;
                    end               
        endcase
        
    always@(posedge clk5)//Synchronous reset, counter for restriction time
        begin
                if(reset) count <= 25'b0;
                else count <= countNxt;
            end
                
    always@(count, compare, consq)//Multiplexer with selecting inputs of compare and consq
        begin
            if(compare)countNxt = 25'b0;            //This way I will return to zero after counting up to 5seconds
            else if(consq) countNxt = count + 1'b1;
            else countNxt = count;
        end        
    assign compare = (count == 25'd24999999);   //Counts up to 5 seconds - PROTOTYPE only, would be changed for real world use.

endmodule                    