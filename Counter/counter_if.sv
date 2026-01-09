interface counter_if #(parameter N = 8) (input logic clk);
    logic rst_n;
    logic en;
    logic up_dn;
    logic [N-1:0] count;
endinterface
