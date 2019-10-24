/* This file was automatically generated.  Do not edit! */
int main(int argc,char *argv[]);
extern FILE *file;
void handle_bin_obj(FILE *file,char *name);
void handle_ar_obj(struct obj_file *obj_file,char *name);
extern struct obj_file obj;
void do_obj(struct obj_file *obj,char *name);
extern uint32_t files;
extern uint32_t sum;
extern uint32_t seg_sum[4];
void usage();
