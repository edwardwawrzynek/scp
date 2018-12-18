
int xxseed;
int xxseed2;

srand (x) int x; {
        xxseed = x;
				xxseed2 = x^0xd13a;
}

rand () {
        xxseed = (((((xxseed * 5 + 123) ^ 0xfa3c) * 0x54a7) >> 2)) + xxseed2^0xa3b2;
				xxseed2 = ((xxseed2*87 + 54) << 2) ^ 0x23a1 * ((xxseed ^ 0x3451) & 0x4f32);
        return abs(xxseed);

}

