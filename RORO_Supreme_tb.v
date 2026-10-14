`timescale 1ns/1ps
module RORO_Supreme_tb;
reg  [3:0]  DirInst;
wire [31:0] DD;
wire        ZF;

RORO_Supreme uut(
	.DirInst(DirInst),
	.DD(DD),
	.ZF(ZF)
);

reg [31:0] dd_e [0:15];
integer i, pass, fail;
reg zf_esperado;

initial
begin
	dd_e[0]=17;  dd_e[1]=21;  dd_e[2]=35;  dd_e[3]=12;
	dd_e[4]=60;  dd_e[5]=48;  dd_e[6]=0;   dd_e[7]=9;
	dd_e[8]=51;  dd_e[9]=32'hFFFFFFD7;     // 9 - 50 en complemento a dos = 4294967255
	dd_e[10]=97; dd_e[11]=0;
	dd_e[12]=0;  dd_e[13]=0;  dd_e[14]=1;  dd_e[15]=0;

	$dumpfile("RORO_Supreme.vcd");
	$dumpvars(0, RORO_Supreme_tb);

	pass = 0; fail = 0;
	$display("=== RORO_Supreme_tb: 16 instrucciones ===");
	for (i = 0; i < 16; i = i + 1)
	begin
		DirInst = i[3:0];
		#10;
		zf_esperado = (dd_e[i] == 0);
		if (DD === dd_e[i] && ZF === zf_esperado)
		begin
			pass = pass + 1;
			$display("Inst %2d | DD=%0d | ZF=%b | PASS", i, DD, ZF);
		end
		else
		begin
			fail = fail + 1;
			$display("Inst %2d | DD=%0d (esp %0d) | ZF=%b (esp %b) | FAIL",
			         i, DD, dd_e[i], ZF, zf_esperado);
		end
	end
	$display("=== Resumen RORO_Supreme_tb: %0d PASS, %0d FAIL ===", pass, fail);
	$finish;
end

endmodule
