module commutator_input #(
    parameter WIDTH = 9
)(
    input  wire                  mode,     // 0: switch, 1: bypass
    input wire                   flag_in_com1,
    input wire                   flag_in_com2,
    input wire                   flag_switch_state2,
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
        if (!flag_in_com1) begin
            Up_out_re = inLI_re;
            Up_out_im = inLI_im;
        end else begin
            Low_out_re = inLI_re;
            Low_out_im = inLI_im;
        end
        
    end else begin  // switch
        if(flag_in_com1 && !flag_in_com2) begin
            Up_out_re = inUI_re;
            Up_out_im = inUI_im;
        end else if (flag_in_com2 && !flag_switch_state2) begin
            Up_out_re = inLI_re;
            Up_out_im = inLI_im;
            Low_out_re = inUI_re;
            Low_out_im = inUI_im;
        end else if (flag_switch_state2) begin
            Low_out_re = inLI_re;
            Low_out_im = inLI_im;
        end 
    end
end

endmodule
