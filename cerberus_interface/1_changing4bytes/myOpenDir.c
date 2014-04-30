#include <stdio.h>
 #include <sys/types.h>
 #include <stdlib.h>
 #include <fcntl.h>
 #include <dirent.h>
 #include <dlfcn.h>

 #define LIBC_PATH    "/lib/i386-linux-gnu/libc.so.6"

 DIR     *opendir(const char *name)
 {
   void  *handle;
   void  *(*sym)(const char *name);

   handle = dlopen(LIBC_PATH, RTLD_LAZY);
   sym = (void *) dlsym(handle, "opendir");
   printf("OPENDIR HIJACKED -orig- = %08X .::. -param- = %s \n", 
			   sym, name);
   return (sym(name));
 }
