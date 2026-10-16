module RORO #(
    parameter FILE_A = "ROMa_init.txt",
    parameter FILE_B = "ROMina_init.txt"
)(
    input [11:0] instruccion,
    output [31:0] resultado,
    output ZF
);

wire [31:0] c1, c2;

ROM #(.FILE(FILE_A)) Roma(
    .DirL(instruccion[7:4]),
    .Data(c1)
);

ROM #(.FILE(FILE_B)) Romina(
    .DirL(instruccion[3:0]),
    .Data(c2)
);

MIPSALU Pablo(
    .ALUctl(instruccion[11:8]),
    .A(c1),
    .B(c2),
    .ALUOut(resultado),
    .Zero(ZF)
);

endmodule
