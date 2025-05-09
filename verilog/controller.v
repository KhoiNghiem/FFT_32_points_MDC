module controller (
    input clk,
    input rst_n,
    output reg [3:0] rom_16_counter,
    output reg [2:0] rom_8_counter,
    output wire flag_in_com1,
    output wire flag_in_com2,
    output wire flag_in_com3,
    output wire flag_in_com4,
    output wire flag_switch_state2_1,
    output wire flag_switch_state3_1
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

    reg flag_in_tmp_com1;
    reg flag_in_tmp_com2;
    reg flag_in_tmp_com3;
    reg flag_in_tmp_com4;

    reg flag_switch_tmp_state2_1;
    reg flag_switch_tmp_state3_1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag_in_tmp_com1 <= 0;
            flag_in_tmp_com2 <= 0;
            flag_in_tmp_com3 <= 0;
            flag_in_tmp_com4 <= 0;
        end else if (counter == 16) begin
            flag_in_tmp_com1 <= 1;
        end else if (counter == 24) begin
            flag_in_tmp_com2 <= 1;
        end else if (counter == 28) begin
            flag_in_tmp_com3 <= 1;
        end else if (counter == 30) begin
            flag_in_tmp_com4 <= 1;
        end 
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            flag_switch_tmp_state2_1 <= 0;
        end else begin
            if (counter == 32) begin
                flag_switch_tmp_state2_1 <= 1;
            end else if(counter == 36) begin
                flag_switch_tmp_state3_1 <= 1;
            end
        end
    end

    assign flag_switch_state2_1 = flag_switch_tmp_state2_1;
    assign flag_switch_state3_1 = flag_switch_tmp_state3_1;

    assign flag_in_com1 = flag_in_tmp_com1;
    assign flag_in_com2 = flag_in_tmp_com2;
    assign flag_in_com3 = flag_in_tmp_com3;
    assign flag_in_com4 = flag_in_tmp_com4;
    


    //-----------------COM-----------------------------//

    //-----------------ROM16-----------------------------//
    reg flag_in_rom_16;
    reg [1:0] count_flag_rom16;
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
            count_flag_rom16 <= 0;
        end else if (valid_in_rom16) begin
            flag_in_rom_16 <= 1;
            count_flag_rom16 <= 0;
        end else if (flag_in_rom_16 && rom_16_counter == 15 && count_flag_rom16 == 0) begin
            flag_in_rom_16 <= 0;
            count_flag_rom16 <= 0;
        end else if (flag_in_rom_16 && rom_16_counter == 15) begin
            count_flag_rom16 <= count_flag_rom16 + 1;
        end else begin
            count_flag_rom16 = count_flag_rom16;
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
            count_flag_rom8 <= 0;
        end else if (valid_in_rom8) begin
            flag_in_rom_8 <= 1;
            count_flag_rom8 <= 0;
        end else if (flag_in_rom_8 && rom_8_counter == 7 && count_flag_rom8 == 1) begin
            flag_in_rom_8 <= 0;
            count_flag_rom8 <= 0;
        end else if (flag_in_rom_8 && rom_8_counter == 7) begin
            count_flag_rom8 <= count_flag_rom8 + 1;
        end else begin
            count_flag_rom8 = count_flag_rom8;
        end
    end

endmodule