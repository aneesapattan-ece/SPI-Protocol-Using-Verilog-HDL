module testbench;

    reg sclk;
    reg reset;
    reg ss;
    reg mosi;

    wire [7:0] received_data;
    wire done;

    spi_slave uut(
        .sclk(sclk),
        .reset(reset),
        .ss(ss),
        .mosi(mosi),
        .received_data(received_data),
        .done(done)
    );

    initial
    begin
        $dumpfile("dump.vcd");
        $dumpvars(0,testbench);

        sclk = 0;
        reset = 1;
        ss = 1;
        mosi = 0;

        #10 reset = 0;

        ss = 0;

        // Send 10101010 (8'hAA)
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(0);

        ss = 1;

        #20;
        $finish;
    end

    task send_bit;
        input bit_value;
        begin
            mosi = bit_value;

            #5 sclk = 1;
            #5 sclk = 0;
        end
    endtask

endmodule