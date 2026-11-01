#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  printf("Shutting down NexusXv6...\n");
  sync();
  halt();
  printf("shutdown: halt failed\n");
  exit(1);
}
