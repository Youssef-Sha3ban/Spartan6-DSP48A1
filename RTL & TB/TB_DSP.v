//-------------------------------------------------- DSP Testbench --------------------------------------------------//

module TB_DSP ();

parameter A0REG = 1;//
parameter A1REG = 1;
parameter B0REG = 1;//
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

reg clk, CARRYIN;
reg RSTCARRYIN, RSTOPMODE, RSTA, RSTB, RSTC, RSTD, RSTM, RSTP;
reg CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, CEOPMODE;
reg [17:0] A, B, D, PRE_EXP;
reg [47:0] C, PCIN;
reg [7:0] OPMODE;
reg [17:0] BCIN;

wire CARRYOUT , CARRYOUTF;
wire [17:0] BCOUT;
wire [35:0] M;
wire [47:0] PCOUT , P;

reg [47:0] EXPECTED;

DSP48A1 #(A0REG,A1REG,B0REG,B1REG,CREG,DREG,MREG,PREG,CARRYINREG,CARRYOUTREG,OPMODEREG,CARRYINSEL,B_INPUT,RSTTYPE) 
        DUT (A,B,C,D,clk,CARRYIN,RSTCARRYIN,RSTOPMODE,RSTA,RSTB,RSTC,RSTD,RSTM,RSTP,
            CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, CEOPMODE, PCIN, OPMODE, BCIN,
            BCOUT, PCOUT, P, M, CARRYOUT, CARRYOUTF);

initial begin
    clk = 0;
    forever
        #10 clk = ~clk;
end

