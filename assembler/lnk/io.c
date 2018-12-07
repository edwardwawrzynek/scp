#include <stdio.h>

#include "lnk.h"
#include "object.h"
#include "obj.h"

/* Input object files */
struct obj_file in_objs[MAX_FILES];

/* Output binary */
FILE *out_file;