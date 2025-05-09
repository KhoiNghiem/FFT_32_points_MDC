module controller (
    input clk,
    input rst_n,
    output reg [3:0] rom_16_counter,
    output reg [2:0] rom_8_counter,

    output wire state1_com1_flag, 
    output wire state2_com1_flag,
    output wire state2_com2_flag,
    output wire state3_com1_flag,
    output wire state3_com2_flag,
    output wire state3_com3_flag
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

    reg state1_com1_flag_tmp;

    reg state2_com1_flag_tmp;
    reg state2_com2_flag_tmp;

    reg state3_com1_flag_tmp;
    reg state3_com2_flag_tmp;
    reg state3_com3_flag_tmp;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state2_com1_flag_tmp <= 0;
            state2_com2_flag_tmp <= 0;
            state1_com1_flag_tmp <= 0;
        end else begin
            // Default reset
            if (counter > 15 && counter < 32) begin
                state1_com1_flag_tmp <= 1;
            end else begin
                state1_com1_flag_tmp <= 0;
            end

            if (counter > 15 && counter < 24) begin
                state2_com1_flag_tmp <= 1;
            end else begin
                state2_com1_flag_tmp <= 0;
            end

            if (counter > 23 && counter < 32) begin
                state2_com2_flag_tmp <= 1;
            end else begin
                state2_com2_flag_tmp <= 0;
            end

            if ((counter > 23 && counter < 28) || (counter > 31 && counter < 36)) begin
                state3_com1_flag_tmp <= 1;
            end else begin
                state3_com1_flag_tmp <= 0;
            end
            if ((counter > 27 && counter < 32) || (counter > 35 && counter < 40)) begin
                state3_com2_flag_tmp <= 1;
            end else begin
                state3_com2_flag_tmp <= 0;
            end
            if ((counter > 39 && counter < 44)) begin
                state3_com3_flag_tmp <= 1;
            end else begin
                state3_com3_flag_tmp <= 0;
            end
        end
    end



    
//----------------------------------------------------------
    assign state1_com1_flag = state1_com1_flag_tmp;

    assign state2_com1_flag = state2_com1_flag_tmp;
    assign state2_com2_flag = state2_com2_flag_tmp;

    assign state3_com1_flag = state3_com1_flag_tmp;
    assign state3_com2_flag = state3_com2_flag_tmp;
    assign state3_com3_flag = state3_com3_flag_tmp;


//---------------------------------------------------------- 


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