#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  printf("PID   PRIORITY   CPU-TICKS   STATE     NAME\n");
  ps();
  exit(0);
}