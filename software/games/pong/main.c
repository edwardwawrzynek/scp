#include <stdio.h>

#define PAD_HIGH 5

#define START_DELAY 75

#define SPEED_TIME 350

#define INIT_BALL_X 20
#define INIT_BALL_Y 12

#define INIT_BALL_SPEED 15

char pad1 = 15;
char pad2 = 20;

unsigned char ballX = INIT_BALL_X;
unsigned char ballY = INIT_BALL_Y;
char ballDX = 1;
char ballDY = 1;

unsigned char score1 = 0;
unsigned char score2 = 0;

char screen_buf [1000];
unsigned int buf_pos = 0;


unsigned int frameCount = 0;
unsigned int padSpeed = 8;
unsigned int ballSpeed = INIT_BALL_SPEED;

//Key states
unsigned char upP = 0;
unsigned char downP = 0;
unsigned char wP = 0;
unsigned char sP = 0;

//Winner
unsigned int winner = 0;
int winThresh = 5;

unsigned char mode = 0;

//resetting game state
reset(){
	ballSpeed = INIT_BALL_SPEED;
	ballX = INIT_BALL_X;
	ballY = INIT_BALL_Y;
	ballDX = 1;
	ballDY = 1;

	score1 = 0;
	score2 = 0;
	frameCount = 0;
}

//blitting
bufputchar(unsigned char i){
	screen_buf[buf_pos++] = i;
	if(buf_pos >= 1000){
		buf_pos = 0;
	}
}

bufblit(){
	unsigned int i;
	i = 0;
	while(i < 1000){
		outp(5,i);
		outp(6,screen_buf[i++]);
	}
}

drawScreen(){
	unsigned char y;
	unsigned char x;
	for(y = 0; y < 25; ++y){
		//Blank Line (with score)
		bufputchar(y == 0 ? score1+48 : ' ');
		//Paddle line
		bufputchar((y >= pad1 && y < pad1 + PAD_HIGH) ? 219 : ' ');
		//Blank Middle
		for(x = 0; x < 36; ++x){
			bufputchar((y == ballY && x == ballX - 2) ? 'O' : ' ');
		}
		//Paddle line
		bufputchar((y >= pad2 && y < pad2 + PAD_HIGH) ? 219 : ' ');
		//Blank Line (with score)
		bufputchar(y == 0 ? score2+48 : ' ');
	}
	bufblit();
}

updateKeys(){
	unsigned int key;
	key = _key_async_read();
	if(key == 'w'){
		wP = 1;
	}
	else if(key == 's'){
		sP = 1;
	}
	else if(key == KEY_UP){
		upP = 1;
	}
	else if(key == KEY_DOWN){
		downP = 1;
	}
	else if(key == 0x100 + 'w'){
		wP = 0;
	}
	else if(key == 0x100 + 's'){
		sP = 0;
	}
	else if(key == 0x100 + KEY_UP){
		upP = 0;
	}
	else if(key == 0x100 + KEY_DOWN){
		downP = 0;
	}						
}

updatePads(){
	if(wP){if(pad1){--pad1;}}
	if(sP){++pad1;}
	if(upP){if(pad2){--pad2;}}
	if(downP){++pad2;}
	if(pad1 > 25-PAD_HIGH){pad1 = 25-PAD_HIGH;}
	if(pad2 > 25-PAD_HIGH){pad2 = 25-PAD_HIGH;}						
}

updateBall(){
	ballX += ballDX;
	ballY += ballDY;
	if(ballY == 0 || ballY == 24){
		ballDY = -ballDY;
	}
	//Check paddle collision
	if((ballX == 2 && pad1 <= ballY && pad1+PAD_HIGH >= ballY) || (ballX == 37 && pad2 <= ballY && pad2+PAD_HIGH >= ballY)){
		ballDX = -ballDX;
	}
}

updateScores(){
	if(ballX == 1){
		++score2;
		ballX = INIT_BALL_X;
		ballY = INIT_BALL_Y;
		ballDX = -ballDX;
		frameCount = 0;
		ballSpeed = INIT_BALL_SPEED;
	}
	if(ballX == 38){
		++score1;
		ballX = INIT_BALL_X;
		ballY = INIT_BALL_Y;
		ballDX = -ballDX;
		frameCount = 0;
		ballSpeed = INIT_BALL_SPEED;
	}
}

checkWin(){
	if(score1 >= winThresh){
		mode = 2;
		winner = 0;
	}
	if(score2 >= winThresh){
		mode = 2;
		winner = 1;
	}
}



main(){
	//Modes : 0=menu, 1=game, 2=end
	while(1){
		if(mode == 0){
			printf("\n\n\n\n\n\n\n\n");
			puts("---------------");
			puts("### ### ### ###");
			puts("# # # # # # # #");
			puts("### ### # # ###");
			puts("#             #");
			puts("#           ###");
			puts("---------------");
			puts("Use the W and S");
			puts("keys to control");
			puts("player 0(left),");
			puts("and the up and ");
			puts("down arrows to ");
			puts("control player ");
			puts("1(right). First");
	  printf("to %u wins.\n", winThresh);
			puts("--Press Enter--");
			_key_press_read();
			mode = 1;
		}
		if(mode == 1){
			drawScreen();
			updateKeys();
			if(!(frameCount % padSpeed)){
				updatePads();
			}
			if(!(frameCount % ballSpeed) && frameCount > START_DELAY){
				updateBall();
			}
			updateScores();
			checkWin();
			++frameCount;
			if(frameCount % SPEED_TIME == 0){
				--ballSpeed;
			}
		}
		if(mode == 2){
			printf("\nPlayer %u Won.\n--Press Enter--", winner);
			_key_press_read();
			reset();
			mode = 1;
		}
	}
}

