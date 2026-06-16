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