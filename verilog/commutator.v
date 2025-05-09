module commutator #(
    parameter WIDTH = 9
)(
    input  wire                  mode,     // 0: switch, 1: bypass
    input  wire [5:0]            com_mask, // bitmask of states
    input  wire signed [WIDTH-1:0] inUI_re,
    input  wire signed [WIDTH-1:0] inUI_im,
    input  wire signed [WIDTH-1:0] inLI_re,
    input  wire signed [WIDTH-1:0] inLI_im,
    output reg  signed [WIDTH-1:0] Up_out_re,
    output reg  signed [WIDTH-1:0] Up_out_im,
    output reg  signed [WIDTH-1:0] Low_out_re,
    output reg  signed [WIDTH-1:0] Low_out_im
);

    wire state1_com1_flag;

    wire state2_com1_flag;
    wire state2_com2_flag;

    wire state3_com1_flag;
    wire state3_com2_flag;
    wire state3_com3_flag;

    assign state1_com1_flag = com_mask[0];

    assign state2_com1_flag = com_mask[1];
    assign state2_com2_flag = com_mask[2];

    assign state3_com1_flag = com_mask[3];
    assign state3_com2_flag = com_mask[4];
    assign state3_com3_flag = com_mask[5];

    always @(*) begin


        if (mode) begin  // Bypass mode
            if (!state1_com1_flag) begin  // state1_com1_flag
                Up_out_re  = inLI_re;
                Up_out_im  = inLI_im;
            end else begin
                Low_out_re = inLI_re;
                Low_out_im = inLI_im;
            end

        end else begin  // Switch mode

            if (com_mask[1]) begin  // state2_com1_flag
                Up_out_re  = inUI_re;
                Up_out_im  = inUI_im;
            end else if (com_mask[2]) begin  // state2_com2_flag
                Up_out_re  = inLI_re;
                Up_out_im  = inLI_im;
                Low_out_re = inUI_re;
                Low_out_im = inUI_im;
            end

            if (com_mask[3]) begin  // state3_com1_flag
                Up_out_re  = inUI_re;
                Up_out_im  = inUI_im;
                Low_out_re = inLI_re;
                Low_out_im = inLI_im;
            end else if (com_mask[4]) begin  // state3_com2_flag
                Up_out_re  = inLI_re;
                Up_out_im  = inLI_im;
                Low_out_re = inUI_re;
                Low_out_im = inUI_im;
            end else if (com_mask[5]) begin  // state3_com3_flag
                Low_out_re = inLI_re;
                Low_out_im = inLI_im;
            end

        end
    end

endmodule
