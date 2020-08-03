module integer_sqrt #(parameter WIDTH = 32, parameter CYCLES = 14)(stall, clk, data_in, quotient, remainder, ready);
    output reg signed [WIDTH-1: 0] quotient = 0;
    output reg signed [WIDTH-1: 0] remainder = 0;
    output reg ready = 0;
    input wire unsigned [WIDTH-1: 0] data_in;
    input clk;
    input stall;

    parameter s_IDLE = 1'b0;
    parameter s_CALC = 1'b1;

    reg unsigned [6:0] c = CYCLES;
    reg state = s_IDLE;
    
    always @(posedge clk) begin
        if(stall == 1)begin
            state = s_IDLE;
            quotient = 0;
            remainder = 0;
            ready = 0;
            c = CYCLES;
        end 
        case(state)
            s_IDLE:
                begin
                    if(ready == 1) begin
                        state = s_IDLE;
                    end
                    else begin
                        state = s_CALC;
                    end
                end
            s_CALC:
                begin
                    if (remainder >= 0) begin                                                       // remainder >= 0
                        remainder = (remainder << 2) | ((data_in >> (c << 1)) & 3);
                        remainder = remainder - ((quotient << 2) | 1);
                    end
                    else begin
                        remainder = (remainder << 2) | ((data_in >> (c + 1)) & 3);
                        remainder = remainder + ((quotient << 2) | 3);
                    end

                    if (remainder >= 0) begin                                                       // remainder >= 0
                        quotient = ((quotient << 1) | 1);
                    end
                    else begin
                        quotient = (quotient << 1);
                    end

                    if (remainder < 0) begin                                                       // remainder < 0
                        remainder = remainder + ((quotient << 1) | 1);
                    end
                    if (c == 0) begin
                        ready = 1;
                        state = s_IDLE;
                    end
                    c = c - 1;
                end
        endcase
    end
    
endmodule
    
        
    // genvar c;
    // generate
    //     for(c = 31; c >= 0; c = c - 1)
    //     begin
    //         if remainder >= 0
    //         begin
    //             remainder = (remainder << 2) | ((data_in >> (c << 1)) & 3)
    //             remainder = remainder - ((quotient << 2) | 1)
    //         end
    //         else
    //         begin
    //             remainder = (remainder << 2) | ((data_in >> (c + 1)) & 3)
    //             remainder = remainder + ((quotient << 2) | 3)
    //         end

    //         if remainder >= 0:
    //         begin
    //             quotient = ((quotient << 1) | 1)
    //         end
    //         else
    //         begin
    //             quotient = (quotient << 1)
    //         end

    //         if remainder < 0:
    //             remainder = remainder + ((quotient << 1) | 1)
    //     end
    // endgenerate
    // assign quotient = quotient;
    // assign remainder = remainder;


    
    
    
    
    
    
    // genvar c;
    // generate
    //     for(c = 31; c >= 0; c = c - 1)
    //     begin
    //         if remainder >= 0
    //         begin
    //             remainder = (remainder << 2) | ((data_in >> (c << 1)) & 3)
    //             remainder = remainder - ((quotient << 2) | 1)
    //         end
    //         else
    //         begin
    //             remainder = (remainder << 2) | ((data_in >> (c + 1)) & 3)
    //             remainder = remainder + ((quotient << 2) | 3)
    //         end

    //         if remainder >= 0:
    //         begin
    //             quotient = ((quotient << 1) | 1)
    //         end
    //         else
    //         begin
    //             quotient = (quotient << 1)
    //         end

    //         if remainder < 0:
    //             remainder = remainder + ((quotient << 1) | 1)
    //     end
    // endgenerate
    // assign quotient = quotient;
    // assign remainder = remainder;

