module is_test_bench_dp;
    reg stall = 1'b1;
    reg clk;
    reg[63:0] d;
    wire[63:0] quotient;
    wire[63:0] remainder;
    wire ready;

    defparam rooter.WIDTH = 64;
    defparam rooter.CYCLES = 28;

    integer_sqrt rooter(stall, clk, d, quotient, remainder, ready);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        #50 d = 64'h6400000000000001;
        stall = 1'b0;
        #1000 stall = 1'b1;
        #40 d = 64'h34b69da358b68;
        #30 stall = 1'b0;
        #1000 stall = 1'b1;
    end
    initial begin
        $monitor("stall: %d, quotient: %d, remainder: %d  ready: %d\n", stall, quotient, remainder, ready);
    end

endmodule