module ROM_Instrucciones #(
	parameter FILE = "instrucciones.txt"
)(
	input [3:0] Dir,
	output [11:0] Instruccion
);

reg [11:0] mem_inst [0:15];

assign Instruccion = mem_inst[Dir];

initial begin
	$readmemb(FILE, mem_inst);
end

endmodule