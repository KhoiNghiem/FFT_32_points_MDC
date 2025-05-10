module controller (
    input clk,
    input rst_n,
    output reg [3:0] rom_16_counter,
    output reg [2:0] rom_8_counter,
    output reg [1:0] rom_4_counter,
    output reg       rom_2_counter,
    output reg  [6:0]  com_mask,
    output reg state4_com_flag,
    output reg state5_com_flag,
    output     valid_ping_pong_in
);

    reg [6:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

    //-----------------COM-----------------------------//
// Các trạng thái điều khiển

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            com_mask <= 6'b0;
        end else begin
            com_mask[0] <= (counter > 15 && counter < 32);  // state1_com1_flag
            com_mask[1] <= (counter > 15 && counter < 24);  // state2_com1_flag
            com_mask[2] <= (counter > 23 && counter < 32);  // state2_com2_flag
            com_mask[3] <= (counter > 31 && counter < 40);  // state2_com2_flag
            com_mask[4] <= (counter > 23 && counter < 28) || (counter > 31 && counter < 36); // state3_com1
            com_mask[5] <= (counter > 27 && counter < 32) || (counter > 35 && counter < 40); // state3_com2
            com_mask[6] <= (counter > 39 && counter < 44);  // state3_com3

        end
    end

//----------------------------------------------------------
    reg [1:0] pulse_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state4_com_flag <= 0;
            pulse_cnt  <= 0;
        end else begin
            if (counter > 26 && counter < 46) begin
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
            if (counter > 27 && counter < 47) begin  // counter từ 29 đến 46
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
            flag_in_rom_16 = flag_in_rom_16;
        end
    end

    //-----------------ROM16-----------------------------//

    //-----------------ROM8-----------------------------//

    reg flag_in_rom_8;
    reg [1:0] count_flag_rom8;
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
            flag_in_rom_8 = flag_in_rom_8;
        end
    end

    //-----------------ROM8-----------------------------//
    //-----------------ROM4-----------------------------//

    reg flag_in_rom_4;
    reg [1:0] count_flag_rom4;
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
            count_flag_rom4 <= 0;
        end else if (valid_in_rom4) begin
            flag_in_rom_4 <= 1;
            count_flag_rom4 <= 0;
        end else if (flag_in_rom_4 && rom_4_counter == 3 && count_flag_rom4 == 2) begin
            flag_in_rom_4 <= 0;
            count_flag_rom4 <= 0;
        end else if (flag_in_rom_4 && rom_4_counter == 3) begin
            count_flag_rom4 <= count_flag_rom4 + 1;
        end else begin
            count_flag_rom4 = count_flag_rom4;
        end
    end

    //-----------------ROM2-----------------------------//

    reg flag_in_rom_2;
    reg [3:0] count_flag_rom2;
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
            count_flag_rom2 <= 0;
        end else if (valid_in_rom2) begin
            flag_in_rom_2 <= 1;
            count_flag_rom2 <= 0;
        end else if (flag_in_rom_2 && rom_2_counter == 1 && count_flag_rom2 == 7) begin
            flag_in_rom_2 <= 0;
            count_flag_rom2 <= 0;
        end else if (flag_in_rom_2 && rom_2_counter == 1) begin
            count_flag_rom2 <= count_flag_rom2 + 1;
        end else begin
            count_flag_rom2 = count_flag_rom2;
        end
    end

    //------------PINGPONG--------------------//
    assign valid_ping_pong_in = (counter == 31);

endmodule