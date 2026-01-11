module array_multiplier_top (
    input  logic clk,
    input  logic rst_n,
    input  logic [7:0] data_in_A,
    input  logic [7:0] data_in_B,
    output logic [15:0] P
);

    logic [7:0] A_reg, B_reg;
    logic [15:0] mult_out;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            A_reg <= 8'd0;
            B_reg <= 8'd0;
        end else begin
            A_reg <= data_in_A;
            B_reg <= data_in_B;
        end
    end

    array_multiplier core (
        .A (A_reg),
        .B (B_reg),
        .P (mult_out)
    );

    always_ff @(posedge clk) begin
        if (!rst_n)
            P <= 16'd0;
        else
            P <= mult_out;
    end
endmodule
