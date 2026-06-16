module spi_master(
    input clk,
    input reset,
    input start,
    input [7:0] data_in,

    output reg mosi,
    output reg sclk,
    output reg ss,
    output reg done
);

    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk or posedge reset)
    begin
        if(reset)
        begin
            mosi <= 0;
            sclk <= 0;
            ss <= 1;
            done <= 0;
            shift_reg <= 0;
            bit_count <= 0;
        end

        else
        begin
            if(start && ss)
            begin
                ss <= 0;
                shift_reg <= data_in;
                bit_count <= 0;
                done <= 0;
            end

            else if(!ss)
            begin
                sclk <= ~sclk;

                if(sclk == 0)
                begin
                    mosi <= shift_reg[7];

                    shift_reg <= {shift_reg[6:0],1'b0};

                    bit_count <= bit_count + 1;

                    if(bit_count == 3'd7)
                    begin
                        ss <= 1;
                        done <= 1;
                        sclk <= 0;
                    end
                end
            end
        end
    end

endmodule