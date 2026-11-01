#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int pid, before, after, count, i;

  if(argc == 2){
    pid = atoi(argv[1]);
    count = getsyscallcount(pid);
    if(count < 0){
      printf("syscount: process %d not found\n", pid);
      exit(1);
    }
    printf("Process %d total syscalls: %d\n", pid, count);
    exit(0);
  }

  before = getsyscallcount(0);
  for(i = 0; i < 5; i++){
    getpid();
  }
  after = getsyscallcount(0);

  printf("PID %d syscall count before 5x getpid(): %d\n", getpid(), before);
  printf("PID %d syscall count after  5x getpid(): %d\n", getpid(), after);
  exit(0);
}
