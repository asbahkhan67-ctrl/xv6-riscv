#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  printf("Current PID: %d | Parent PID: %d\n", getpid(), getppid());
  printf("Process Hierarchy:\n");
  ptree();
  exit(0);
}
