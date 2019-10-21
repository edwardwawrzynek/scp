/* This file was automatically generated.  Do not edit! */
void palloc_free(uint16_t i);
uint16_t palloc_use_page(uint16_t page);
uint16_t palloc_alloc(uint16_t page);
uint16_t palloc_add_ref(uint16_t page);
uint16_t palloc_new();
extern uint16_t palloc_page_refs[MMU_NUM_PAGES];
