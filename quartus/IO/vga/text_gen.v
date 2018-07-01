//Text generation
module text_gen(
	input [31:0] row,
	input [31:0] colu,
	input col_en,
	output [7:0] col,
	//Text Memory Access
	output [9:0] char_addr,
	//Video memory access
	output [15:0] gfx_addr,
	//Charset rom access
	input [63:0] charset,
	//gfx pixel in
	input [7:0] gfx_in,
	//char being drawn
	input [7:0] char,
	//if the screen is being drawn
	output screen_en
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
assign gfx_addr = (x + (y*320));

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

//Real pixel that combines gfx and text
wire [7:0] real_pixel;
assign real_pixel = char ? {pixel, pixel, pixel, pixel, pixel, pixel, pixel, pixel}: gfx_in;

//assign col = col_en ? {real_pixel, real_pixel, real_pixel, real_pixel, real_pixel, real_pixel, real_pixel, real_pixel} : 0;
assign col = col_en ? ((y >= 200) ? 0: real_pixel) : 0;

assign screen_en = (y>=200) ? 0 : 1;

endmodule
