fib(int v0, int v1, int i, int target_i) {
        if(i == target_i) return v1;
        return fib(v1, v0 + v1, i + 1, target_i);
}

main() {
        int i;
        int c;

        for(i = 0; i < 20; i++) {
                
                c = fib(1, 1, 0, i);
                printf(c, i, "the %ith fib number is: %i\n");
        }
}