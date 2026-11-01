#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define NHOGS 4

int
main(void)
{
  int hogs[NHOGS];
  int lowpid;
  int i, pid;
  volatile uint64 work;

  printf("agetest: starting %d high-priority hogs (prio 3) and 1 low-priority worker (prio 20)\n", NHOGS);

  for(i = 0; i < NHOGS; i++){
    pid = fork();
    if(pid < 0){
      printf("agetest: fork failed\n");
      exit(1);
    }
    if(pid == 0){
      setpriority(getpid(), 3);
      for(;;){
        for(work = 0; work < 1000000ULL; work++)
          ;
      }
    }
    setpriority(pid, 3);
    hogs[i] = pid;
  }

  lowpid = fork();
  if(lowpid < 0){
    for(i = 0; i < NHOGS; i++)
      kill(hogs[i]);
    for(i = 0; i < NHOGS; i++)
      wait(0);
    printf("agetest: worker fork failed\n");
    exit(1);
  }

  if(lowpid == 0){
    setpriority(getpid(), 20);
    for(work = 0; work < 5000000ULL; work++)
      ;
    exit(0);
  }
  setpriority(lowpid, 20);

  // Set parent high priority so it can reap promptly once worker finishes.
  setpriority(getpid(), 2);

  pid = wait(0);
  if(pid == lowpid){
    printf("agetest: low-priority worker (PID %d, prio 20) completed without starvation\n", lowpid);
  }

  for(i = 0; i < NHOGS; i++){
    kill(hogs[i]);
  }
  for(i = 0; i < NHOGS; i++){
    wait(0);
  }

  printf("agetest: ALL TESTS PASSED\n");
  exit(0);
}
