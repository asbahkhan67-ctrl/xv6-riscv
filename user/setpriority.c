// setpriority - View or update a process's scheduling priority (1..20).
// Priority 1 is highest, 10 is default, and 20 is lowest.
// Pass pid = 0 to target the calling process itself.

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

static void
usage(void)
{
  printf("Usage:\n");
  printf("  setpriority <pid>             (view current priority; 0 = self)\n");
  printf("  setpriority <pid> <1..20>     (set priority: 1=highest, 10=default, 20=lowest)\n");
}

int
main(int argc, char *argv[])
{
  int pid, target_pid, old_prio, new_prio;

  if (argc != 2 && argc != 3) {
    usage();
    exit(1);
  }

  if (!is_digits(argv[1])) {
    printf("setpriority: invalid PID '%s'\n", argv[1]);
    exit(1);
  }

  pid = atoi(argv[1]);
  target_pid = (pid == 0) ? getpid() : pid;

  // Query mode: setpriority <pid>
  if (argc == 2) {
    old_prio = getpriority(pid);
    if (old_prio < 0) {
      printf("setpriority: process %d not found\n", target_pid);
      exit(1);
    }
    if (pid == 0)
      printf("Process %d (self) current priority: %d\n", target_pid, old_prio);
    else
      printf("Process %d current priority: %d\n", target_pid, old_prio);
    exit(0);
  }

  // Update mode: setpriority <pid> <priority>
  if (!is_digits(argv[2])) {
    printf("setpriority: invalid priority '%s' (must be 1..20)\n", argv[2]);
    exit(1);
  }

  new_prio = atoi(argv[2]);
  old_prio = getpriority(pid);
  if (old_prio < 0) {
    printf("setpriority: process %d not found\n", target_pid);
    exit(1);
  }

  if (setpriority(pid, new_prio) < 0) {
    printf("setpriority: failed (priority must be between 1 and 20)\n");
    exit(1);
  }

  if (pid == 0)
    printf("Process %d (self) priority changed: %d -> %d\n",
           target_pid, old_prio, new_prio);
  else
    printf("Process %d priority changed: %d -> %d\n",
           target_pid, old_prio, new_prio);

  exit(0);
}
