`timescale 1ns / 1ps

module synchronous_fifo_tb;

    // FIFO Parameters
    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH = 16;

    // Testbench signals
    reg clk;
    reg rst_n;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] data_in;

    wire [DATA_WIDTH-1:0] data_out;
    wire full;
    wire empty;

    // Instantiate the Synchronous FIFO
    synchronous_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock Generation
    // Clock period = 10 ns
    always #5 clk = ~clk;

    // Test Stimulus
    initial begin

        // Initial values
        clk     = 0;
        rst_n   = 0;
        wr_en   = 0;
        rd_en   = 0;
        data_in = 0;

        // Apply Reset
        #20;
        rst_n = 1;

        // -------------------------------------------------
        // WRITE 16 VALUES INTO FIFO
        // This should make FIFO FULL
        // -------------------------------------------------
        wr_en = 1;
        rd_en = 0;

        data_in = 8'd10;  #10;
        data_in = 8'd20;  #10;
        data_in = 8'd30;  #10;
        data_in = 8'd40;  #10;
        data_in = 8'd50;  #10;
        data_in = 8'd60;  #10;
        data_in = 8'd70;  #10;
        data_in = 8'd80;  #10;
        data_in = 8'd90;  #10;
        data_in = 8'd100; #10;
        data_in = 8'd110; #10;
        data_in = 8'd120; #10;
        data_in = 8'd130; #10;
        data_in = 8'd140; #10;
        data_in = 8'd150; #10;
        data_in = 8'd160; #10;

        // Stop writing
        wr_en = 0;

        // Observe FULL flag
        #20;

        // -------------------------------------------------
        // READ ALL 16 VALUES FROM FIFO
        // This should make FIFO EMPTY
        // -------------------------------------------------
        rd_en = 1;

        #160;

        // Stop reading
        rd_en = 0;

        // Observe EMPTY flag
        #20;

        // End Simulation
        $finish;

    end

endmodule
