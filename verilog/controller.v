`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2025 03:43:54 PM
// Design Name: 
// Module Name: controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module controller (
    input clk,
    input rst_n,
    input valid_in,
    output reg [4:0] state_com_mode,
    output           butter_mode,
    output           mul_mode,
    output reg [3:0] rom_16_counter,
    output reg [2:0] rom_8_counter,
    output reg [1:0] rom_4_counter,
    output reg       rom_2_counter,
    output reg  [6:0]  com_mask,
    output reg state4_com_flag,
    output reg state5_com_flag,
    output     valid_ping_pong_in
);

    reg [4:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
        end else if (valid_in) begin
            counter <= counter + 1;
        end else begin
            counter <= counter;
        end 

    end

    reg [4:0] res_counter;
    reg res_count_enable;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            res_count_enable <= 0;
        end else if (counter == 30) begin
            res_count_enable <= 1;
        end else if (res_counter == 16) begin
            res_count_enable <= 0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            res_counter <= 0;
        end else if (res_count_enable) begin
            if (res_counter == 16) begin
                res_counter <= 0;
            end else begin
                res_counter <= res_counter + 1;
            end
        end else begin
            res_counter <= 0;
        end
    end

    //-----------------MODE----------------------------//
    //-----------------COM-----------------------------//
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_com_mode <= 0;
        end else begin
            state_com_mode[0] <= (counter >= 0);                                            // stage 1
            state_com_mode[1] <= !((counter > 15 && counter < 32) || (res_counter < 9));    // stage 2
            state_com_mode[2] <= !((counter > 23 && counter < 32) || (res_counter < 13));    // stage 3
            state_com_mode[3] <= !((counter > 28 && counter < 32) || (res_counter < 15));    // stage 4
            state_com_mode[4] <= !((counter < 30 && counter < 32) || (res_counter < 16));    // stage 5
        end
    end

    //--------------BUTTERFLY------------------------//
    assign butter_mode = ((counter >= 0) || (res_counter < 16)) ? 0 : 1;

    assign mul_mode = ((counter >= 0) || (res_counter < 15)) ? 0 : 1;

    //-----------------------------------------------//


    //-----------------COM-----------------------------//
    // Các trạng thái điều khiển

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            com_mask <= 6'b0;
        end else begin
            com_mask[0] <= (counter > 15 && counter < 32);  // state1_com1_flag
            com_mask[1] <= (counter > 15 && counter < 24);  // state2_com1_flag
            com_mask[2] <= (counter > 23 && counter < 32);  // state2_com2_flag
            com_mask[3] <= (res_counter > 0 && res_counter < 9);  // ngoai khoang counter state2_com2_flag
            com_mask[4] <= (counter > 23 && counter < 28) || (res_counter > 0 && res_counter < 5); // state3_com1
            com_mask[5] <= (counter > 27 && counter < 32) || (res_counter > 4 && res_counter < 9); // state3_com2
            com_mask[6] <= (res_counter > 8 && res_counter < 13);  // state3_com3

        end
    end

//----------------------------------------------------------
    reg [1:0] pulse_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state4_com_flag <= 0;
            pulse_cnt  <= 0;
        end else begin
            if ((counter > 26 && counter < 32) || (res_counter < 15 && res_count_enable)) begin
                if (pulse_cnt == 1) begin
                    state4_com_flag <= ~state4_com_flag;
                    pulse_cnt  <= 0;
                end else begin
                    pulse_cnt <= pulse_cnt + 1;
                end
            end else begin
                state4_com_flag <= 0;
                pulse_cnt  <= 0;
            end
        end
    end

    //-----------------------------------------------------//

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state5_com_flag  <= 0;
        end else begin
            if ((counter > 27 && counter < 32) || (res_count_enable && res_counter < 16)) begin  // counter từ 29 đến 46
                state5_com_flag <= ~state5_com_flag; // Toggle mỗi chu kỳ
            end else begin
                state5_com_flag <= 0;
            end
        end
    end

    //-----------------COM-----------------------------//

    //-----------------ROM16-----------------------------//
    reg flag_in_rom_16;
    wire valid_in_rom16;
    reg flag_in_tmp_rom16;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag_in_tmp_rom16 <= 0;
        end else if (counter == 15) begin
            flag_in_tmp_rom16 <= 1;
        end
    end

    assign valid_in_rom16 = flag_in_tmp_rom16;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rom_16_counter <= 0;
        end else if (flag_in_rom_16) begin
            rom_16_counter <= rom_16_counter + 1;
        end else begin
            rom_16_counter <= 0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag_in_rom_16 <= 0;
        end else if (valid_in_rom16) begin
            flag_in_rom_16 <= 1;
        end else if (flag_in_rom_16 && rom_16_counter == 15) begin
            flag_in_rom_16 <= 0;
        end else begin
            flag_in_rom_16 <= flag_in_rom_16;
        end
    end

    //-----------------ROM16-----------------------------//

    //-----------------ROM8-----------------------------//

    reg flag_in_rom_8;
    wire valid_in_rom8;
    reg flag_in_tmp_rom8;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag_in_tmp_rom8 <= 0;
        end else if (counter == 23) begin
            flag_in_tmp_rom8 <= 1;
        end
    end

    assign valid_in_rom8 = flag_in_tmp_rom8;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rom_8_counter <= 0;
        end else if (flag_in_rom_8) begin
            rom_8_counter <= rom_8_counter + 1;
        end else begin
            rom_8_counter <= 0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag_in_rom_8 <= 0;
        end else if (valid_in_rom8) begin
            flag_in_rom_8 <= 1;
        end else if (flag_in_rom_8 && rom_8_counter == 7) begin
            flag_in_rom_8 <= 0;
        end else begin
            flag_in_rom_8 <= flag_in_rom_8;
        end
    end

    //-----------------ROM8-----------------------------//
    //-----------------ROM4-----------------------------//

    reg flag_in_rom_4;
    wire valid_in_rom4;
    reg flag_in_tmp_rom4;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag_in_tmp_rom4 <= 0;
        end else if (counter == 27) begin
            flag_in_tmp_rom4 <= 1;
        end
    end

    assign valid_in_rom4 = flag_in_tmp_rom4;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rom_4_counter <= 0;
        end else if (flag_in_rom_4) begin
            rom_4_counter <= rom_4_counter + 1;
        end else begin
            rom_4_counter <= 0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag_in_rom_4 <= 0;
        end else if (valid_in_rom4) begin
            flag_in_rom_4 <= 1;
        end else if (flag_in_rom_4 && rom_4_counter == 3) begin
            flag_in_rom_4 <= 0;
        end else begin
            flag_in_rom_4 <= flag_in_rom_4;
        end
    end

    //-----------------ROM2-----------------------------//

    reg flag_in_rom_2;
    wire valid_in_rom2;
    reg flag_in_tmp_rom2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag_in_tmp_rom2 <= 0;
        end else if (counter == 29) begin
            flag_in_tmp_rom2 <= 1;
        end
    end

    assign valid_in_rom2 = flag_in_tmp_rom2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rom_2_counter <= 0;
        end else if (flag_in_rom_2) begin
            rom_2_counter <= rom_2_counter + 1;
        end else begin
            rom_2_counter <= 0;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag_in_rom_2 <= 0;
        end else if (valid_in_rom2) begin
            flag_in_rom_2 <= 1;
        end else if (flag_in_rom_2 && rom_2_counter == 1) begin
            flag_in_rom_2 <= 0;
        end else begin
            flag_in_rom_2 <= flag_in_rom_2;
        end
    end

    //------------PINGPONG--------------------//
    assign valid_ping_pong_in = (counter == 31);

endmodule
