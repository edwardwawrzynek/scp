#define SCP
//#undef SCP

#include <stdint.h>
#include <stddef.h>

#ifdef SCP
    #include "include/defs.h"
    #include "lib/brk_loc/end.h"
    #include "kernel/proc.h"
    #include "kernel/panic.h"
    #include "include/defs.h"
    #include "include/panic.h"
    #include <lib/string.h>
#endif
#ifndef SCP
    #include <unistd.h>
    #include <stdio.h>
    #include <string.h>
#endif

#ifndef SCP
    #define PANIC_MALLOC_ERROR 1

    void panic(uint16_t code){
        printf("Error\n%u\n", code);
        _exit(0);
    }
#endif

/* kmalloc implementation
 * allocates linked lists of blocks of memory
 * with headers */

/* Basic algorithm to malloc:
 * start at head of list, and go till we find a free block
 * check if it is big enough for request. If so, alloc and split
 * it (if enough space for split).
 * If not, check if the next block is free. If so, combine blocks,
 * and start again.
 * If all that fails, go to next block
 * If no free blocks, make a new one */

#define DEBUG
#define MAGIC 0x1234

/* Header of blocks */
struct _header {
    /* Size of header, in bytes */
    size_t size;
    /* Pointer to next block */
    struct _header * next;
    /* if the block is in use or not */
    uint16_t in_use;
    /* magic number - 0x1234 */
    #ifdef DEBUG
        uint16_t magic;
    #endif
};

/* start of linked list */
struct _header * head = NULL;

/* end of data segment */
#ifdef SCP
    uint8_t * brk_end = &_BRK_END;
#endif
#ifndef SCP
    uint8_t * brk_end;
#endif


/* create a new block at brk */
static struct _header * make_block(size_t size){
    /* add size of header */
    size_t real_size = sizeof(struct _header) + size;
    /* expand brk */
    #ifndef SCP
        brk_end = sbrk(real_size);
    #endif
    #ifdef SCP
        proc_kernel_expand_brk(brk_end+real_size);
    #endif
    /* create header */
    struct _header * block = (struct _header *) brk_end;

    block->size = size;
    block->in_use = 1;
    block->next = NULL;
    #ifdef DEBUG
        block->magic = MAGIC;
    #endif

    brk_end += real_size;

    return block;
}

/* go through linked list till we find a block that is free of at least the passed size */
static struct _header * get_free_block(size_t size){
    struct _header * block = NULL;
    struct _header * pblock = NULL;

    for(block = head; block != NULL; block = block->next){
        #ifdef DEBUG
            if(block->magic != MAGIC){
                panic(PANIC_MALLOC_ERROR);
            }
        #endif

        if(!block->in_use){
            /* check size */
            if(block->size >= size){
                /* return block */
                /* TODO: split */
                block->in_use = 1;
                return block;
            } else {
                /* combine with as many blocks as we can */
                while(block->next != NULL){
                    if(block->next->in_use){
                        break;
                    }
                    /* combine sizes */
                    block->size += block->next->size + sizeof(struct _header);

                    /* clear magic number */
                    #ifdef DEBUG
                        block->next->magic = 0;
                    #endif

                    /* if block after one we are combining with is null, that will just be reflected here */
                    block->next = block->next->next;
                }

                if(block->size >= size){
                    /* return block */
                    /* TODO: split */
                    block->in_use = 1;
                    return block;
                }
            }
        }

        pblock = block;
    }
    /* no free blocks - create one */

    /* if no head, make that */
    if(head == NULL){
        head = make_block(size);
        return head;
    } else {
        pblock->next = make_block(size);
        return pblock->next;
    }
}

/* malloc */
void *kmalloc(size_t size){
    struct _header * block = get_free_block(size);
    return (void *)(block+1);
}

/* free */
void kfree(void *ptr){
    if(ptr == NULL){
        return;
    }
    struct _header * block = ((struct _header *)(ptr)) - 1;
    #ifdef DEBUG
        if(block->magic != MAGIC){
            panic(PANIC_MALLOC_ERROR);
        }
    #endif
    block->in_use = 0;
}

/* realloc (TODO: check next blocks) */
void * krealloc(void *ptr, size_t size){
    if(ptr == NULL){
        return kmalloc(size);
    }
    struct _header * block = ((struct _header *)(ptr)) - 1;
    #ifdef DEBUG
        if(block->magic != MAGIC){
            panic(PANIC_MALLOC_ERROR);
        }
    #endif

    void * new = kmalloc(size);
    memcpy(new, ptr, block->size > size ? size: block->size);
    kfree(ptr);

    return new;
}

void * kcalloc(size_t nmeb, size_t meb_size){
    size_t size = nmeb * meb_size;

    void * res = kmalloc(size);

    if(res != NULL){
        memset(res, 0, size);
    }

    return res;
}
