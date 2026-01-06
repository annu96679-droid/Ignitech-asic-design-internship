`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2026 15:00:34
// Design Name: 
// Module Name: pri_enc_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pri_enc_tb();
reg [7:0] in;
wire V;
wire [2:0] out;

priority_encoder_8bit PE(.in(in), .V(V), .out(out));

initial 
begin
      $monitor ("$time = %0t | in = %b | V = %b | out = %b",$time, in, V, out);
      
      in = 8'b01; #5;
      in = 8'b00001011; #5;
      in = 8'b01001111; #5;
      in = 8'b00100000; #5;
      in = 8'b00000000; #5;
      in = 8'b00000001; #5;
      $finish;
end
      
    
endmodule
