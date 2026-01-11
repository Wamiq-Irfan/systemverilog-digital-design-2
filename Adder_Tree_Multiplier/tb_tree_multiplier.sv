module tb_tree_multiplier;
    logic clk;
    logic rst_n;
    logic [7:0] A;
    logic [7:0] B;
    logic [15:0] P;

    always #5 clk = ~clk;

    tree_multiplier DUT (
        .clk   (clk),
        .rst_n (rst_n),
        .A     (A),
        .B     (B),
        .P     (P)
    );

    initial begin
        clk  = 0;
        rst_n = 0;
        A = 0;
        B = 0;

        #10;
        rst_n = 1;
		  
      @(posedge clk);
        A = 8'd3;
        B = 8'd5;

      @(posedge clk);
        A = 8'd10;
        B = 8'd12;

        #50;
        $finish;
    end
endmodule
