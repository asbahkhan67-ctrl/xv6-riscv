// reboot - Flush disk buffers and restart QEMU cleanly.
// Usage:
//   reboot         Restart immediately
//   reboot <sec>   Broadcast countdown warning for <sec> seconds (1..60)

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
  int delay = 0;

  if (argc == 2) {
    if (!is_digits(argv[1])) {
      printf("Usage: reboot [seconds]\n");
      exit(1);
    }
    delay = atoi(argv[1]);
    if (delay < 0 || delay > 60) {
      printf("reboot: delay must be between 0 and 60 seconds\n");
      exit(1);
    }
  } else if (argc > 2) {
    printf("Usage: reboot [seconds]\n");
    exit(1);
  }

  if (delay > 0) {
    printf("Broadcast: NexusXv6 rebooting in %d second(s)...\n", delay);
    for (int s = delay; s > 0; s--) {
      printf("  rebooting in %d...\n", s);
      pause(10); // ~1 second per 10 clock ticks
    }
  }

  printf("Flushing filesystems...\n");
  sync();
  printf("Rebooting NexusXv6...\n");
  reboot();
  printf("reboot: failed\n");
  exit(1);
}
