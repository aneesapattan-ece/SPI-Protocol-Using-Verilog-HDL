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

                    shift_reg <= {shift_reg[6:0], 1'b0};

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


module spi_slave(
    input sclk,
    input reset,
    input ss,
    input mosi,

    output reg [7:0] received_data,
    output reg done
);

    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge sclk or posedge reset)
    begin
        if(reset)
        begin
            received_data <= 8'd0;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
            done <= 1'b0;
        end
        else if(!ss)
        begin
            shift_reg <= {shift_reg[6:0], mosi};

            bit_count <= bit_count + 1;

            if(bit_count == 3'd7)
            begin
                received_data <= {shift_reg[6:0], mosi};
                done <= 1'b1;
                bit_count <= 3'd0;
            end
        end
        else
        begin
            done <= 1'b0;
        end
    end

endmodule


module spi_system(
    input clk,
    input reset,
    input start,
    input [7:0] data_in,

    output mosi,
    output sclk,
    output ss,
    output master_done,

    output [7:0] received_data,
    output slave_done
);

    spi_master master(
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(data_in),

        .mosi(mosi),
        .sclk(sclk),
        .ss(ss),
        .done(master_done)
    );

    spi_slave slave(
        .sclk(sclk),
        .reset(reset),
        .ss(ss),
        .mosi(mosi),

        .received_data(received_data),
        .done(slave_done)
    );

endmodule