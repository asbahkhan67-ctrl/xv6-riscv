#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  char *p;
  int pid1, pid2;

  p = sbrk(4096);

  if(p == (char*)-1){
    printf("cowtest: sbrk failed\n");
    exit(1);
  }

  *p = 'A';

  printf("Original: %c\n", *p);

  pid1 = fork();

  if(pid1 < 0){
    printf("cowtest: first fork failed\n");
    exit(1);
  }

  if(pid1 == 0){
    *p = 'B';
    exit(0);
  }

  wait(0);
  printf("After child 1: %c\n", *p);

  pid2 = fork();

  if(pid2 < 0){
    printf("cowtest: second fork failed\n");
    exit(1);
  }

  if(pid2 == 0){
    *p = 'C';
    exit(0);
  }

  wait(0);
  printf("After child 2: %c\n", *p);

  exit(0);
}