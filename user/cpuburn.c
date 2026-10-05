#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  volatile uint64 i;

  for(;;){
    for(i = 0; i < 1000000000ULL; i++)
      ;
  }

  exit(0);
}