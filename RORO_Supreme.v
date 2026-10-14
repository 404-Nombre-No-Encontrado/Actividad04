// RORO Supreme: ROM de instrucciones + RORO (2 ROM + MIPSALU).
// La direccion de instruccion (DirInst) la controla el testbench; no hay PC.
module RORO_Supreme (
	input [3:0]DirInst,
	output [31:0]DD,
	output ZF
);

wire [11:0] instr;

ROM_Instrucciones #(.FILE("instrucciones.txt")) RomInst(
	.Dir(DirInst),
	.Instruccion(instr)
);

RORO #(.FILE_A("ROMa_init.txt"), .FILE_B("ROMina_init.txt")) Nucleo(
	.instruccion(instr),
	.resultado(DD),
	.ZF(ZF)
);

endmodule
