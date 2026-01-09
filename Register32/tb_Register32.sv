`timescale 1ns/1ps
module tb_register32;
    logic clk;
    logic rst_n;
    logic load;
    logic [31:0] d;
    logic [31:0] q;
    register32 dut (
        .clk   (clk),
        .rst_n (rst_n),
        .load  (load),
        .d     (d),
        .q     (q)
    );
    always #5 clk = ~clk;
    initial begin
    clk   = 0;
    rst_n = 0;
    load  = 0;
    d     = 0;

    #10;
    rst_n = 1;     

    #10;
    load = 1;
    d    = 32'hA5A5A5A5;

    #10;
    load = 0;

    #10;
    d = 32'hFFFFFFFF;   

    #10;
    load = 1;
    d    = 32'h12345678;

    #10;
    load = 0;

    #10;
    rst_n = 0;   

    #10;
    rst_n = 1;

    #20;
    $finish;
end
endmodule

