// pstree - Display the current process hierarchy with child counts.
// Usage:
//   pstree         Show the full process tree starting from init
//   pstree <pid>   Show only the subtree rooted at <pid>

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

static int
is_digits(const char *s)
{
  if (s == 0 || *s == '\0')
    return 0;
  for (; *s; s++) {
    if (*s < '0' || *s > '9')
      return 0;
  }
  return 1;
}

int
main(int argc, char *argv[])
{
  int root_pid = 0;

  if (argc > 2) {
    printf("Usage: pstree [pid]\n");
    exit(1);
  }

  if (argc == 2) {
    if (!is_digits(argv[1])) {
      printf("pstree: invalid PID '%s'\n", argv[1]);
      exit(1);
    }
    root_pid = atoi(argv[1]);
    if (root_pid <= 0) {
      printf("pstree: PID must be >= 1\n");
      exit(1);
    }
  }

  printf("Current PID: %d | Parent PID: %d\n", getpid(), getppid());
  if (root_pid == 0)
    printf("Process Hierarchy:\n");

  if (ptree(root_pid) < 0) {
    printf("pstree: process %d not found\n", root_pid);
    exit(1);
  }

  exit(0);
}
