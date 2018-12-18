//a struct can't uses itself as a member (due to scc wierdness), so 2 fake header structs are defined
struct _malloc_header_f1 {
    unsigned int * prev;
    unsigned int * next;
    unsigned int size;
    unsigned char free;
};

struct _malloc_header_f2 {
    struct _malloc_header_f1 * prev;
    struct _malloc_header_f1 * next;
    unsigned int size;
    unsigned char free;
};

//Real Header
struct _malloc_header {
    //ptr to previous header
    struct _malloc_header_f2 * prev;
    //ptr to next header
    struct _malloc_header_f2 * next;
    //size of the block in bytes - NOT including header
    unsigned int size;
    //whether the block is free or not
    unsigned char free;
};

//pointer to end of data segment, will later be gotten by sbrk
static unsigned char * brk;

//pointer to first and last blocks(set when first block is created)
static struct _malloc_header * _malloc_head;
static struct _malloc_header * _malloc_tail;


//create a new block, link it to _prev_blk, and return a pointer to the start of the data area of the blk
_malloc_new(unsigned int size, struct _malloc_header * prev_blk){
    struct _malloc_header header;

    header.free = 0;
    header.size = size;
    header.prev = prev_blk;
    header.next = 0;
    //memcpy header to memory
    memcpy(brk, &header, sizeof(struct _malloc_header));
    if(prev_blk){
        prev_blk->next = brk;
    } else {
        //set _malloc_head to be this block
        _malloc_head = brk;
    }
    //set _malloc_tail
    _malloc_tail = brk;
    //increment brk the appropriate amount
    brk += sizeof(struct _malloc_header) + size;
    return brk - size;
}

//attempt to combine a free block with those before and after it if they are free
_malloc_combine(struct _malloc_header * header){
    if(header->next){
        if(header->next->free){
            //combine with the next block, using this block's header as the final result's header
            header->size += header->next->size + sizeof(struct _malloc_header);
            header->next = header->next->next;
            if(!(header->next)){
                _malloc_tail = header;
            }
            _malloc_combine(header);
        }
    }
    else if(header->prev){
        _malloc_combine(header->prev);
    }
}


kmalloc(unsigned int size){
    struct _malloc_header new;
    struct _malloc_header *cur;
    unsigned char *loc;
    unsigned int extra_space;
    unsigned char *new_loc;
    //search for a free block of good size, and split it if it has extra space
    cur = _malloc_head;
    while(cur){
        if(cur->size >= size && cur->free){
            //Mark the block in use
            cur->free = 0;
            //set loc
            loc = cur;
            extra_space = cur->size - size;
            //If the block can be split and the second half have enough space for another header + at leats 1 byte of data, do so
            if(extra_space > sizeof(struct _malloc_header)){
                //reduce first block's size
                cur->size = size;
                //create a new header
                new.free = 1;
                new.size = extra_space - sizeof(struct _malloc_header);
                new.prev = cur;
                new.next = cur->next;
                //write header
                new_loc = loc + sizeof(struct _malloc_header) + size;
                memcpy(new_loc, &new, sizeof(struct _malloc_header));
                //adjust the list to include the new block
                //if there is is a block after the new one, set that, or, if not, set _malloc_tail
                if(cur->next){
                    cur->next->prev = new_loc;
                } else {
                    _malloc_tail = new_loc;
                }
                cur->next = new_loc;
            }

            return loc+sizeof(struct _malloc_header);
        }
        cur = cur->next;
    }
    //No block found, so create a new one
    return _malloc_new(size, _malloc_tail);
}

kcalloc(unsigned int nvals, unsigned int svals){
    unsigned int size;
    unsigned char *ptr;
    unsigned char *ptr2;
    size = nvals*svals;
    ptr = kmalloc(size);
    ptr2 = ptr;
    while(size--){
        *(ptr2++) = 0;
    }
    return ptr;
}

kfree(unsigned char *ptr){
    struct _malloc_header * header;
    //Get the header for the blk
    header = ptr - sizeof(struct _malloc_header);
    //Mark as free
    header->free = 1;
    //Check if the block above or below is free, and, if so, combine with it
    _malloc_combine(header);
}

krealloc(unsigned char *ptr, unsigned int size){
    struct _malloc_header *header;
    unsigned char *res;
    header = ptr - sizeof(struct _malloc_header);
    res = kmalloc(size);
    memcpy(res, ptr, header->size);
    kfree(ptr);
    return res;
}
