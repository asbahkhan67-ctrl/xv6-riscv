#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int pid, status;
  uint64 wtime, rtime;

  if(argc < 2){
    fprintf(2, "Usage: time <command> [args...]\n");
    exit(1);
  }

  pid = fork();
  if(pid < 0){
    fprintf(2, "time: fork failed\n");
    exit(1);
  }

  if(pid == 0){
    exec(argv[1], &argv[1]);
    fprintf(2, "time: exec %s failed\n", argv[1]);
    exit(1);
  }

  status = 0;
  wtime = 0;
  rtime = 0;
  if(waitx(&status, &wtime, &rtime) < 0){
    fprintf(2, "time: waitx failed\n");
    exit(1);
  }

  printf("--- Benchmark: %s (PID %d) ---\n", argv[1], pid);
  printf("Elapsed ticks: %lu\n", wtime + rtime);
  printf("CPU ticks:     %lu\n", rtime);
  printf("Wait ticks:    %lu\n", wtime);
  printf("Exit status:   %d\n", status);
  exit(0);
}
