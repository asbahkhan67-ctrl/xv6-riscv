#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  int pid1, pid2, i;

  printf("yieldtest: starting cooperative CPU yield test\n");

  pid1 = fork();
  if(pid1 < 0){
    printf("yieldtest: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
    for(i = 1; i <= 3; i++){
      printf("Worker A (PID %d): step %d -> sched_yield()\n", getpid(), i);
      sched_yield();
    }
    exit(0);
  }

  pid2 = fork();
  if(pid2 < 0){
    wait(0);
    printf("yieldtest: second fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
    for(i = 1; i <= 3; i++){
      printf("Worker B (PID %d): step %d -> sched_yield()\n", getpid(), i);
      sched_yield();
    }
    exit(0);
  }

  wait(0);
  wait(0);
  printf("yieldtest: ALL TESTS PASSED\n");
  exit(0);
}
