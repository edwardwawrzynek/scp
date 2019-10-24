#include "object.h"

/**
 * error */
static void _obj_error(char *msg){
  printf("scp obj: error:\n%s\n", msg);
  exit(1);
}

/**
 * write a 1, 2, or 4-byte little endian int to file */
static void _obj_write_val(FILE *f, uint32_t val, uint8_t bytes){
  while(bytes--){
    fputc(val&0xff, f);
    val >>= 8;
  }
}

/**
 * read a 1, 2, or 4-byte little endian int to file */
static uint32_t _obj_read_val(FILE *f, uint8_t bytes){
  uint32_t res = 0;
  uint8_t shift = 0;
  while(bytes--){
    res += (fgetc(f) << shift);
    shift += 8;
    if(feof(f)){
      _obj_error("Unexpected EOF\n");
    }
  }
  return res;
}

/**
 * write an obj_file's segments to the file header
 * fseeks to position zero
 * asumes segs and file is init in obj_file */
void obj_write_header(struct obj_file *obj){
  /* seek to header start */
  fseek(obj->file, 0 + obj->offset, SEEK_SET);
  /* write out magic number */
  _obj_write_val(obj->file, _OBJ_MAGIC_NUMBER, 4);
  /* write out blank */
  _obj_write_val(obj->file, 0, 4);
  /* write out segs */
  for(int i = 0; i < 4; i++){
    _obj_write_val(obj->file, obj->segs.segs[i].offset, 4);
    _obj_write_val(obj->file, obj->segs.segs[i].size, 4);
  }
  /* write out symbol definitions */
  _obj_write_val(obj->file, obj->segs.defined_table.offset, 4);
  _obj_write_val(obj->file, obj->segs.defined_table.size, 4);
  _obj_write_val(obj->file, obj->segs.extern_table.offset, 4);
  _obj_write_val(obj->file, obj->segs.extern_table.size, 4);
  /* make sure we wrote the right size header */
  if(ftell(obj->file) != _OBJ_HEADER_SIZE){
    _obj_error("Internal Error: expected header size doesn't match written header's size");
  }
}

/**
 * init an obj_segs object by reading in the header of the obj_file */
void obj_read_header(struct obj_file *obj){
  /* seek to header start */
  fseek(obj->file, 0 + obj->offset, SEEK_SET);
  /* read magic number, and make sure it is right */
  if(_obj_read_val(obj->file, 4) != _OBJ_MAGIC_NUMBER){
    _obj_error("Expected Magic Number to start file");
  }
  /* read blank */
  _obj_read_val(obj->file, 4);
  /* read in segs */
  uint32_t offset = _OBJ_HEADER_SIZE;
  uint32_t tmp;
  for(int i = 0; i < 4; i++){
    tmp = _obj_read_val(obj->file, 4);
    /* check that the segment is in the right place */
    if(offset != tmp){
      _obj_error("segment misaligned");
    }
    obj->segs.segs[i].offset = tmp;
    tmp = _obj_read_val(obj->file, 4);
    /* inc offset */
    offset += tmp;
    obj->segs.segs[i].size = tmp;
  }
  /* read in symbol definitions */
  tmp = _obj_read_val(obj->file, 4);
  if(offset != tmp){
      _obj_error("symbol segment misaligned");
  }
  obj->segs.defined_table.offset = tmp;
  tmp = _obj_read_val(obj->file, 4);
  offset += tmp;
  obj->segs.defined_table.size = tmp;


  tmp = _obj_read_val(obj->file, 4);
  if(offset != tmp){
      _obj_error("extern symbol segment misaligned");
  }
  obj->segs.extern_table.offset = tmp;
  tmp = _obj_read_val(obj->file, 4);
  offset += tmp;
  obj->segs.extern_table.size = tmp;
  /* make sure we read in the right size header */
  if(ftell(obj->file)-obj->offset != _OBJ_HEADER_SIZE){
    _obj_error("Internal Error: expected header size doesn't match read header's size");
  }
}

/**
 * clear values in an obj_file that need to be reset on init */
void obj_init(struct obj_file *obj){
  obj->file = NULL;
  obj->defined_write_pos = 0;
  obj->extern_write_pos = 0;
  obj->cur_seg = 0;

  obj->offset = 0;

  obj->segs_pos[0] = 0;
  obj->segs_pos[1] = 0;
  obj->segs_pos[2] = 0;
  obj->segs_pos[3] = 0;

}

/**
 * create the header in an obj_segs object given the sizes of eahc segment and number of defined and extern symbols
 * symbols are the number of symbols, NOT the size of the tables
 * segments sizes are in bytes (NOT including the meta-bytes) */
