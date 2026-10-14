`timescale 1ns/1ps
module RORO_tb;

reg  [11:0] instruccion;
wire [31:0] resultado;
wire        ZF;

RORO uut(
	.instruccion(instruccion),
	.resultado(resultado),
	.ZF(ZF)
);

reg [3:0]  op_e  [0:15];
reg [31:0] dd_e  [0:15];
integer i, pass, fail;
reg [31:0] esperado;
reg        zf_esperado;

initial
begin
	// OP: 2 = suma, 6 = resta, 7 = SLT
	op_e[0]=2; dd_e[0]=17;          op_e[1]=2; dd_e[1]=21;
	op_e[2]=2; dd_e[2]=35;          op_e[3]=2; dd_e[3]=12;
	op_e[4]=2; dd_e[4]=60;          op_e[5]=2; dd_e[5]=48;
	op_e[6]=6; dd_e[6]=0;           op_e[7]=6; dd_e[7]=9;
	op_e[8]=6; dd_e[8]=51;          op_e[9]=6; dd_e[9]=32'hFFFFFFD7; // 4294967255
	op_e[10]=6; dd_e[10]=97;        op_e[11]=6; dd_e[11]=0;
	op_e[12]=7; dd_e[12]=0;         op_e[13]=7; dd_e[13]=0;
	op_e[14]=7; dd_e[14]=1;         op_e[15]=7; dd_e[15]=0;

	pass = 0; fail = 0;
	$display("=== RORO_tb: 2 ROM + MIPSALU ===");
	for (i = 0; i < 16; i = i + 1)
	begin
		instruccion = {op_e[i], i[3:0], i[3:0]};   // R1 = R2 = i
		#10;
		esperado    = dd_e[i];
		zf_esperado = (dd_e[i] == 0);
		if (resultado === esperado && ZF === zf_esperado)
		begin
			pass = pass + 1;
			$display("Caso %2d | instr=%b | DD=%0d ZF=%b | PASS", i, instruccion, resultado, ZF);
		end
		else
		begin
			fail = fail + 1;
			$display("Caso %2d | instr=%b | DD=%0d (esp %0d) ZF=%b (esp %b) | FAIL",
			         i, instruccion, resultado, esperado, ZF, zf_esperado);
		end
	end
	$display("=== Resumen RORO_tb: %0d PASS, %0d FAIL ===", pass, fail);
	$finish;
end

endmodule
