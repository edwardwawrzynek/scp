void set(int *a){
    *a = 19;
}

int main(){
    int a = 5;
    set(&a);
    return a;
}