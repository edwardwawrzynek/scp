void put_char(__reg("ra") int x, __reg("rb") int y, __reg("rc") char c);

int do_char(int pos, int c) {
  put_char(pos, 0, c);
  if(pos < 79) {
    do_char(++pos, c);
  }
}

int main() {
  int (*func)(int, int) = &do_char;
  return (*func)(0, 'A');
}