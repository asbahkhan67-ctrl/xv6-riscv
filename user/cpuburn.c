// cpuburn - CPU-bound workload generator for demonstrating CPU tick accounting.
// Usage:
//   cpuburn            Run continuously in a busy loop (use 'cpuburn &' + 'ps')
//   cpuburn <rounds>   Run a fixed number of busy rounds and exit cleanly

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define ITERATIONS_PER_ROUND 50000000ULL

int
main(int argc, char *argv[])
{
<<<<<<< HEAD
<<<<<<< HEAD
  volatile uint64 i; // volatile prevents the compiler from optimizing the loop away
=======
  volatile uint64
    i; // volatile prevents the compiler from optimizing the loop away
>>>>>>> b8719fe (updated project)
=======
  volatile uint64
    i; // volatile prevents the compiler from optimizing the loop away
>>>>>>> bc531db (Implemented modules 11-15)
  int pid = getpid();

  if (argc >= 2) {
    int rounds = atoi(argv[1]);
    if (rounds <= 0) {
      printf("Usage: cpuburn [rounds]\n");
      exit(1);
    }

    printf("[cpuburn] PID %d running %d busy rounds...\n", pid, rounds);
    for (int r = 0; r < rounds; r++) {
      for (i = 0; i < ITERATIONS_PER_ROUND; i++)
        ;
    }
    printf("[cpuburn] PID %d finished %d rounds\n", pid, rounds);
    exit(0);
  }

  printf("[cpuburn] PID %d started (stop with 'kill %d')\n", pid, pid);
  for (;;) {
    for (i = 0; i < ITERATIONS_PER_ROUND; i++)
      ;
  }

  exit(0);
}
