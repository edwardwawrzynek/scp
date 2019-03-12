/* Code common to both host (modern computer) and target (scp) systems */

#include <stdint.h>

//length of filenames
#define FILE_NAME_LEN 14
//max number of files total
#define MAX_FILES 64

//buffer size to use for transfer
#define BUF_SIZE 2

/* An array of these file structs are transmitted first. They define what files are going to be sent and created. Any index var in them is the index in the global transmitted file array */
/* Note: device files can't be sent. Only normal files, and directories are sent (execute and dir bits can be sent) */
struct file {
    /* file name - null terminated */
    uint8_t name[FILE_NAME_LEN];
    /* length of file (in bytes) */
    uint16_t bytes;
    /* if the file is a directory */
    uint8_t is_dir;
    /* if the file is a executable file */
    uint8_t is_executable;
    /* dev number of file (0 for normal) */
    uint16_t dev_num;
    /* dev minor number */
    uint16_t minor_num;
    /* the index of the parent dir of the file, or -1 if index 0 (root dir) */
    uint16_t parent_dir;
};
