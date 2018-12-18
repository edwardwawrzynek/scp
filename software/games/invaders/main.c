#include <stdio.h>
#include <stdlib.h>

/*Uncomment to include sound*/
//#define SOUND 0


#define SCORE_LOST_SPEED 15

#define ENEMY_MOVE_RATE 16
int enemyDir = 0;

//position of player across the bottom
#define INIT_POS 20
unsigned int player_pos = INIT_POS;
//Player shooting state
unsigned char player_shooting = 0;
int player_shotX = 0;
int player_shotY = 23;
#define SHOT_SPEED 3

int player_life = 4;
int player_score = 0;
int player_hit_time = 0;
#define HIT_TIME 30

//Game state - 0:menu, 1:game, 2:end-win, 3:end-lost
unsigned char mode = 0;

//Enemy
#define ENEMY_ROWS 10
#define ENEMY_COLS 5
#define ENEMIES 50
int enemyX = 0;
int enemyY = 0;
char enemy[ENEMIES];

//enemy shooting (bombing) state
int enemy_shotX = 21;
int enemy_shotY = 0;
#define ENEMY_SHOT_SPEED 4
//key states
unsigned char leftP = 0;
unsigned char rightP = 0;

//framecount
unsigned int framecount = 0;
//number of frames to let sound run
unsigned int sound_frames = 0;


char screen_buf [2000];
unsigned int buf_pos;
//blitting
bufputchar(unsigned char i){
	screen_buf[buf_pos++] = i;
	if(buf_pos >= 2000){
		buf_pos = 0;
	}
}

bufblit(){
	unsigned int i;
	i = 0;
	while(i < 1920){
		outp(5,i);
		outp(6,screen_buf[i++]);
	}
	buf_pos = 0;
}

reset(){
	unsigned int i;
	_screenclear();
	enemyDir = 1;
	player_pos = INIT_POS;
	player_shooting = 0;
	player_shotX = 0;
	player_shotY = 23;
	player_life = 4;
	player_score = 0;
	player_hit_time = 0;
	mode = 0;
	enemyX = 0;
	enemyY = 0;
	for(i = 0; i < ENEMIES; i++){
		enemy[i] = 0;
	}
	enemy_shotX = 21;
	enemy_shotY = 0;
	leftP = 0;
	rightP = 0;
	framecount = 0;
	buf_pos = 0;
}

drawScreen(){
	unsigned int x;
	unsigned int y;
	unsigned int posInEnemy;
	unsigned int enemyIndex;
	//Draw top of the screen, including the enemies
	for(y = 0; y < 23; ++y){
		for(x = 0; x < 40; ++x){
			if(x >= enemyX && x < enemyX + (ENEMY_ROWS*3) && y >= enemyY && y < enemyY + (ENEMY_COLS*2) && (!((y-enemyY)&1))){
				enemyIndex = (x-enemyX)/3;
				enemyIndex += ((y-enemyY)>>1)*ENEMY_ROWS;
				posInEnemy = (x-enemyX) % 3;
				if(!enemy[enemyIndex]){
					if(posInEnemy == 0){
						bufputchar(framecount & 8 ? '/' : '(');
					}
					if(posInEnemy == 1){
						bufputchar('o');
					}
					if(posInEnemy == 2){
						bufputchar(framecount & 8 ? '\\' : ')');
					}
				}
				else{
					bufputchar(player_shooting && x == player_shotX && y == player_shotY ? '!' : (x == enemy_shotX && y == enemy_shotY ? ':' : ' '));
				}
			}
			else{
				bufputchar(player_shooting && x == player_shotX && y == player_shotY ? '!' : ((x == enemy_shotX && y == enemy_shotY) ? ':' : ' '));
			}	
		}
		buf_pos += 40;
	}
	//Draw line with player
	for(x = 0; x < 40; x++){
		if(x == player_pos-1){bufputchar(player_hit_time ? '#' : '/');}
		else if(x == player_pos){bufputchar(player_hit_time ? '#' : '^');}
		else if(x == player_pos +1){bufputchar(player_hit_time ? '#' : '\\');}
		else{bufputchar(' ');}
	}
	if(player_hit_time){
		--player_hit_time;
	}
	bufblit();
}

drawBottomLine(){
	_screenpos = 1920;
	printf("Score: %i ", player_score);
	_screenpos = 1953;
	printf("Life: %i", player_life >= 0 ? player_life : 0);
}

updateKeys(){
	unsigned int key;
	key = _key_async_read();
	if(key == KEY_RIGHT){
		rightP = 1;
	}
	else if(key == KEY_LEFT){
		leftP = 1;
	}
	else if(key == 0x100 + KEY_RIGHT){
		rightP = 0;
	}
	else if(key == 0x100 + KEY_LEFT){
		leftP = 0;
	}
	else if(key == ' ' && !player_shooting){
		player_shooting = 1;
		player_shotX = player_pos;
#ifdef SOUND
		outp(11, 1300);
#endif
		sound_frames = 2;
	}			
}

