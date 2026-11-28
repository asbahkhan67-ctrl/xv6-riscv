// cpuinfo - Inspect executing RISC-V harts (getcpuid) and verify soft CPU
// core affinity pinning via setaffinity(pid, hart_mask).

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  int i, pid;
  int online_mask = setaffinity(0, 0);

  if (online_mask <= 0) {
    printf("cpuinfo: setaffinity query failed\n");
    exit(1);
  }

  printf("Parent (PID %d) running on RISC-V hart %d (online mask=0x%x)\n",
         getpid(), getcpuid(), online_mask);

  // Reject impossible hart mask cleanly.
  if (setaffinity(0, 0x8000ULL) != -1) {
    printf("cpuinfo: FAIL - invalid hart mask was accepted\n");
    exit(1);
  }

  for (i = 0; i < 3; i++) {
    uint64 target_mask = 1ULL << i;
    if ((online_mask & (int)target_mask) == 0)
      continue;

    pid = fork();
    if (pid < 0) {
      printf("cpuinfo: fork failed\n");
      exit(1);
    }
    if (pid == 0) {
      if (setaffinity(0, target_mask) < 0) {
        printf("cpuinfo: worker %d setaffinity failed\n", i);
        exit(1);
      }
      int hart = getcpuid();
      printf("Worker %d (PID %d, mask=0x%lx) executing on RISC-V hart %d\n", i,
             getpid(), target_mask, hart);
      if (hart != i) {
        printf("cpuinfo: FAIL - expected hart %d, got %d\n", i, hart);
        exit(1);
      }
      exit(0);
    }

    int st = 0;
    wait(&st);
    if (st != 0) {
      printf("cpuinfo: FAIL - worker %d failed\n", i);
      exit(1);
    }
  }

  printf("cpuinfo: ALL TESTS PASSED\n");
  exit(0);
}
