module tree_multiplier(
    input  logic clk,
    input  logic rst_n,
    input  logic [7:0]  A,
    input  logic [7:0]  B,
    output logic [15:0] P
);

    logic [7:0] A_reg, B_reg;
    logic [15:0] pp [7:0];
    logic [15:0] s1_0, s1_1, s1_2, s1_3;
    logic [15:0] s2_0, s2_1;
    logic [15:0] s3_0;
    logic c1, c2, c3, c4, c5, c6, c7;

    integer i;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            A_reg <= 8'd0;
            B_reg <= 8'd0;
        end else begin
            A_reg <= A;
            B_reg <= B;
        end
    end

    always_comb begin
        for (i = 0; i < 8; i = i + 1)
            pp[i] = (B_reg[i]) ? (A_reg << i) : 16'd0;
    end

    ripple_adder_16 A1 (pp[0], pp[1], 1'b0, s1_0, c1);
    ripple_adder_16 A2 (pp[2], pp[3], 1'b0, s1_1, c2);
    ripple_adder_16 A3 (pp[4], pp[5], 1'b0, s1_2, c3);
    ripple_adder_16 A4 (pp[6], pp[7], 1'b0, s1_3, c4);

    ripple_adder_16 A5 (s1_0, s1_1, 1'b0, s2_0, c5);
    ripple_adder_16 A6 (s1_2, s1_3, 1'b0, s2_1, c6);

    ripple_adder_16 A7 (s2_0, s2_1, 1'b0, s3_0, c7);

    always_ff @(posedge clk) begin
        if (!rst_n)
            P <= 16'd0;
        else
            P <= s3_0;
    end

endmodule
