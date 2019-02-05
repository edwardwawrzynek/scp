/* This file was automatically generated.  Do not edit! */
#undef INTERFACE
void palloc_free(uint8_t i);
uint8_t palloc_alloc(uint8_t page);
uint8_t palloc_add_ref(uint8_t page);
uint8_t palloc_new();
extern uint8_t palloc_page_refs[MMU_NUM_PROCS];
