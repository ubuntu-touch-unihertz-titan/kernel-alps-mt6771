#ifndef AW9523B_H
#define AW9523B_H

#ifndef BOOL
    #define BOOL char
#endif

 #ifndef U32
    #define U32 unsigned long
#endif

#ifndef TRUE
    #define TRUE 1
#endif
 
#ifndef FALSE
    #define FALSE 0
#endif
 
#ifndef NULL
    #define NULL ((void*)0)
#endif

#define AW9523_KEY_NAME	"aw9523-key"
 
#define AW9523_TAG "[aw9523] "

#define AW9523_DEBUG

#ifdef AW9523_DEBUG
#define AW9523_FUN(f) printk(KERN_ERR AW9523_TAG "%s\n", __FUNCTION__)
#define AW9523_LOG(fmt, args...) printk(KERN_ERR AW9523_TAG fmt, ##args)
#else
#define AW9523_LOG(fmt, args...)
#define AW9523_FUN(f)
#endif

typedef struct{
	char name[10];
	int key_code;
	int key_val;
	int row;
	int col;
}KEY_STATE;

#endif
