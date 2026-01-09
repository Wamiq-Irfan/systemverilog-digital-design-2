`include "../counter_if.sv"
`include "counter_pkg.sv"

module tb_top;
    parameter N = 8;
    logic clk;
    counter_if #(N) cif(clk);

    // DUT
    counter #(N) dut (
        .clk(clk),
        .rst_n(cif.rst_n),
        .en(cif.en),
        .up_dn(cif.up_dn),
        .count(cif.count)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        import counter_pkg::*;
        counter_env env;

        clk = 0;
        cif.rst_n = 0;
        #10 cif.rst_n = 1;

        env = new(cif);
        env.run();

        #200 $finish;
    end
endmodule
