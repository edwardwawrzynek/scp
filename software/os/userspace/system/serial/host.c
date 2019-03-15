#include "serial.h"
#include <libserialport.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <errno.h>
#include <string.h>

/* Host program to send files and dirs to scp */

struct sp_port * port;

uint16_t transmitted = 0;

uint8_t null_buf[256];

void _write_byte(uint8_t val){
    while(transmitted >= BUF_SIZE){
        int waiting;
        do{
            waiting = sp_input_waiting(port);
            if(waiting < 0){
                printf("error code: %u\n", waiting);
                exit(0);
            }
        } while(waiting < BUF_SIZE);

        transmitted -= waiting;
        sp_blocking_read(port, null_buf, waiting, 0);
    }
    sp_blocking_write(port, &val, 1, 0);
    transmitted++;
}

void _write_word(uint16_t val){
    _write_byte(val&0xff);
    _write_byte(val >> 8);
}

void _write_bytes(uint16_t bytes, uint8_t *buf){
    while(transmitted >= BUF_SIZE){
        int waiting;
        do{
            waiting = sp_input_waiting(port);
            if(waiting < 0){
                printf("error code: %u\n", waiting);
                exit(0);
            }
        } while(waiting < BUF_SIZE);
        transmitted -= waiting;
        sp_blocking_read(port, null_buf, waiting, 0);
    }
    sp_blocking_write(port, buf, bytes, 0);
    transmitted += bytes;
}

void _write_file(struct file * file){
    _write_bytes(FILE_NAME_LEN, file->name);

    _write_word(file->bytes);
    _write_byte(file->is_dir);
    _write_byte(file->is_executable);
    _write_word(file->dev_num);
    _write_word(file->minor_num);
    _write_word(file->parent_dir);

}

/* files */
struct file files[MAX_FILES];
uint16_t num_files;
/* paths for files */
uint8_t paths[MAX_FILES][258];

void write_files(){

    /* send number of files */
    _write_word(num_files);

    /* write headers */
    for(int i = 0; i < num_files; i++){
        _write_file(&files[i]);
    }

    /* write contents */
    for(int i = 0; i < num_files; i++){
        /* don't write size 0 files */
        if(files[i].bytes == 0){
            continue;
        }
        FILE * f = fopen(paths[i], "r");
        if(!f){
            printf("Failure opening file\n");
        }
        /* write file */
        for(uint16_t ind=0;ind<files[i].bytes;ind++){
            uint16_t res = fgetc(f);
            if(res == EOF){
                printf("unexpected eof\n");
            }
            _write_byte(res);
        }
        fclose(f);
    }
}

/* add entry to files */
uint16_t files_add(uint16_t parent, uint8_t *name, uint16_t bytes, uint16_t dev_num, uint16_t dev_minor, uint16_t is_dir, uint16_t is_exec, uint8_t *path) {
    files[num_files].parent_dir = parent;
    files[num_files].bytes = bytes;
    files[num_files].dev_num = dev_num;
    files[num_files].minor_num = dev_minor;
    files[num_files].is_dir = is_dir;
    files[num_files].is_executable = is_exec;
    strcpy(files[num_files].name, name);

    strcpy(paths[num_files], path);
    return num_files++;
}

struct stat finfo;
/* read files in dir into files */
void read_dir(char * path, uint16_t parent_index){
    char path_buf[258];
    struct dirent *entry;
    DIR *d = opendir(path);
    if (d) {
        while ((entry = readdir(d)) != NULL) {
            /* ignore . and .. entries */
            if((!strcmp(entry->d_name, ".")) || (!strcmp(entry->d_name, ".."))){
                continue;
            }
            sprintf(path_buf, "%s/%s", path, entry->d_name);
            if(stat(path_buf, &finfo) < 0){
                printf("%s\n", path_buf);
                printf("error\n%s\n", strerror(errno));
            }

            if(S_ISREG(finfo.st_mode)){
                /* add regular file */
                /* get info on file */
                /* get file size, exec but, etc */
                uint16_t size = finfo.st_size;
                uint16_t is_exec = finfo.st_mode & S_IXUSR;

                files_add(parent_index, entry->d_name, size, 0, 0, 0, is_exec, path_buf);
            } else if (S_ISDIR(finfo.st_mode)){
                /* add regular file */
                /* set size to 0 - dir contents aren't actually transmitted - they are created from parent linsk in struct file */

                uint16_t parent = files_add(parent_index, entry->d_name, 0, 0, 0, 1, 0, path_buf);
                read_dir(path_buf, parent);
            }
        }
        closedir(d);
    } else {
        //printf("error\n%s\n", strerror(errno));
    }
}

/* read files in the given directory path (command line arg) into files */
void read_files(char *path){
    /* create root dir (no name needed) */
    files_add(-1, "__root", 0, 0, 0, 1, 0, ".");

    read_dir(path, 0);
}

int main(int argc, char **argv){
    if(argc!=3){
        printf("Usage: scpftp dir serial_port\n");
        exit(1);
    }
    /* find port */
    if(sp_get_port_by_name(argv[2], &port) != SP_OK){
        printf("No such serial port: %s\n", argv[2]);
        exit(1);
    }
    /* open */
    if(sp_open(port, SP_MODE_READ_WRITE) != SP_OK){
        printf("Error opening serial port: %s\n", argv[2]);
        exit(1);
    }
    sp_set_baudrate(port, 115200);
    /* wite files */
    read_files(argv[1]);
    write_files();
    /* write out a buffer worth of zeros, to make sure all files are flusshed */
    while(transmitted != BUF_SIZE){
        _write_byte(0);
    }
    sp_close(port);

}