void obj_create_header(struct obj_file *obj, uint32_t seg0, uint32_t seg1, uint32_t seg2, uint32_t seg3, uint32_t defined_symbols, uint32_t extern_symbols){
  uint32_t offset = _OBJ_HEADER_SIZE;

  for(int i = 0; i < 4; i++){
    obj->segs.segs[i].offset = offset;
    switch(i){
      case 0: obj->segs.segs[i].size = seg0 * 2; offset += seg0 * 2; break;
      case 1: obj->segs.segs[i].size = seg1 * 2; offset += seg1 * 2; break;
      case 2: obj->segs.segs[i].size = seg2 * 2; offset += seg2 * 2; break;
      case 3: obj->segs.segs[i].size = seg3 * 2; offset += seg3 * 2; break;
      default: break;
    }
  }
  obj->segs.defined_table.offset = offset;
  obj->segs.defined_table.size = defined_symbols * _OBJ_SYMBOL_ENTRY_SIZE;
  offset += defined_symbols * _OBJ_SYMBOL_ENTRY_SIZE;

  obj->segs.extern_table.offset = offset;
  obj->segs.extern_table.size = extern_symbols * _OBJ_SYMBOL_ENTRY_SIZE;
  offset += extern_symbols * _OBJ_SYMBOL_ENTRY_SIZE;

}

/* expand the extern table in a obj_file, and write the changes to the header to disk - used when externs need offsets */
void obj_expand_extern(struct obj_file *obj, uint32_t extern_symbols){
  obj->segs.extern_table.size = extern_symbols * _OBJ_SYMBOL_ENTRY_SIZE;
  /* seek to the right spot in header */
  fseek(obj->file, 13*4 + obj->offset, SEEK_SET);
  _obj_write_val(obj->file, obj->segs.extern_table.size, 4);
}

/* write a symbol entry object to addr in obj's file */
static void _obj_write_symbol(struct obj_file *obj, struct obj_symbol_entry *sym, uint32_t addr){
  fseek(obj->file, addr + obj->offset, SEEK_SET);
  /* write name */
  uint8_t hit_null = 0;
  for(uint8_t i = 0; i < _OBJ_SYMBOL_SIZE; i++){
    if(!sym->name[i]){
      hit_null = 1;
    }
    if(!hit_null){
      _obj_write_val(obj->file, sym->name[i], 1);
    } else {
      _obj_write_val(obj->file, 0, 1);
    }
  }
  if(!hit_null){
    printf("\nName: %s\n", sym->name);
    _obj_error("Above symbol name is too long\n");
  }
  /* write offset */
  _obj_write_val(obj->file, sym->offset, 2);
  /* write seg */
  _obj_write_val(obj->file, sym->seg, 1);
}

/* read in a symbol entry from an addr in an obj's file */
static void _obj_read_symbol(struct obj_file *obj, struct obj_symbol_entry *sym, uint32_t addr){
  fseek(obj->file, addr + obj->offset, SEEK_SET);
  /* read in name */
  for(uint8_t i = 0; i < _OBJ_SYMBOL_SIZE; i++){
    sym->name[i] = _obj_read_val(obj->file, 1);
  }
  /* read in offset */
  sym->offset = _obj_read_val(obj->file, 2);
  /* read in seg number */
  sym->seg = _obj_read_val(obj->file, 1);
}

/* write a symbol to the defined symbol table */
void obj_write_defined(struct obj_file *obj, char *name, uint8_t seg, uint16_t off){
  uint32_t addr = obj->segs.defined_table.offset + (obj->defined_write_pos * _OBJ_SYMBOL_ENTRY_SIZE);
  /* construct obj_symbol_entry */
  struct obj_symbol_entry sym;
  strcpy(sym.name, name);
  sym.seg = seg;
  sym.offset = off;
  _obj_write_symbol(obj, &sym, addr);

  obj->defined_write_pos++;

  
}

/* write a symbol to the extern symbol table - with an offset from that symbol (usually zero)
  return index of that symbol */
uint32_t obj_write_extern(struct obj_file *obj, char *name, uint16_t off){
    uint32_t addr = obj->segs.extern_table.offset + (obj->extern_write_pos * _OBJ_SYMBOL_ENTRY_SIZE);
  /* construct obj_symbol_entry */
  struct obj_symbol_entry sym;
  strcpy(sym.name, name);
  sym.seg = -1;
  sym.offset = off;
  _obj_write_symbol(obj, &sym, addr);

  return obj->extern_write_pos++;
}

/* read in the whole defined symbol table into a malloc'd array, and return it */
struct obj_symbol_entry * obj_get_defined(struct obj_file *obj){
  struct obj_symbol_entry *res;
  uint32_t num_elms = obj->segs.defined_table.size/_OBJ_SYMBOL_ENTRY_SIZE;
  uint32_t size = num_elms * sizeof(struct obj_symbol_entry);
  res = malloc(size);

  for(uint32_t i = 0; i < num_elms; i++){
    _obj_read_symbol(obj, &res[i], obj->segs.defined_table.offset + (i*_OBJ_SYMBOL_ENTRY_SIZE) );
  }

  return res;
}

/* read in the whole extern symbol table into a malloc'd array, and return it */
struct obj_symbol_entry * obj_get_extern(struct obj_file *obj){
  struct obj_symbol_entry *res;
  uint32_t num_elms = obj->segs.extern_table.size/_OBJ_SYMBOL_ENTRY_SIZE;
  uint32_t size = num_elms * sizeof(struct obj_symbol_entry);
  res = malloc(size);

