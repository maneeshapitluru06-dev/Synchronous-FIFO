module synchronous_fifo #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16
)(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  wr_en,
    input  wire                  rd_en,
    input  wire [DATA_WIDTH-1:0] data_in,

    output reg  [DATA_WIDTH-1:0] data_out,
    output wire                  full,
    output wire                  empty
);

    // Calculate address width for FIFO pointers
    localparam ADDR_WIDTH = $clog2(FIFO_DEPTH);

    // Memory to store FIFO data
    reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];

    // Read and write pointers
    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;

    // Number of stored elements
    reg [ADDR_WIDTH:0] count;

    // FIFO status flags
    assign empty = (count == 0);
    assign full  = (count == FIFO_DEPTH);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr   <= 0;
            rd_ptr   <= 0;
            count    <= 0;
            data_out <= 0;
        end
        else begin
            // Write operation
            if (wr_en && !full) begin
                fifo_mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1'b1;
            end

            // Read operation
            if (rd_en && !empty) begin
                data_out <= fifo_mem[rd_ptr];
                rd_ptr <= rd_ptr + 1'b1;
            end

            // Update count
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1'b1; // Only write
                2'b01: count <= count - 1'b1; // Only read
                default: count <= count;       // Both or neither
            endcase
        end
    end

endmodule