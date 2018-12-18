
gfx_pixel(unsigned int x, unsigned int y, unsigned char c){
	outp(9, x+y*320);
	outp(10, c);
}

gfx_rgb(unsigned char r, unsigned char g, unsigned char b){
	return (r>>5<<5) + (g>>5<<2) + (b>>6);
}

gfx_sync(){
	while(inp(12)){};
}

gfx_background(unsigned char c){
	unsigned int i;
	i = 0;
	do{
		outp(9, i++);
		outp(10, c);
	} while(i);
}

gfx_clearscreen(){
	gfx_background(0);
}

gfx_text(char *txt, unsigned int x, unsigned int y){
	unsigned int initX;
	initX = x;
	while(*txt){
		if(*txt == 10){
			++y;
			x = initX;
			++txt;
		}
		else{
			outp(5, (x++)+(y*80));
			outp(6, *(txt++));
		}
	}
}

gfx_blit_buffer(unsigned char * buf, unsigned int x, unsigned int y, unsigned int w, unsigned int h){
	unsigned int pos;
	unsigned int lx;
	unsigned int ly;

	//set as limits
	lx = x + w;
	ly = y + h;

	pos = y*320 + x;
	while(1){
		x++;
		pos++;
		if(x >= lx){
			x -= w;
			y++;
			pos += 320-w;
			if(y >= ly){
				return;
			}
		}

		outp(9, pos);
		outp(10, *(buf++));
	}

}

gfx_horiz_line(unsigned int x, unsigned int y, unsigned int len, unsigned char c){
	unsigned int end;
	end = x+len;
	while(x < end){
		outp(9, (x++)+(y*320));
		outp(10, c);
	}
}

gfx_vert_line(unsigned int x, unsigned int y, unsigned int len, unsigned char c){
	unsigned int end;
	end = y+len;
	while(y < end){
		outp(9, x+((y++)*320));
		outp(10, c);
	}
}

gfx_rect_fill(unsigned int x, unsigned int y, unsigned int w, unsigned int h, unsigned char c){
	unsigned int xend, yend;
	xend = x + w;
	yend = y + h;
	while(1){
		if(x >= xend){
			x-=w;
			++y;
			if(y >= yend){break;}
		}
		outp(9, (x++)+(y*320));
		outp(10, c);
	}
}

gfx_rect_stroke(unsigned int x, unsigned int y, unsigned int w, unsigned int h, unsigned char c){
	gfx_horiz_line(x, y, w, c);
	gfx_vert_line(x, y, h, c);

	gfx_horiz_line(x, y+h-1, w, c);
	gfx_vert_line(x+w-1, y, h, c);
}

gfx_line(unsigned int x0, unsigned int y0, unsigned int x1, unsigned int y1, unsigned char c){
	int dx, dy;
	dx = x1 - x0;
	if(dx < 0){
		gfx_line(x1, y1, x0, y0, c);
	}
  dy = y1 - y0;
	if(_abs(dx) > _abs(dy)){
		_gfx_line(x0, y0, x1, y1, c, 0);
	}
	else{
		if(dy > 0){
			_gfx_line(y0, x0, y1, x1, c, 1);
		}
		else{
			_gfx_line(y1, x1, y0, x0, c, 1);
		}
	}
}

_gfx_line (unsigned int x0, unsigned int y0, unsigned int x1, unsigned int y1, unsigned char c, unsigned char reverse){
  int dy, dx, incrE, incrNE, incrY, d,x,y;
	incrY = 1;
  dx = x1 - x0;
  dy = y1 - y0;
	if(dy < 0){
		incrY = -1;
		dy = y0 - y1;
	}
  d = 2 * dy - dx;
  incrE = 2*dy;
  incrNE = 2*(dy - dx);
  x = x0;
  y = y0;
	if(reverse){
  	gfx_pixel(y, x, c);
	}
	else{
		gfx_pixel(x, y, c);
	}
  while(x < x1){
      if (d <= 0){
	  		d += incrE;
	  		++x;
			}
      else{
	  		d += incrNE;
	  		++x;
	  		y += incrY;
			}
  	if(reverse){
  		gfx_pixel(y, x, c);
		}
		else{
			gfx_pixel(x, y, c);
		}
  }
}

gfx_triangle_stroke(unsigned int x0, unsigned int y0, unsigned int x1, unsigned int y1, unsigned int x2, unsigned int y2, unsigned char c){
	gfx_line(x0, y0, x1, y1, c);
	gfx_line(x0, y0, x2, y2, c);
	gfx_line(x1, y1, x2, y2, c);
}

_abs(int num){
        if (num < 0) return (-num);
        else         return (num);
        }
