module testbench;

    reg clk;
    reg reset;
    reg start;
    reg [7:0] data_in;

    wire mosi;
    wire sclk;
    wire ss;
    wire master_done;

    wire [7:0] received_data;
    wire slave_done;

    spi_system uut(
        .clk(clk),
        .reset(reset),
        .start(start),
        .data_in(data_in),

        .mosi(mosi),
        .sclk(sclk),
        .ss(ss),
        .master_done(master_done),

        .received_data(received_data),
        .slave_done(slave_done)
    );

    always #5 clk = ~clk;

    initial
    begin
        $dumpfile("dump.vcd");
        $dumpvars(0,testbench);

        clk = 0;
        reset = 1;
        start = 0;

        data_in = 8'hAA;   // 10101010

        #10 reset = 0;

        #10 start = 1;
        #10 start = 0;

        #250;

        $finish;
    end

endmodule