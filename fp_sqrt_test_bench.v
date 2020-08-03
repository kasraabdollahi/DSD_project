module fp_sqrt_test_bench;
reg reset;
reg clk;
reg i_sign = 1'b0;
reg unsigned [7:0] i_exp = 8'b10000010;
reg unsigned [22:0] i_frac = 23'b10001000000000000000000;

wire ready;
wire o_sign;
wire unsigned [7:0] o_exp;
wire unsigned [22:0] o_frac;

initial clk = 0;
always #5 clk = ~clk;

fp_sqrt frooter(reset, clk, i_sign, i_exp, i_frac, ready, o_sign, o_exp, o_frac);

initial begin
    reset = 1'b1;
    i_sign = 1'b0;
    i_exp[7:0] = 8'b10000010;
    i_frac[22:0] = 23'b10001000000000000000000;
    #30 reset = 1'b0;
    #1000 reset = 1'b1;
    i_exp[7:0] = 8'b10000011;
    i_frac[22:0] = 23'b10010000000000000000000;
    #20 reset = 1'b0;
end

initial begin
    $monitor("o_sign: %d, o_exp: %d, o_frac: %d\n", o_sign, o_exp, o_frac);
end

endmodule