//////////////////////////////////////////////////////////////////////////////////
// Company:      UCD School of Electrical and Electronic Engineering
// Engineer:      Brian Mulkeen
// Project:        Display Interface Design
// Target Device: XC7A100T-csg324 on Digilent Nexys-4 board
// Description:   Look-up table to map 4-bit input to 7-bit output,
//    to show value in hexadecimal on 7-segment display, segment signals active low.
//   Segment naming as shown below.  Segment pattern output in order ABCDEFG
//          --- A ---
//         |           |
//         F          B
//         |           |
//          --- G ---
//         |           |
//         E          C
//         |           |
//          --- D ---
//
// Revision 0 - File Created, 29 September 2014
// Revision 1 - Comments modified, 12 October 2015
//////////////////////////////////////////////////////////////////////////////////

module hex2seg (
   input [3:0] number,      // 4-bit number
   output reg [6:0] pattern );      // 7-segment pattern - ABCDEFG
   
// look-up table to convert 4-bit value to 7-segment pattern (0 = on)
   always @ (number)
      case(number)
         4'h0:  pattern = 7'b0000001;  // display 0
         4'hA:  pattern = 7'b1000001;  //U
         4'hB:  pattern = 7'b1100000;  //B
         4'hC:  pattern = 7'b0110001;  //C
         4'hD:  pattern = 7'b1110001;  //L
         4'hE:  pattern = 7'b1111111;  //Blank
         4'hF:  pattern = 7'b0001001;  //N
         default: pattern = 7'b1111111;
         
      endcase  // no need for default, as all possibilities covered

endmodule 