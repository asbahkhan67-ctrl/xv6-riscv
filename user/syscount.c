// syscount - Inspect total or per-syscall counts for a process.
// Usage:
//   syscount            Run built-in self-test (before & after 5x getpid())
//   syscount <pid>      Show total syscalls for <pid> (0 = self)
//   syscount -v [pid]   Show top syscalls & full per-syscall breakdown table

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
  printf("  syscount            (self-check with 5x getpid())\n");
  printf("  syscount <pid>      (total syscalls for PID; 0 = self)\n");
<<<<<<< HEAD
  printf("  syscount -v [pid]   (verbose breakdown & top syscalls; 0 = self)\n");
=======
  printf(
    "  syscount -v [pid]   (verbose breakdown & top syscalls; 0 = self)\n");
>>>>>>> b8719fe (updated project)
}

int
main(int argc, char *argv[])
{
  int pid, before, after, count, i;

  if (argc >= 2 && strcmp(argv[1], "-v") == 0) {
    if (argc > 3) {
      usage();
      exit(1);
    }
    pid = 0;
    if (argc == 3) {
      if (!is_digits(argv[2])) {
        printf("syscount: invalid PID '%s'\n", argv[2]);
        exit(1);
      }
      pid = atoi(argv[2]);
    }
    if (syscallstats(pid) < 0) {
      printf("syscount: process %d not found\n", pid);
      exit(1);
    }
    exit(0);
  }

  if (argc == 2) {
    if (!is_digits(argv[1])) {
      usage();
      exit(1);
    }
    pid = atoi(argv[1]);
    count = getsyscallcount(pid);
    if (count < 0) {
      printf("syscount: process %d not found\n", pid);
      exit(1);
    }
<<<<<<< HEAD
    printf("Process %d total syscalls: %d\n", (pid == 0) ? getpid() : pid, count);
=======
    printf("Process %d total syscalls: %d\n", (pid == 0) ? getpid() : pid,
           count);
>>>>>>> b8719fe (updated project)
    exit(0);
  }

  if (argc != 1) {
    usage();
    exit(1);
  }

  before = getsyscallcount(0);
  for (i = 0; i < 5; i++)
    getpid();
  after = getsyscallcount(0);

  printf("PID %d syscall count before 5x getpid(): %d\n", getpid(), before);
  printf("PID %d syscall count after  5x getpid(): %d\n", getpid(), after);
  if (after - before < 6) {
    printf("syscount: FAIL - unexpected delta (%d)\n", after - before);
    exit(1);
  }
  exit(0);
}
