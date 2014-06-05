void timestamp1()
{ 
  unsigned int stamp1;
  char str1[4];
  str1[0]='%';
  str1[1]='d';
  str1[2]='\n';
  str1[3]='\0';

  
  stamp1=sysTimestamp();
 

  printf(str1,stamp1);
}
  

void timestamp2()
{
  unsigned int stamp2;
  char str2[4];
  str2[0]='%';
  str2[1]='d';
  str2[2]='\n';
  str2[3]='\0';

 
  stamp2=sysTimestamp();
 
  printf(str2,stamp2);
}