initial begin
    $display("\n-------------------------------------------> Testing Reset <-------------------------------------------\n");

    RSTOPMODE= 1; RSTA= 1; RSTB= 1; RSTC= 1; RSTD= 1; RSTM= 1; RSTP= 1; RSTM= 1; RSTCARRYIN= 1;

    repeat (10) begin
        CEA=$random; CEB=$random; CEM=$random;
        CEP=$random; CEC=$random; CED=$random;
        CECARRYIN=$random; CEOPMODE=$random; CARRYIN=$random;
        OPMODE=$random; PCIN=$random; BCIN=$random;
        A=$random; B=$random; C=$random; D=$random;

        EXPECTED = 0;

        @(negedge clk);

        if (P != EXPECTED) begin
            $display("ERROR!! Incorrect Output :(");
            $stop;
        end
    end
 //--------------------------------------------enable--------------------------------------------------------
    $display("\n-------------------------------------------> Testing Enable <-------------------------------------------\n");

    RSTOPMODE= 0; RSTA= 0; RSTB= 0; RSTC= 0; RSTD= 0; RSTM= 0; RSTP= 0; RSTM= 0; RSTCARRYIN= 0;
    CEA= 0; CEB= 0; CEM= 0; CEP= 0; CEC= 0; CED= 0; CECARRYIN= 0; CEOPMODE= 0;

    repeat (10) begin
        CARRYIN=$random;
        OPMODE=$random; PCIN=$random; BCIN=$random;
        A=$random; B=5; C=$random; D=$random;

        EXPECTED = 0;

        @(negedge clk);

        if (P != EXPECTED) begin
            $display("ERROR!! Incorrect Output :(");
            $stop;
        end
    end
 //-------------------------------------------------bypass B---------------------------------------------------
     $display("\n-------------------------------------------> Testing bypass B <-------------------------------------------\n");

    CEA= 1; CEB= 1; CEM= 1; CEP= 1; CEC= 1; CED= 1; CECARRYIN= 1; CEOPMODE= 1;
    
 // OPMODE = 8'b 7_6_5_4_32_10;
    OPMODE = 8'b 0_0_0_0_11_01;

    A = 1; C = 0;

    repeat (10) begin

        B = $urandom_range(0,15);

        PCIN=$random; BCIN=$random; D=$random;

        EXPECTED = B;

        repeat (4) @(negedge clk);

        if (P != EXPECTED) begin
            $display("ERROR!! Incorrect Output :(");
            $stop;
        end
    end

 //--------------------------------------------operation--------------------------------------------------------
    $display("\n-------------------------------------------> Testing arithmetic operations <-------------------------------------------\n");

    RSTOPMODE= 1; RSTA= 1; RSTB= 1; RSTC= 1; RSTD= 1; RSTM= 1; RSTP= 1; RSTM= 1; RSTCARRYIN= 1;

    repeat (4) @(negedge clk);

    RSTOPMODE= 0; RSTA= 0; RSTB= 0; RSTC= 0; RSTD= 0; RSTM= 0; RSTP= 0; RSTM= 0; RSTCARRYIN= 0;


    OPMODE[4:0] = 5'b 1_11_01;

    repeat (100) begin

        D = $urandom_range(7);
        B = $urandom_range(7);
        A = $urandom_range(7);
        C = $urandom_range(7);
        OPMODE[7:5] = $random;

        case (OPMODE[7:6])
            2'b00 : begin PRE_EXP = D+B; EXPECTED = C + (A*PRE_EXP + OPMODE[5]); end
            2'b01 : begin PRE_EXP = D-B; EXPECTED = C + (A*PRE_EXP + OPMODE[5]); end
            2'b10 : begin PRE_EXP = D+B; EXPECTED = C - (A*PRE_EXP + OPMODE[5]); end
            2'b11 : begin PRE_EXP = D-B; EXPECTED = C - (A*PRE_EXP + OPMODE[5]); end
        endcase

        repeat (4) @(negedge clk);

        if (P != EXPECTED) begin
            $display("ERROR!! Incorrect Output :(");
            $stop;
        end
    end
 //---------------------------------------------------accumlator x -------------------------------------------------
    $display("\n-------------------------------------------> Testing Accumlator through X <-------------------------------------------\n");

    RSTOPMODE= 1; RSTA= 1; RSTB= 1; RSTC= 1; RSTD= 1; RSTM= 1; RSTP= 1; RSTM= 1; RSTCARRYIN= 1;
    @(negedge clk);
    RSTOPMODE= 0; RSTA= 0; RSTB= 0; RSTC= 0; RSTD= 0; RSTM= 0; RSTP= 0; RSTM= 0; RSTCARRYIN= 0;

    OPMODE = 8'b 0_0_0_0_11_10;
    C = 2;
    EXPECTED = 2;

    repeat (2) @(negedge clk);

    repeat (100) begin

        D = $random;
        B = $random;
        A = $random;

        EXPECTED = EXPECTED + 2;

        @(negedge clk);

        if (P != EXPECTED) begin
            $display("ERROR!! Incorrect Output :(");
            $stop;
        end
    end
 //-----------------------------------------------------accumlator z-----------------------------------------------
    $display("\n-------------------------------------------> Testing Accumlator through Z <-------------------------------------------\n");
 
    RSTOPMODE= 1; RSTA= 1; RSTB= 1; RSTC= 1; RSTD= 1; RSTM= 1; RSTP= 1; RSTM= 1; RSTCARRYIN= 1;
    @(negedge clk);
    RSTOPMODE= 0; RSTA= 0; RSTB= 0; RSTC= 0; RSTD= 0; RSTM= 0; RSTP= 0; RSTM= 0; RSTCARRYIN= 0;

    OPMODE = 8'b 0_0_0_0_10_01;
    B = 2;
    //C = 2;
    A = 1;

    EXPECTED = 2;

    repeat (4) @(negedge clk);

    repeat (100) begin
        D = $random;
        C = $random;
        EXPECTED = EXPECTED + 2;

        @(negedge clk);

        if (P != EXPECTED) begin
            $display("ERROR!! Incorrect Output :(");
            $stop;
        end
    end
 //--------------------------------------------------------mux 0--------------------------------------------
    $display("\n-------------------------------------------> Testing Placing all zeros <-------------------------------------------\n");

    OPMODE[7:0] = 8'b 0_0_0_0_00_00;
    repeat (10) begin

        D = $random;
        B = $random;
        A = $random;
        C = $random;

        EXPECTED = 0;
        repeat (2) @(negedge clk);

        if (P != EXPECTED) begin
            $display("ERROR!! Incorrect Output :(");
            $stop;
        end
    end
//--------------------------------------------------------conc & pcin--------------------------------------------
    $display("\n-------------------------------------------> Testing Concatenation & PCIN <-------------------------------------------\n");

    OPMODE[7:0] = 8'b 0_0_0_0_01_11;
    repeat (100) begin
        PCIN = $random;
        D = $random;
        B = $random;
        A = $random;
        C = $random;

        EXPECTED = PCIN + {D[11:0] , A , B};
        repeat (4) @(negedge clk);

        if (P != EXPECTED) begin
            $display("ERROR!! Incorrect Output :(");
            $stop;
        end
    end

    //If the simulation reached this line then no errors were found
    $display("\n--->  NO ERRORS, All Outputs are Correct :)  <---\n");
    $stop;
end

    initial begin
        $monitor("CLK= %b ,D= %d ,B= %d ,A= %d ,C= %d ,OPMODE= %b_%b_%b ,BCOUT= %d ,M= %d ,CARRYOUT= %b ,P= %d ,EXPECTED = %d",
                clk , D, B, A, C, OPMODE[7:6], OPMODE[5], OPMODE[4:0], BCOUT, M, CARRYOUT, P, EXPECTED);
    end

    endmodule

