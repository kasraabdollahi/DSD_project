`define DOUBLE_PRECISION

module fp_sqrt(reset, clk, i_sign, i_exp, i_frac, ready, o_sign, o_exp, o_frac);

`ifdef DOUBLE_PRECISION
    parameter WIDTH = 64;
    parameter EXP_WIDTH = 11;
    parameter FRAC_WIDTH = 52;
    parameter BIAS = 1023;
    parameter CYCLES = 28;
`else
    parameter WIDTH = 32;
    parameter EXP_WIDTH = 8;
    parameter FRAC_WIDTH = 23;
    parameter BIAS = 127;
    parameter CYCLES = 14;
`endif


input reset;
input clk;
input i_sign;
input wire unsigned [EXP_WIDTH-1: 0] i_exp;
input wire unsigned [FRAC_WIDTH-1: 0] i_frac;

output reg ready = 1'b0;
output reg o_sign;
output reg unsigned [EXP_WIDTH-1: 0] o_exp;
output reg unsigned [FRAC_WIDTH-1: 0] o_frac;
reg unsigned [WIDTH-1: 0] temp_frac;
wire unsigned [WIDTH-1: 0] temp_frac2;

reg stall = 1'b1;
wire signed [WIDTH-1: 0] remainder;
wire r;

parameter s_IDLE = 2'b00;
parameter s_INIT = 2'b01;
parameter s_CALC = 2'b10;

reg[1:0] state;

defparam rooter.CYCLES = CYCLES;
defparam rooter.WIDTH = WIDTH;

integer_sqrt rooter(stall, clk, temp_frac, temp_frac2, remainder, r);

always @(posedge clk) begin
    if(reset == 1'b1) begin
        state = s_IDLE;
        ready = 1'b0;
        o_sign = 1'b0;
        o_exp = 0;
        o_frac = 0;
        stall = 1;
    end
    case(state)
        s_IDLE: begin
            if(ready == 1)begin
                state = s_IDLE;
            end
            else begin
                state = s_INIT;
            end
        end
        s_INIT: begin
            o_sign = i_sign;
            o_exp[EXP_WIDTH-1: 0] = (i_exp >> 1) + (BIAS >> 1) + i_exp[0];
            if(i_exp[0] == 1'b0) begin
                `ifdef DOUBLE_PRECISION
                    temp_frac[4:0] = 0;
                    temp_frac[56:5] = i_frac[51:0];
                    temp_frac[57] = 1;
                    temp_frac[63:58] = 0;
                `else
                    temp_frac[5:0] = 0;                             
                    temp_frac[28:6] = i_frac[22:0];
                    temp_frac[29] = 1;
                    temp_frac[31:30] = 0;
                `endif
            end
            else begin
                `ifdef DOUBLE_PRECISION
                    temp_frac[3:0] = 0;
                    temp_frac[55:4] = i_frac[51:0];
                    temp_frac[56] = 1;
                    temp_frac[63:57] = 0;
                `else
                    temp_frac[4:0] = 0;
                    temp_frac[27:5] = i_frac[22:0];
                    temp_frac[28] = 1;
                    temp_frac[31:29] = 0;
                `endif
            end
            stall = 0;                                          //means start getting sqare root
            state = s_CALC;
        end
        s_CALC: begin
            if(r == 1'b1) begin
                ready = 1'b1;
                `ifdef DOUBLE_PRECISION
                    o_frac[23:0] = 0;
                    o_frac[63:24] = temp_frac2[39:0];
                `else
                    o_frac[8:0] = 0;
                    o_frac[22:9] = temp_frac2[13:0];     //means shift right the 15 bit result 9 times to become a 24 bit numbers and the 24'th bit will be gone, so o_frac will have 23 bits with right value
                `endif
                state = s_IDLE;
            end 
        end
    endcase
end

endmodule