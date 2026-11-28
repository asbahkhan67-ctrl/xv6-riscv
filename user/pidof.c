// pidof - Find active process IDs by process name using findproc().
// Usage: pidof <name>

#include "kernel/types.h"
#include "kernel/param.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int pids[NPROC];

  if (argc != 2) {
    printf("Usage: pidof <process_name>\n");
    exit(1);
  }

  int count = findproc(argv[1], pids, NPROC);
  if (count < 0) {
    printf("pidof: lookup failed\n");
    exit(1);
  }

  if (count == 0) {
    printf("pidof: no active process named '%s'\n", argv[1]);
    exit(1);
  }

  printf("PID(s) for '%s':", argv[1]);
  for (int i = 0; i < count && i < NPROC; i++)
    printf(" %d", pids[i]);
  printf("\n");
  exit(0);
}