updatePlayer(){
	if(player_hit_time){return 0;}
	if(leftP && player_pos){--player_pos;}
	if(rightP && player_pos < 39){++player_pos;}
}

moveEnemies(){
	if(!(framecount % ENEMY_MOVE_RATE)){
		enemyX += enemyDir;
		if(enemyX+ENEMY_ROWS*3 >= 40 || enemyX <= 0){
			enemyDir = -enemyDir;
			++enemyY;
		}
	checkLoss();
	}
}

moveShot(){
	if(player_shooting && !(framecount % SHOT_SPEED)){
		--player_shotY;
		if(player_shotY < 0){
			player_shooting = 0;
			player_shotY = 23;
#ifdef SOUND
			outp(11, 6000);
#endif
			sound_frames = 14;
		}
	}
}

//checks if the shot has hit an enemy
updateShotCollide(){
	unsigned int enemyIndex;
	if(!(framecount % SHOT_SPEED)){
		if(player_shotX >= enemyX && player_shotX < enemyX + (ENEMY_ROWS*3) && player_shotY >= enemyY && player_shotY < enemyY + (ENEMY_COLS*2) && (!((player_shotY-enemyY)&1))){
				enemyIndex = (player_shotX-enemyX)/3;
				enemyIndex += ((player_shotY-enemyY)>>1)*ENEMY_ROWS;
				if(!enemy[enemyIndex]){
					enemy[enemyIndex] = 1;
					player_shooting = 0;
					player_shotY = 23;
					player_score += 10;
#ifdef SOUND
					outp(11, 5000);
#endif
					sound_frames = 7;
					checkWin();
					drawBottomLine();
				}
		}
	}
}

updateEnemyShot(){
	unsigned int dropPos;
	if(!(framecount % ENEMY_SHOT_SPEED)){
		++enemy_shotY;
		//check for collision
		if(enemy_shotY == 23){
			if(enemy_shotX >= player_pos-1 && enemy_shotX <= player_pos+1){
				--player_life;
				//player_hit = 1;
				player_hit_time = HIT_TIME;
				drawBottomLine();
			}
			dropPos = rand()%ENEMY_ROWS;
			enemy_shotX = enemyX + (dropPos*3);
			while(!enemy[dropPos] && dropPos < ENEMIES - ENEMY_ROWS){
				dropPos += ENEMY_ROWS;
			}
			if(dropPos < ENEMY_ROWS){
				enemy_shotX = -1;
			}
			else{
#ifdef SOUND
				outp(11, 4500);
#endif
				sound_frames = 2;
			}
			enemy_shotY = enemyY + (dropPos/ENEMY_ROWS)*2;
		}
	}
}

checkWin(){
	unsigned int i;
	for(i = 0; i < ENEMIES; i++){
		if(!enemy[i]){
			return 0;
		}
	}
	mode = 2;
	return 1;
}

checkLoss(){
	unsigned int i;
	unsigned int y;
	y = 0;
	if(player_life <= 0){
		mode = 3;
		return 1;
	}
	for(i = 0; i < ENEMIES; i++){
		if(!enemy[i] && y+enemyY >= 23){
			mode = 3;
			return 1;
		}
		if(i%ENEMY_ROWS==ENEMY_ROWS-1){
			y+=2;
		}
	}
	return 0;
}

main(){
	reset();
	while(1){
	if(mode == 0){
		outp(11, 0);
		drawScreen();
		drawBottomLine();
		_print_at("SCP Invaders", 973);
		_print_at("Press a key to begin", 1130);
		_key_press_read();
		reset();
		mode = 1;
	}
	if(mode == 1){
		drawScreen();
		updateKeys();
		updatePlayer();
		moveEnemies();
		moveShot();
		updateShotCollide();
		updateEnemyShot();
		if(sound_frames){
			--sound_frames;
		}
		else{
			outp(11, 0);
		}
		++framecount;
		if(!(framecount % SCORE_LOST_SPEED)){
			--player_score;
			drawBottomLine();
		}
	}
	if(mode == 2){
		outp(11, 0);
		_screenpos = 960;
		printf("\n\nYou Won! Score: %i\nPress a key to play again.\n", player_score);
		_key_press_read();
		reset();
		mode = 0;
	}
	if(mode == 3){
		outp(11, 0);
		_screenpos = 960;
		printf("\n\nYou Lost! Score: %i\nPress a key to play again.\n", player_score);
		_key_press_read();
		reset();
		mode = 0;
	}
	}
}
