module fp_sqrt_test_bench_dp;
reg reset;
reg clk;
reg i_sign = 1'b0;
reg unsigned [10:0] i_exp;
reg unsigned [51:0] i_frac;

wire ready;
wire o_sign;
wire unsigned [10:0] o_exp;
wire unsigned [51:0] o_frac;

initial clk = 0;
always #5 clk = ~clk;

fp_sqrt frooter(reset, clk, i_sign, i_exp, i_frac, ready, o_sign, o_exp, o_frac);

initial begin
    reset = 1'b1;
    i_sign = 1'b0;
    i_exp[10:0] = 11'b10000000011;
    i_frac[51:0] = 52'b1001000000000000000000000000000000000000000000000000;
    #30 reset = 1'b0;
    #1000 reset = 1'b1;
    i_exp[10:0] = 11'b10000000010;
    i_frac[51:0] = 52'b1000100000000000000000000000000000000000000000000000;
    #20 reset = 1'b0;
end

initial begin
    $monitor("o_sign: %d, o_exp: %d, o_frac: %d\n", o_sign, o_exp, o_frac);
end

endmodule