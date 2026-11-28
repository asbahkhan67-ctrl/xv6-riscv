// strace - Trace system calls made by a command at runtime.
// Usage:
//   strace -a <cmd> [args...]     Trace all system calls
//   strace -e <cmd> [args...]     Trace only failing system calls (ret < 0)
//   strace -c <cmd> [args...]     Print a summary table of calls & errors on exit
//   strace <mask> <cmd> [args...] Trace specific syscalls matching bitmask

#include "kernel/param.h"
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
  fprintf(2, "Usage:\n");
  fprintf(2, "  strace -a <cmd> [args...]     (trace all system calls)\n");
<<<<<<< HEAD
<<<<<<< HEAD
  fprintf(2, "  strace -e <cmd> [args...]     (trace only failing system calls)\n");
  fprintf(2, "  strace -c <cmd> [args...]     (print call & error summary on exit)\n");
  fprintf(2, "  strace <mask> <cmd> [args...] (trace syscalls matching decimal bitmask)\n");
=======
=======
>>>>>>> bc531db (Implemented modules 11-15)
  fprintf(
    2, "  strace -e <cmd> [args...]     (trace only failing system calls)\n");
  fprintf(
    2,
    "  strace -c <cmd> [args...]     (print call & error summary on exit)\n");
  fprintf(
    2,
    "  strace <mask> <cmd> [args...] (trace syscalls matching decimal bitmask)\n");
<<<<<<< HEAD
>>>>>>> b8719fe (updated project)
=======
>>>>>>> bc531db (Implemented modules 11-15)
}

int
main(int argc, char *argv[])
{
  int i;
  uint64 mask;
  int mode = 0;
  char *nargv[MAXARG];

  if (argc < 3) {
    usage();
    exit(1);
  }

  if (strcmp(argv[1], "-a") == 0) {
    mask = ~(uint64)0;
  } else if (strcmp(argv[1], "-e") == 0) {
    mask = ~(uint64)0;
    mode = TRACE_ERRORS;
  } else if (strcmp(argv[1], "-c") == 0) {
    mask = ~(uint64)0;
    mode = TRACE_SUMMARY;
  } else if (is_digits(argv[1])) {
    mask = (uint64)atoi(argv[1]);
  } else {
    usage();
    exit(1);
  }

  if (tracemode(mode) < 0 || trace(mask) < 0) {
    fprintf(2, "strace: failed to enable tracing\n");
    exit(1);
  }

  for (i = 2; i < argc && i - 2 < MAXARG - 1; i++)
    nargv[i - 2] = argv[i];
  nargv[i - 2] = 0;

  exec(nargv[0], nargv);
  fprintf(2, "strace: exec %s failed\n", nargv[0]);
  exit(1);
}
