# RTL files

module priority_encoder_8bit(
input wire [7:0] in,
output reg V,
output reg [2:0] out
    );
    
always @(*)
begin
V= 1'b1;
casez(in)

8'b1???????: out = 3'b111;   // bit7
8'b01??????: out = 3'b110;   // bit6
 8'b001?????: out = 3'b101;   // bit5
 8'b0001????: out = 3'b100;   // bit4
 8'b00001???: out = 3'b011;   // bit3
 8'b000001??: out = 3'b010;   // bit2
 8'b0000001?: out = 3'b001;   // bit1
 8'b00000001: out = 3'b000;   // bit0

default : begin
out = 3'b000; V = 1'b0;
end
endcase
end
endmodule
