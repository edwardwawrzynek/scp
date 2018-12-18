#include "include/stdint.h"

/* This file contains configurable OS definitions, and includes those that are
 * not configurable from other files */

/* File System Options */
//Number of entries in the inode table
#define INODE_TABLE_ENTRIES 24
//Number of entries in the file table
#define FILE_TABLE_ENTRIES 32
//Number of entries in the buffer table - FILE_TABLE_ENTRIES because each file table entry usually has 1 unique buffer
#define BUFFER_TABLE_ENTRIES FILE_TABLE_ENTRIES
//Keep inode table entries open until they are needed - semi experimental (likely works)
#define INODE_TABLE_KEEP_OPEN
//#undef INODE_TABLE_KEEP_OPEN

/* Process Options */
//Default number of pages for the proc's user stack
#define PROC_DEFAULT_STACK_PAGES 1
//Number of entries in the process table
#define PROC_TABLE_ENTRIES 16
//Number of file entries allowed per proc
#define PROC_NUM_FILES 8

/* max time for a process to run (in 2^12 clk ticks) */
#define SHED_MAX_TIME 100

/* non configurable definitions */

#ifndef NULL
#define NULL 0
#endif

/* ---- File structures ---- */
#include "include/fs.h"

/* Process structures */
#include "include/proc.h"

/* ---- Panic codes ---- */
#include "include/panic.h"

/* ---- kernel definitions ---- */
#include "include/kernel.h"