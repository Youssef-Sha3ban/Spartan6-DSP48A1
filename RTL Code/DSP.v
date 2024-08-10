//-------------------------------------------------- DSP48A1 --------------------------------------------------//

module DSP_48A1 (A,B,C,D,CLK,CARRYIN,RSTCARRYIN,RSTOPMODE,RSTA,RSTB,RSTC,RSTD,RSTM,RSTP,
                CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, CEOPMODE, PCIN, OPMODE, BCIN,
                BCOUT, PCOUT, P, M, CARRYOUT, CARRYOUTF);

parameter A0REG = 0;
parameter A1REG = 1;
parameter B0REG = 0;
parameter B1REG = 1;

parameter CREG = 1;
parameter DREG = 1;
parameter MREG = 1;
parameter PREG = 1;
parameter CARRYINREG = 1;
parameter CARRYOUTREG = 1;
parameter OPMODEREG = 1;

parameter CARRYINSEL = "OPMODE5";  //CARRYIN
parameter B_INPUT = "DIRECT";  //CASCADE
parameter RSTTYPE = "SYNC"; //ASYNC

input CLK, CARRYIN;
input RSTCARRYIN, RSTOPMODE, RSTA, RSTB, RSTC, RSTD, RSTM, RSTP;
input CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, CEOPMODE;
input [17:0] A, B, D;
input [47:0] C, PCIN;
input [7:0] OPMODE;
input [17:0] BCIN;

output CARRYOUT , CARRYOUTF;
output [17:0] BCOUT;
output [35:0] M;
output [47:0] PCOUT , P;

//----------------------------------------------------------------------------------------------------------//

wire [7:0] opmode_r;
wire [17:0] a0_out , b0_out , d_out , b_in , pre_adder_out , bypass_b;
wire [47:0] c_out;

REG_MUX #(.STAGE(OPMODEREG) , .WIDTH(8) , .RSTTYPE(RSTTYPE)) OPMODE_REG (OPMODE , CLK , RSTOPMODE , CEOPMODE , opmode_r);
REG_MUX #(.STAGE(A0REG) , .WIDTH(18) , .RSTTYPE(RSTTYPE)) A0_REG (A , CLK , RSTA , CEA , a0_out);
REG_MUX #(.STAGE(B0REG) , .WIDTH(18) , .RSTTYPE(RSTTYPE)) B0_REG (b_in , CLK , RSTB , CEB , b0_out);
REG_MUX #(.STAGE(CREG) , .WIDTH(48) , .RSTTYPE(RSTTYPE)) C_REG (C , CLK , RSTC , CEC , c_out);
REG_MUX #(.STAGE(DREG) , .WIDTH(18) , .RSTTYPE(RSTTYPE)) D_REG (D , CLK , RSTD , CED , d_out);

assign b_in = (B_INPUT == "DIRECT")? B : (B_INPUT == "CASCADE")? BCIN : 18'b0;
assign pre_adder_out = (opmode_r[6])? (d_out - b0_out) : (d_out + b0_out);
assign bypass_b = (opmode_r[4])? pre_adder_out : b0_out;

//----------------------------------------------------------------------------------------------------------//

wire [17:0] a1_out , b1_out;
wire [35:0] multiplier_out , m_out;

reg [47:0] x_out , z_out;

REG_MUX #(.STAGE(A1REG) , .WIDTH(18) , .RSTTYPE(RSTTYPE)) A1_REG (a0_out , CLK , RSTA , CEA , a1_out);
REG_MUX #(.STAGE(B1REG) , .WIDTH(18) , .RSTTYPE(RSTTYPE)) B1_REG (bypass_b , CLK , RSTB , CEB , b1_out);
REG_MUX #(.STAGE(MREG) , .WIDTH(36) , .RSTTYPE(RSTTYPE)) M_REG (multiplier_out , CLK , RSTM , CEM , m_out);

assign multiplier_out = a1_out * b1_out;

//------------------ X_MUX & Z_MUX ------------------//
always @(*) begin
    case (opmode_r[1:0])
        0 : x_out = 0;
        1 : x_out = { {12{m_out[35]}} , m_out};
        2 : x_out = P;
        3 : x_out = {d_out[11:0] , a1_out , b1_out};
    endcase

    case (opmode_r[3:2])
        0 : z_out = 0;
        1 : z_out = PCIN;
        2 : z_out = P;
        3 : z_out = c_out;
    endcase
end

//----------------------------------------------------------------------------------------------------------//

wire carry_cascade_out , COUT , CIN;
wire [47:0] post_adder_out;

REG_MUX #(.STAGE(PREG) , .WIDTH(48) , .RSTTYPE(RSTTYPE)) P_REG (post_adder_out , CLK , RSTP , CEP , P);
REG_MUX #(.STAGE(CARRYINREG) , .WIDTH(1) , .RSTTYPE(RSTTYPE)) CYI_REG (carry_cascade_out , CLK , RSTCARRYIN , CECARRYIN , CIN);
REG_MUX #(.STAGE(CARRYOUTREG) , .WIDTH(1) , .RSTTYPE(RSTTYPE)) CYO_REG (COUT , CLK , RSTCARRYIN , CECARRYIN , CARRYOUT);

assign carry_cascade_out = (CARRYINSEL == "OPMODE5")? opmode_r[5] : (B_INPUT == "CARRYIN")? CARRYIN : 1'b0;
assign {COUT , post_adder_out} = (opmode_r[7])? (z_out - (x_out + CIN)) : (z_out + x_out + CIN);
assign CARRYOUTF = CARRYOUT;
assign PCOUT = P;
assign BCOUT = b1_out;
assign M = ~(~m_out); //buf( M , m_out); 

endmodule

