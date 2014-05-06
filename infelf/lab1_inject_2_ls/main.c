#include<stdio.h>

void test1()
{
  printf("1\n");
}
void test2()
{
  printf("2\n");
}
void test3()
{
  printf("3\n");
}
void test4()
{
  printf("4\n");
}
void test5()
{
  printf("5\n");
}
void test6()
{
  printf("6\n");
}
void test7()
{
  printf("7\n");
}

int main()
{
  __asm__ __volatile__("nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
"nop;"
)
;
  test1();
  test2();
  test3();
  test4();
  test5();
  test6();
  test7();
}

