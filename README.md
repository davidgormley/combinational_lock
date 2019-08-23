# CombinationLock

The project was based on the design and implementation of a combinational lock through Verilog. The design, once completed, was implemented on a Nexys FPGA board.

## Table of Contents

Installation

Usage

Contributing

Credit

License

## Installation

To run my project you will need to download Vivado or any other software that allows you to run Verilog. You can purchase Vivado from the following site (but I am sure there exists free alternatives): (https://www.xilinx.com/products/design-tools/vivado.html)

## Usage

The ‘product’ design would be targeted at privately owned home-owners as a front door locking system which has the following specifications.

1.	A keypad interface with buttons for 0 – 9, ‘Enter’ (letter E on keypad) and ‘Clear’ (letter C on keypad) would be on the outside of the door. A four-digit passcode needs to be entered for the door to lock or unlock itself (depending on its current state).

2.	There are four lights on the keypad interface that light up as each of the four digits are pressed (represented by four LEDs on board). There are three lights to denote wrong attempts (three LEDs on board). There is a display on the keypad that shows when the door is locked, unlocked or blocked (after entering three false passcodes). This display is visible on the board as the four rightmost digits on the 7-segemnt display. There is a light that is on the inside of the door to show whether the door is locked or not and a second that behaves similarly but is not visible to user as it acts as the magnet for the door (represented by two LEDs on board). 

3.	If at any point, ‘Clear’ is pressed then it will return to the state where no inputs have been entered. Our lock will only accept a four-digit passcode.  If more than four digits are entered, then any digit after the fourth one is neglected. If ‘Enter’ is mistakenly pressed before all four digits have been entered, it is neglected. Enter must be pressed after the four digits are entered for the passcode to be confirmed.

4.	If the wrong passcode is entered, a light will signify this and it will return to the state where no inputs have been entered. If a second passcode is entered incorrectly, two lights will display the two incorrect attempts. On the final attempt (third attempt), if the passcode is entered correctly then the two lights signifying incorrect attempts will go away and the door will either lock or unlock. However, if a third incorrect passcode is entered then the keypad will be blocked and no digits can be entered.
5.	The blocked state only lasts five seconds in our prototype but for real-world use, we would change it to a longer period of time. Once the five seconds have passed, the display will return to displaying whatever state it is in and the user can enter the passcode again with another three attempts.

6.	On the inside of the door, there is a button that can lock or unlock the door even when the keypad is in the blocked state. We would not want the user to be blocked out from a passer-by who began inputting wrong attempts. This button is represented as the centre push button on the board.

### User Guide

(Assuming installation is finished and desired passcode has been chosen)

1.	When entering home (with door locked).
    
        a.	Enter your four-digit passcode and press ‘Enter’.
        
            i.	If entered correctly, the door will unlock (diplays ‘UNLC’) and you can enter.
        
            ii.	If entered incorrectly, door will remain locked (diplays ‘LOC’) and you have used up one of your three attempts. Repeat the above process again to unlock door.
        
            iii.	If you enter three wrong codes, then you will be blocked out (displays ‘bLOC’) for a given time. After which, you get three more attempts to enter the correct code.
    
        b.	At any point pressing ‘Clear’ will remove any previous digits entered.
    
2.	When entering home, and closing door behind you.
    
        a.	You can leave door unlocked, or you can lock the door by pressing the button on the inside door. Light will signal that door is unlocked.

3.	When leaving home (with door locked), press the button on inside to unlock the door.

4.	When leaving home (with door unlocked).
   
       a.	Shut the door behind you and you have the option of leaving the door unlocked or locking it.
        
            i.	To lock door, enter the correct passcode (same rules apply as for Step 1).
        
            ii.	If you leave the door unlocked, it will remain unlocked until the user locks it again from the keypad or inside button.


## Contributing

Further contribution to this project is unnecessary.

## Credit

Authors: David Gormley, Simon Grennell, Dominic Sherry

## License

This project is licensed under the terms of MIT license.
