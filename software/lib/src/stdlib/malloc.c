#include <stdint.h>
#include <stddef.h>

#include <unistd.h>
#include <stdio.h>
#include <string.h>

/* scp libc malloc implementation. Basically the same thing as scp kernel implementation */

/* malloc implementation
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

/* debugging mode (check that all blocks passed have magic number) */
static void malloc_magic_fail(){
    #ifdef DEBUG
        /* TODO: fail */
        fprintf(stderr, "malloc magic number assert fail");
    #endif
}

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
static struct _header * head = NULL;

/* end of data segment */
static uint8_t * brk_end;



/* create a new block at brk */
static struct _header * make_block(size_t size){
    /* add size of header */
    size_t real_size = sizeof(struct _header) + size;
    /* expand brk */

    brk_end = sbrk(real_size);

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

/* split a block to be of the given size, and create a block the fills the remaining space
 * return block, or NULL if not enough space to add a header in remaining space
 * next pointers are handled */
static struct _header * split_block(struct _header * block, size_t size){
    /* make sure we can hold at least a header + 1 bytes in new block */
    if(block->size < (size + sizeof(struct _header))){
        return NULL;
    }
    /* make new header */
    struct _header * new = (struct _header *)((uint8_t *)block + sizeof(struct _header) + size);
    new->in_use = 0;
    new->size = block->size - (size + sizeof(struct _header));
    block->size = size;

    #ifdef DEBUG
        new->magic = MAGIC;
    #endif
    new->next = block->next;
    block->next = new;

    return new;
}

/* go through linked list till we find a block that is free of at least the passed size */
static struct _header * get_free_block(size_t size){
    struct _header * block = NULL;
    struct _header * pblock = NULL;

    for(block = head; block != NULL; block = block->next){
        #ifdef DEBUG
            if(block->magic != MAGIC){
                malloc_magic_fail();
            }
        #endif

        if(!block->in_use){
            /* check size */
            if(block->size >= size){
                /* return block */
                split_block(block, size);
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
                    split_block(block, size);
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

/* go through list and remove free blocks at end */
static void free_end(){
    struct _header * pblock = NULL;
    for(struct _header * block = head; block != NULL; block = block->next){
        #ifdef DEBUG
            if(block->magic != MAGIC){
                malloc_magic_fail();
            }
        #endif
        if(block->in_use){
            pblock = block;
            continue;
        }
        /* combine with next blocks */
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
        /* check if it is last block */
        if(block->next == NULL && pblock != NULL){
            /* unlink */
            if(pblock->next != block){
                malloc_magic_fail();
            }
            pblock->next = NULL;
            #ifdef DEBUG
                block->magic = 0;
            #endif
            brk_end -= (block->size + sizeof(struct _header));
            sbrk(-(block->size + sizeof(struct _header)));
        }
        pblock = block;
    }
}

/* malloc */
void *malloc(size_t size){
    /* align */
    if(size &1){
        size++;
    }
    struct _header * block = get_free_block(size);
    return (void *)(block+1);
}

/* free */
void free(void *ptr){
    if(ptr == NULL){
        return;
    }
    struct _header * block = ((struct _header *)(ptr)) - 1;
    #ifdef DEBUG
        if(block->magic != MAGIC){
            malloc_magic_fail();
        }
    #endif
    block->in_use = 0;

    free_end();
}

/* realloc */
void * realloc(void *ptr, size_t size){
    /* align */
    if(size&1){
        size++;
    }
    if(ptr == NULL){
        return malloc(size);
    }
    struct _header * block = ((struct _header *)(ptr)) - 1;
    #ifdef DEBUG
        if(block->magic != MAGIC){
            malloc_magic_fail();
        }
    #endif

    /* combine with next blocks */
    for(struct _header * head = block->next; head != NULL; head = head->next){
        if(head->in_use){
            break;
        }
        block->size += sizeof(struct _header) + head->size;
        block->next = head->next;
    }

    size_t sum_size = block->size;

    /* if the block can hold the requested size, use it */
    if(size <= sum_size){
        split_block(block, size);
        return ptr;
    } else {
        void * new = malloc(size);
        memcpy(new, ptr, block->size > size ? size: block->size);
        free(ptr);

        return new;
    }
}

void * calloc(size_t nmeb, size_t meb_size){
    size_t size = nmeb * meb_size;

    void * res = malloc(size);

    if(res != NULL){
        memset(res, 0, size);
    }

    return res;
}
