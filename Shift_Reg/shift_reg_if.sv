interface shift_reg_if #(parameter N = 8) (input logic clk);
    logic rst_n;
    logic shift_en;
    logic dir;
    logic d_in;
    logic [N-1:0] q_out;
endinterface
