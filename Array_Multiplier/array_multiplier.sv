module array_multiplier (
    input  logic [7:0] A,
    input  logic [7:0] B,
    output logic [15:0] P
);

    logic [7:0][7:0] pp; 

    genvar i, j;
    generate
        for (i = 0; i < 8; i++) begin : row
            for (j = 0; j < 8; j++) begin : col
                and (pp[i][j], A[j], B[i]);
            end
        end
    endgenerate

    logic [15:0] sum [7:0];

    assign sum[0] = {8'd0, pp[0]};              
    assign sum[1] = {7'd0, pp[1], 1'b0};        
    assign sum[2] = {6'd0, pp[2], 2'b0};       
    assign sum[3] = {5'd0, pp[3], 3'b0};       
    assign sum[4] = {4'd0, pp[4], 4'b0}; 
    assign sum[5] = {3'd0, pp[5], 5'b0};      
    assign sum[6] = {2'd0, pp[6], 6'b0};       
    assign sum[7] = {1'd0, pp[7], 7'b0};        

    assign P = sum[0] + sum[1] + sum[2] + sum[3] +
               sum[4] + sum[5] + sum[6] + sum[7];
endmodule
