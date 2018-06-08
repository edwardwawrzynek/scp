//Text generation
module text_gen(
	input [31:0] row,
	input [31:0] colu,
	input col_en,
	output [7:0] col,
	//Text Memory Access
	output [9:0] char_addr,
	//Charset rom access
	input [63:0] charset
);

//Pixel locations
wire [30:0] x;
wire [30:0] y;
assign x = row[31:1] - 1;
assign y = colu[31:1];
//Text locations
wire [5:0] textX;
wire [4:0] textY;
assign textX = x[8:3];
assign textY = y[7:3];

assign char_addr = (textX + (textY*40));

//Location in char
wire [2:0] charX;
wire [2:0] charY;
assign charX = x[2:0];
assign charY = y[2:0];

//Bit in charset
wire [5:0] charset_addr;
assign charset_addr = {charY,charX}; 

//Current pixel from charset
wire pixel;
assign pixel = charset[63 - charset_addr];

//Real pixel that cuts out bottom 80 pixels to get 640 x 400
wire real_pixel;
assign real_pixel = (y >= 200) ? 0 : pixel;

assign col = col_en ? {real_pixel, real_pixel, real_pixel, real_pixel, real_pixel, real_pixel, real_pixel, real_pixel} : 0;

endmodule
