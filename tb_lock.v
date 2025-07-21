`timescale 1ns/1ps

module testbench;                
    reg         clock;      // Free running clock
    reg         reset;      // Reset active high
    reg         x;          // Input - X
    wire        ready;      // Output - ready for combination
    wire        unlock;     // Output - unlocked
    wire        error;      // Output - error in combination


 lock u1
    (
        .clock( clock ),
        .reset( reset ),
        .x( x ),
        .ready( ready ),
      .unlock( unlock ),
        .error( error )
    );

  always
        #5 clock = ~clock;


    initial begin
       
        clock = 0;          // Set initial values for inputs 
        reset = 0;
        x = 0;              

        #1 reset = 1;
        #9 reset = 0;

        #30                 // Wait to make sure system is idle

        // Test good sequence
        x = 1;
        #10 x = 0;
        #10 x = 1;
        #10 x = 0;
        #10 x = 1;
        #10 x = 1;

        // Test to see if stays unlocked and then returns to ready
        #30 x = 0;

        // Test 1011 which should go into error on the fourth digit
        #30 x = 1;
        #10 x = 0;
        #10 x = 1;
        #10 x = 1;

        // Stay in error until x -> 0
        #30 x = 0;

        // Wait in ready and test error on a zero
        #30 x = 1;
        #10 x = 0;
        #10 x = 1;
        #10 x = 0;  

        #30 $finish;
    end

   
endmodule
