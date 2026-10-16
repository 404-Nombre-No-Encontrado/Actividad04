//1. declaracion de modulo y I/O
module ROM #(
    parameter FILE = "ROMa_init.txt"
)(
    input [3:0] DirL,
    output [31:0] Data
);

reg [31:0] srom [0:15];

assign Data = srom[DirL];

initial begin
    $readmemb(FILE, srom);
end

endmodule
