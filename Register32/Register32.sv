module register32 (
    input  logic clk,
    input  logic rst_n,  
    input  logic load,    
    input  logic [31:0] d,
    output logic [31:0] q
);
    always_ff @(posedge clk) begin
        if (!rst_n)
            q <= 32'b0;        
        else if (load)
            q <= d;            
        else
            q <= q;              
    end
endmodule
