module REG_MUX (IN, CLK, RST, EN, OUT);

parameter STAGE = 1;
parameter WIDTH = 18;
parameter RSTTYPE = "SYNC"; //ASYNC

input CLK, RST, EN;
input [WIDTH - 1 : 0] IN;
output reg [WIDTH - 1 : 0] OUT;

generate
    if (STAGE == 1 && RSTTYPE == "ASYNC") begin
        always @(posedge CLK or posedge RST) begin
            if (RST)
                OUT <= 0;

            else if (EN)
                OUT <= IN;   
        end
    end

    else if (STAGE == 1 && RSTTYPE == "SYNC") begin
        always @(posedge CLK) begin
            if (RST)
                OUT <= 0;

            else if (EN)
                OUT <= IN;   
        end
    end

    else if (~STAGE) begin
        always @(*) begin
            OUT = IN;
        end
    end

endgenerate
 
endmodule

