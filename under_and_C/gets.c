#include<stdio.h>
int main()
{
  char buf[8];
  gets(buf);
  printf("%s\n",buf);
  gets(buf);
  return 0;
}
