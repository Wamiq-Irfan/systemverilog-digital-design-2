`include "../shift_reg_if.sv"
`include "shift_reg_pkg.sv"

module tb_shift_top;
    parameter N = 8;
    logic clk;
    shift_reg_if #(N) sif(clk);

    // DUT
    shift_reg #(N) dut (
        .clk(clk),
        .rst_n(sif.rst_n),
        .shift_en(sif.shift_en),
        .dir(sif.dir),
        .d_in(sif.d_in),
        .q_out(sif.q_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        import shift_reg_pkg::*;
        shift_env env;

        clk = 0;
        sif.rst_n = 0;
        #10 sif.rst_n = 1;

        env = new(sif);
        env.run();

        #200 $finish;
    end
endmodule
