`include "../array_if.sv"
`include "array_multiplier_pkg.sv"

module tb_array_multiplier;
    import array_multiplier_pkg::*;   

    logic clk;
    array_if tb_if(clk);           
    array_multiplier_top DUT (
        .clk       (clk),
        .rst_n     (tb_if.rst_n),
        .data_in_A (tb_if.data_in_A),
        .data_in_B (tb_if.data_in_B),
        .P         (tb_if.P)
    );
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        tb_if.rst_n = 0;
        #10 tb_if.rst_n = 1;
    end

    mailbox gen2drv;
    mailbox mon2sb;

    mult_gen     gen;
    mult_driver  drv;
    mult_monitor mon;
    mult_sb      sb;

    initial begin
        gen2drv = new();
        mon2sb  = new();

        gen = new(gen2drv);
        drv = new(tb_if);
        mon = new(tb_if, mon2sb);
        sb  = new(mon2sb);

        fork
            gen.run();
            drv.drive_loop(gen2drv);
            mon.run();
            sb.run();
        join_any

        #100 $finish;
    end
endmodule
