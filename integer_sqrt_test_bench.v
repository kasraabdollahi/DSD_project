module integer_sqrt_test_bench;
    reg stall = 1'b1;
    reg clk;
    reg[31:0] d;
    wire[31:0] quotient;
    wire[31:0] remainder;
    wire ready;

    integer_sqrt rooter(stall, clk, d, quotient, remainder, ready);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        #50 d = 312;
        stall = 1'b0;
        #500 stall = 1'b1;
        #20 d = 15205;
        #30 stall = 1'b0;
        #500 stall = 1'b1;
    end
    initial begin
        $monitor("stall: %d, quotient: %d, remainder: %d  ready: %d\n", stall, quotient, remainder, ready);
    end

endmodule