  for(uint32_t i = 0; i < num_elms; i++){
    _obj_read_symbol(obj, &res[i], obj->segs.extern_table.offset + (i*_OBJ_SYMBOL_ENTRY_SIZE) );
  }

  return res;
}

/* find a symbol by name in a defined symbols array, and return it's address. return NULL otherwise */
struct obj_symbol_entry * obj_find_defined_symbol(struct obj_file *obj, char*name, struct obj_symbol_entry *syms){
  uint32_t num_elms = obj->segs.defined_table.size / _OBJ_SYMBOL_ENTRY_SIZE;

  for(uint32_t i = 0; i < num_elms; i++){
    if(!strcmp(name, syms[i].name)){
      return &syms[i];
    }
  }
  return NULL;
}

/* set the current segment being written to */
void obj_set_seg(struct obj_file *obj, uint8_t seg){
  obj->cur_seg  = seg;
}

/* write just a plain byte to the current segment */
static void _obj_write(struct obj_file *obj, uint8_t val){
  if(obj->segs_pos[obj->cur_seg] >= obj->segs.segs[obj->cur_seg].size){
    _obj_error("seg size overrun");
  }
  fseek(obj->file, obj->segs.segs[obj->cur_seg].offset + obj->segs_pos[obj->cur_seg] + obj->offset, SEEK_SET);
  obj->segs_pos[obj->cur_seg]++;
  fputc(val, obj->file);
}

/* write a constant byte (+meta byte) to the current segment */
void obj_write_const_byte(struct obj_file *o, uint8_t val){
  /* no flags needed */
  _obj_write(o, 0);
  _obj_write(o, val);
}
/* write a constant word (+meta bytes) to the current segment */
void obj_write_const_word(struct obj_file *o, uint16_t val){
  _obj_write(o, OBJ_IS_WORD);
  _obj_write(o, val & 0xff);

  _obj_write(o, OBJ_IS_WORD | OBJ_IS_2ND_BYTE);
  _obj_write(o, val >> 8);
}

/* write an offset to the current segment
  offset is offset in segment
  seg is segment offset is in
  pc_rel is true if the offset should be pc-relative */
void obj_write_offset(struct obj_file *o, uint16_t offset, uint8_t seg, uint8_t pc_rel){
  uint8_t flags = OBJ_IS_WORD | OBJ_IS_SYMBOL;
  flags |= pc_rel ? OBJ_IS_PC_RELATIVE : 0;
  flags |= (seg & 0b11) << 4;

  _obj_write(o, flags);
  _obj_write(o, offset & 0xff);

  _obj_write(o, flags | OBJ_IS_2ND_BYTE);
  _obj_write(o, offset >> 8);
}

/* write an external symbol to the current segment
   index is the extrn's index in the extern table
   pc_rel is true if the resulting offset should be pc-relative */
void obj_write_extern_offset(struct obj_file *o, uint16_t index, uint8_t pc_rel){
  uint8_t flags = OBJ_IS_WORD | OBJ_IS_SYMBOL | OBJ_IS_EXTERN;
  flags |= pc_rel ? OBJ_IS_PC_RELATIVE : 0;

  _obj_write(o, flags);
  _obj_write(o, index & 0xff);

  _obj_write(o, flags | OBJ_IS_2ND_BYTE);
  _obj_write(o, index >> 8);
}

/* read in a byte, or return EOF if end of seg/file */
static int _obj_read_byte(struct obj_file *obj){
  if(obj->segs_pos[obj->cur_seg] >= obj->segs.segs[obj->cur_seg].size){
    return -1;
  }
  fseek(obj->file, obj->segs.segs[obj->cur_seg].offset + obj->segs_pos[obj->cur_seg] + obj->offset, SEEK_SET);
  obj->segs_pos[obj->cur_seg]++;
  return fgetc(obj->file);
}

/* read in a flag byte and a value byte, (return -1 if we hit the end of the current seg) */
int obj_read_byte(struct obj_file *obj, uint8_t *byte, uint8_t *flag){
  int flag_in, byte_in;
  flag_in = _obj_read_byte(obj);
  byte_in = _obj_read_byte(obj);
  if(flag_in == -1 || byte_in == -1){
    return -1;
  }

  *flag = flag_in;
  *byte = byte_in;
  return 0;
}

/* read in a word or byte (depending on flags), and set flags recv'd (return -1 if we hit the end of the seg) */
int obj_read_data(struct obj_file *obj, uint16_t *data, uint8_t *flag, uint8_t *is_word){
  uint8_t flag0, flag1, byte0, byte1;

  if(obj_read_byte(obj, &byte0, &flag0) == -1){
    return -1;
  }
  if(flag0 & OBJ_IS_WORD){
    *is_word = 1;
  } else {
    *is_word = 0;
    *data = byte0;
    *flag = flag0;
    return 0;
  }

  if(obj_read_byte(obj, &byte1, &flag1) == -1){
    _obj_error("Expected a second byte in word");
    return -1;
  }
  if(!(flag1 & OBJ_IS_2ND_BYTE)){
    _obj_error("Second byte in word isn't marked as such");
  }
  *data = byte0 + (byte1 << 8);
  *flag = flag0;

  return 0;

}