#include <stdio.h>
#include <unistd.h>
#include <gfx.h>

#define background_color gfx_black
#define paddle_color gfx_orange
#define ball_color gfx_turquoise

#define paddle_height 40
#define paddle_width 10

#define paddle_movement 2
#define ai_movement 1

#define ball_size 8

#define start_timeout 100
#define score_timeout 100

#define speedup_time 2200

struct player {
	int16_t paddle_pos;
	uint8_t score;
	int16_t x_pos;
};

struct ball {
	int16_t x_pos;
	int16_t y_pos;

	int16_t x_vel;
	int16_t y_vel;

	/* out of every 4 frames, how many to update pos on */
	int8_t update_freq;

	int16_t timeout;
};

struct player player1 = {.paddle_pos = 80, .x_pos=10, .score=0};
struct player player2 = {.paddle_pos = 80, .x_pos=300, .score=0};

struct ball ball = {.x_pos = 156, .y_pos=96, .x_vel=1, .y_vel=1, .timeout=start_timeout, .update_freq = 2};

void draw_player(struct player * player) {
	/* clear area where paddle might have been last frame */
	gfx_rect(player->x_pos, player->paddle_pos-paddle_movement, paddle_width, paddle_movement, background_color);
	gfx_rect(player->x_pos, player->paddle_pos + paddle_height, paddle_width, paddle_movement, background_color);
	/* actually draw paddle */
	gfx_rect(player->x_pos, player->paddle_pos, paddle_width, paddle_height, paddle_color);
	/* draw score */
	if(player->x_pos < 160) {
		gfx_put_char(1,0,'0' + player->score);
	} else {
		gfx_put_char(78,0,'0' + player->score);
	}
}

void draw_ball(struct ball * ball) {
	/* clear area */
	gfx_rect(ball->x_pos - 4, ball->y_pos -4, ball_size + 8, 4, background_color);
	gfx_rect(ball->x_pos - 4, ball->y_pos + ball_size, ball_size + 8, 4, background_color);

	gfx_rect(ball->x_pos - 4, ball->y_pos, 4, ball_size, background_color);
	gfx_rect(ball->x_pos +ball_size, ball->y_pos, 4, ball_size, background_color);
	/* draw */
	gfx_rect(ball->x_pos, ball->y_pos, ball_size, ball_size, ball_color);
}

void reset_ball(struct ball * ball) {

	gfx_rect_safe(ball->x_pos - ball_size, ball->y_pos - ball_size, ball_size *3, ball_size * 3, background_color);

	ball->x_pos = 156;
	ball->y_pos = 96;
	ball->x_vel = 1;
	ball->y_vel = 1;
	ball->update_freq = 2;
	ball->timeout = score_timeout;
}

int8_t freq_count = 0;
void update_ball(struct ball * ball, struct player * p1, struct player * p2) {
	if(ball->timeout) {
		ball->timeout--;
		return;
	}
	if(ball->update_freq > freq_count){
		ball->x_pos += ball->x_vel;
		ball->y_pos += ball->y_vel;
	}

	if(ball->y_pos <= 0 || ball->y_pos >= 200-ball_size){
		ball->y_vel = -ball->y_vel;
		if(ball->y_pos <= 0) ball->y_pos = 0;
		else ball->y_pos = 200-ball_size;
	}

	/* check paddle bounce */
	if(ball->x_pos <= p1->x_pos + paddle_width && ball->x_pos > 10 && ball->y_pos >= p1->paddle_pos - ball_size && ball->y_pos <= p1->paddle_pos + paddle_height) {
		ball->x_vel = -ball->x_vel;
		ball->x_pos = p1->x_pos +paddle_width + 1;
	}
	if(ball->x_pos+ball_size >= p2->x_pos && ball->x_pos < 310-ball_size && ball->y_pos >= p2->paddle_pos - ball_size && ball->y_pos <= p2->paddle_pos + paddle_height) {
		ball->x_vel = -ball->x_vel;
		ball->x_pos = p2->x_pos -ball_size -1;
	}

	/* check if ball scored */
	if(ball->x_pos <= 0) {
		reset_ball(ball);
		p2->score++;
	}
	if(ball->x_pos >= 320-ball_size) {
		reset_ball(ball);
		p1->score++;
	}

}

void limit_player_bounds(struct player * player) {
	if(player->paddle_pos < 0) player->paddle_pos = 0;
	if(player->paddle_pos >= (200-paddle_height)) player->paddle_pos = 200-paddle_height;
}

uint16_t speedup_wait = speedup_time;
uint8_t main_loop() {
	if(player1.score >= 5) {
		gfx_exit();
		printf("pong: The computer beat you\n");
		return 1;
	} else if (player2.score >= 5) {
		gfx_exit();
		printf("pong: You beat the computer\n");
		return 1;
	}
	if(gfx_is_key_pressed(gfx_key_esc)) {
		gfx_exit();
		return 1;
	}
	if(speedup_wait) {
		speedup_wait--;
	} else {
		speedup_wait = speedup_time;
		ball.update_freq++;
	}
	draw_ball(&ball);
	draw_player(&player1);
	draw_player(&player2);

	if(freq_count == 0 || freq_count == 2) {
		if(gfx_is_key_pressed(gfx_key_up)) player2.paddle_pos -= paddle_movement;
		if(gfx_is_key_pressed(gfx_key_down)) player2.paddle_pos += paddle_movement;

		if(player1.paddle_pos + (paddle_height/2) > ball.y_pos + (ball_size*2)) player1.paddle_pos -= ai_movement;
		else if(player1.paddle_pos + (paddle_height/2) < ball.y_pos - (ball_size)) player1.paddle_pos += ai_movement; 
	}

	update_ball(&ball, &player1, &player2);
	limit_player_bounds(&player1);
	limit_player_bounds(&player2);

	gfx_throttle(0);

	freq_count++;
	if(freq_count >= 4) freq_count = 0;

	return 0;
}

void intro() {
	draw_ball(&ball);
	draw_player(&player1);
	draw_player(&player2);

	gfx_put_string(24, 10, "\
	----------- SCP PONG -----------\n\n\
	<- AI                  PLAYER ->\n\n\
	Controls: Up and down arrow keys\n\
	Scores are at top. 1st to 5 wins\n\
	      Press Enter to start      \n");
	while(!gfx_is_key_pressed(gfx_key_enter)) { yield(); }
	gfx_clear_text();
}

int main(int argc, char **argv) {
	printf("SCP Pong\n");
	gfx_init();
	gfx_set_input_mode(TRACK_PRESS);
	gfx_background(background_color);
	intro();
	while(!main_loop());
}