#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  int i, pid;
  volatile int spin;

  printf("Parent (PID %d) running on RISC-V hart %d\n", getpid(), getcpuid());

  for(i = 0; i < 3; i++){
    pid = fork();
    if(pid < 0){
      printf("cpuinfo: fork failed\n");
      exit(1);
    }
    if(pid == 0){
      for(spin = 0; spin < 500000; spin++)
        ;
      printf("Worker %d (PID %d) executing on RISC-V hart %d\n",
             i, getpid(), getcpuid());
      exit(0);
    }
  }

  for(i = 0; i < 3; i++){
    wait(0);
  }

  exit(0);
}
