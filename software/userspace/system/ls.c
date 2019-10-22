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

void print_usage() {
    fprintf(stderr, "usage: ls [options] [directory]\noptions:\n");
    fprintf(stderr, "-l\tlong form\n-a\tshow hidden files\n-A\tshow hidden, ignore . and ..\n-f\tdon't sort\n-F\tshow file type indicator\n-R\trecursive\n-s\tshow sizes\n-i\tshow inodes\n-h\tprint help\n");
    exit(1);
}

/* flags passed on command line */
uint8_t l_flag, a_flag, A_flag, f_flag, F_flag, R_flag, s_flag, i_flag;

uint8_t did_error = 1;

/* sort files */
int filesort(const void *p1, const void *p2)
{
	return strcmp(* (char **)p1, *(char **)p2);
}

void list_dir(char *dir, uint8_t display_name);

/* print a file given a path (returns true if file is dir) */
int print_file(char *file){
    struct stat sentry;
    if(stat(file, &sentry) == -1){
        fprintf(stderr, "ls: can't stat file: %s:", file);
        perror(NULL);
        did_error = 1;
        return 0;
    }
    if(i_flag){
        printf("%u\t", sentry.st_ino);
    }
    if(l_flag){
        char mode[3];
        strcpy(mode, "---");
        if(S_ISDEV(sentry.st_mode)){
            mode[0] = 'c';
        } else if(S_ISFIFO(sentry.st_mode)){
            mode[0] = 'p';
        } else if(S_ISDIR(sentry.st_mode)){
            mode[0] = 'd';
        }
        if(S_ISEXEC(sentry.st_mode)){
            mode[1] = 'x';
        }
        printf("%s ", mode);
    }
    if(s_flag){
        printf("%u Kb\t", (sentry.st_size/1024) + 1);
    }
    printf("%s", file);
    if(f_flag){
        if(S_ISDEV(sentry.st_mode)){
            printf("#");
        } else if(S_ISFIFO(sentry.st_mode)){
            printf("|");
        } else if(S_ISDIR(sentry.st_mode)){
            printf("/");
        } else if(S_ISEXEC(sentry.st_mode)){
            printf("*");
        }
    }
    if(l_flag){
        printf("\n");
    } else {
        printf("\t");
    }
    return S_ISDIR(sentry.st_mode);
}

/* list a subdir given a path to the directory */
void list_dir(char *dir, uint8_t display_name){
    /* save old dir so we can cd back to it */
    int old_dir_fd = open(".", O_RDONLY);

    if(chdir(dir)==-1){
        fprintf(stderr, "ls: can't chdir to %s: ", dir);
        perror(NULL);
        did_error = 1;
        return;
    }
    uint16_t dir_fd = opendir(".");
    struct dirent entry;

    if(dir_fd == -1){
        fprintf(stderr, "ls: error: can't open directory %s:", dir);
        perror(NULL);
        did_error = 1;
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
        /* mark files that aren't dirs */
        if(!print_file(files[i])){
            files[i][0] = '\0';
        }
    }
    if(!l_flag){
        printf("\n");
    }
    if(R_flag){
        /* print subdirs */
        for(i = 0; i < entries; i++){
            if(files[i][0] == '\0'){
                continue;
            }
            /* don't display hidden files */
            if(files[i][0] == '.'){
                if((!strcmp(files[i], ".")) || (!strcmp(files[i], ".."))){
                    continue;
                }                    
                if(!a_flag && !A_flag){
                    continue;
                }
            }
            /* mark files that aren't dirs */
            list_dir(files[i], 1);
        }
    }
    fchdir(old_dir_fd);
    close(old_dir_fd);
}

int main(int argc, char **argv){
    int i;
    while((i = getopt(argc, argv, "laAfFRsih")) != -1){
        switch(i){
            case 'l':
                l_flag = 1;
                s_flag = 1;
                f_flag = 1;
                break;
            case 's':
                s_flag = 1;
                break;
            case 'a':
                a_flag = 1;
                break;
            case 'A':
                A_flag = 1;
                break;
            case 'f':
                f_flag = 1;
                break;
            case 'F':
                F_flag = 1;
                break;
            case 'R':
                R_flag = 1;
                break;
            case 'i':
                i_flag = 1;
                break;
            case 'h':
            default:
                print_usage();
                break;
        }
    }

    /* whether to list the names of the subdir before the command */
    uint8_t display_name = (optind < argc-1) || R_flag;

    if(optind >= argc){
        list_dir(".", 0);
    }

    for(;optind<argc;optind++){
        list_dir(argv[optind], display_name);
    }

    return did_error;
}

