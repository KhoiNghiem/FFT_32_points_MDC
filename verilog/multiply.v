//----------------------------------------------------------------------
//  Multiply: Complex Multiplier with Bypass Mode
//----------------------------------------------------------------------
module multiply #(
    parameter   WIDTH = 10
)(
    input   wire                mode,      // 0: multiply, 1: bypass
    input   signed  [WIDTH-1:0] x0_re,
    input   signed  [WIDTH-1:0] x0_im,
    input   signed  [WIDTH-2:0] rom_re,
    input   signed  [WIDTH-2:0] rom_im,
    output  reg  signed [2*WIDTH-2:0] m_re,
    output  reg  signed [2*WIDTH-2:0] m_im
);

wire signed [2*WIDTH-4:0] arbr, arbi, aibr, aibi;

// Multiplication components
assign arbr  = x0_re * rom_re;
assign arbi  = x0_re * rom_im;
assign aibr  = x0_im * rom_re;
assign aibi  = x0_im * rom_im;


always @(*) begin
    if (mode == 1'b0) begin
        // Normal complex multiplication
        m_re = arbr - aibi;
        m_im = arbi + aibr;
    end else begin
        // Bypass mode: keep original x0
        m_re = x0_re;
        m_im = x0_im;
    end
end

endmodule
