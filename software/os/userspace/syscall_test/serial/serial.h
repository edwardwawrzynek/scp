/* Code common to both host (modern computer) and target (scp) systems */

#include <stdint.h>

//max number of files per dir
#define DIR_MAX_FILES 32
//length of filenames
#define FILE_NAME_LEN 14
//max number of files total
#define MAX_FILES 64

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
    /* if file is dir, number of files */
    uint16_t num_files;
    /* if the file is a directory, the indexes of its files */
    uint16_t files[DIR_MAX_FILES];
};
