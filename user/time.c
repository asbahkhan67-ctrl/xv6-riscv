// time - Benchmark a command's elapsed time, CPU ticks (CPU%), wait ticks,
// context switches, and exit status using waitx().

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int pid, status;
  uint64 wtime, rtime, csw;

  if (argc < 2) {
    fprintf(2, "Usage: time <command> [args...]\n");
    exit(1);
  }

  pid = fork();
  if (pid < 0) {
    fprintf(2, "time: fork failed\n");
    exit(1);
  }

  if (pid == 0) {
    exec(argv[1], &argv[1]);
    fprintf(2, "time: exec %s failed\n", argv[1]);
    exit(1);
  }

  status = 0;
  wtime = 0;
  rtime = 0;
  csw = 0;
  if (waitx(&status, &wtime, &rtime, &csw) < 0) {
    fprintf(2, "time: waitx failed\n");
    exit(1);
  }

  uint64 elapsed = wtime + rtime;
  uint64 pct = (elapsed > 0) ? ((rtime * 100) / elapsed) : 0;

  printf("\n--- Benchmark: %s (PID %d) ---\n", argv[1], pid);
  printf("Elapsed ticks:    %lu\n", elapsed);
  if (rtime > 0 && pct == 0)
    printf("CPU ticks:        %lu (<1%% CPU)\n", rtime);
  else
    printf("CPU ticks:        %lu (%lu%% CPU)\n", rtime, pct);
  printf("Wait ticks:       %lu\n", wtime);
  printf("Context switches: %lu\n", csw);
  printf("Exit status:      %d\n", status);
  exit(0);
}
