#include"csapp.h"


int main(int argc, char *argv[])
{
  int size;
  char *start;
  struct stat stat;
  int fd = open(argv[1], O_RDONLY);
  /*printf("%d\n",fd);*/
  
  fstat(fd,&stat);
  size = stat.st_size;
  start = mmap(NULL,size,PROT_READ,MAP_PRIVATE,fd,0);

  write(1,start,size);
  return 0;
}
