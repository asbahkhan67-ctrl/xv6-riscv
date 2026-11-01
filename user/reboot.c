#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  printf("Rebooting NexusXv6...\n");
  sync();
  reboot();
  printf("reboot: failed\n");
  exit(1);
}
