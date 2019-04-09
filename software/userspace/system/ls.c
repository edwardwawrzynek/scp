#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

/**
 * SCP ls
 * supporting the following flags:
 * l (long form)
 * a (don't hide hidden files)
 * A (-a, but doesn't show . and ..)
 * f (don't sort)
 * F (show indicator after file type (/ for dirs, * for executables, | for fifo, # for devs))
 * R (recursive)
 * s (show file size (in KB))
 * i (list inodes)
 */

/* flags passed on command line */
uint8_t l_flag, a_flag, A_flag, f_flag, F_flag, R_flag, s_flag, i_flag;

/* sort files */
int filesort(void *p1, void *p2)
{
	return strcmp(* (char **)p1, *(char **)p2);
}

/* list a subdir given a path to the directory */
void list_dir(char *dir, uint8_t display_name){
    uint16_t dir_fd = opendir(dir);
    struct dirent entry;

    if(dir_fd == -1){
        fprintf(stderr, "ls: error: can't open directory %s\n", dir);
        return;
    }
    if(display_name){
        printf("\n%s:\n", dir);
    }


    /* count number of entries */
    uint16_t entries = 0;
    while(readdir(dir_fd, &entry) > 0){
        entries++;
    }

    /* copy file names to files */
    lseek(dir_fd, 0, SEEK_SET);
    uint8_t ** files = malloc(entries * sizeof(uint8_t *));
    uint16_t i = 0;
    while(readdir(dir_fd, &entry) > 0){
        files[i] = malloc(strlen(entry.name)+1);
        strcpy(files[i], entry.name);
        i++;
    }
    closedir(dir_fd);

    /* sort */
    if(!f_flag){
        qsort(files, entries, sizeof(uint8_t *), filesort);
    }

    /* print files */
    for(i = 0; i < entries; i++){
        /* don't display hidden files */
        if(files[i][0] == '.'){
            if(A_flag){
                if((!strcmp(files[i], ".")) || (!strcmp(files[i], ".."))){
                    continue;
                }
            } else if(!a_flag){
                continue;
            }
        }

        printf("%s\t", files[i]);
    }

}

int main(int argc, char **argv){
    int i;
    while((i = getopt(argc, argv, "laAfFRs")) != -1){
        switch(i){
            default:
                break;
        }
    }

    /* whether to list the names of the subdir before the command */
    uint8_t display_name = optind < argc-1;

    for(;optind<argc;optind++){
        list_dir(argv[optind], display_name);
    }

}

