/* This file was automatically generated.  Do not edit! */
#undef INTERFACE
void fs_close();
void fs_init();
uint16_t fs_path_to_contain_dir(uint8_t *name,uint16_t cwd,uint16_t croot,uint8_t *file_name);
uint16_t fs_path_to_inum(uint8_t *name,uint16_t cwd,uint16_t croot);
extern uint8_t fs_global_buf[DISK_BLK_SIZE];
