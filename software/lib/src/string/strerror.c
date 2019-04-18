#include <string.h>
#include <errno.h>

static char * errors[__ERRNO_LEN] = {
    "No error (errno 0)",
    "No such file or directory", /* ENOENT */
    "Bad file descriptor", /* EBADF */
    "File exists", /* EEXISTS */
    "No child procs", /* ECHILD */
    "Invalid userspace pointer", /* EUMEM */
    "Not a directory", /* ENOTDIR */
    "Is a directory", /* EISDIR */
    "Directory not empty", /* ENOTEMPTY */
    "Cannot allocate memory", /* ENOMEM */
    "Not an executable", /* ENOEXEC */
    "Invalid syscall args", /*EARG */
    "Improper ioctl for file", /* ENOTTY */
    "Improper file mode", /* EVMOD */
};

char * strerror(int err){
    if(err >= __ERRNO_LEN){
        return "Unkown Error Number";
    }
    return errors[err];
}