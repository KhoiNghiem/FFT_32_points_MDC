module commutator #(
    parameter WIDTH = 9
)(
    input  wire                  mode,     // 0: switch, 1: bypass
    input                        state1_com1_flag,
    input                        state2_com1_flag,
    input                        state2_com2_flag,
    input                        state3_com1_flag,
    input                        state3_com2_flag,
    input                        state3_com3_flag,
    input  wire signed [WIDTH-1:0] inUI_re,
    input  wire signed [WIDTH-1:0] inUI_im,
    input  wire signed [WIDTH-1:0] inLI_re,
    input  wire signed [WIDTH-1:0] inLI_im,
    output reg  signed [WIDTH-1:0] Up_out_re,
    output reg  signed [WIDTH-1:0] Up_out_im,
    output reg  signed [WIDTH-1:0] Low_out_re,
    output reg  signed [WIDTH-1:0] Low_out_im
);


always @(*) begin
    if (mode) begin  // bypass
        if (!state1_com1_flag) begin
            Up_out_re = inLI_re;
            Up_out_im = inLI_im;
        end else begin
            Low_out_re = inLI_re;
            Low_out_im = inLI_im;
        end
        
    end else begin  // switch
        if(state2_com1_flag) begin
            Up_out_re = inUI_re;
            Up_out_im = inUI_im;
        end else if (state2_com2_flag) begin
            Up_out_re = inLI_re;
            Up_out_im = inLI_im;
            Low_out_re = inUI_re;
            Low_out_im = inUI_im;
        end else begin
        
        end 

        if (state3_com1_flag) begin
            Up_out_re = inUI_re;
            Up_out_im = inUI_im;
            Low_out_re = inLI_re;
            Low_out_im = inLI_im;
        end else if (state3_com2_flag) begin
            Up_out_re = inLI_re;
            Up_out_im = inLI_im;
            Low_out_re = inUI_re;
            Low_out_im = inUI_im;
        end else if (state3_com3_flag) begin
            Low_out_re = inLI_re;
            Low_out_im = inLI_im;
        end

    end
end

endmodule
