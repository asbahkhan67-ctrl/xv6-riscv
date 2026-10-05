#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int pid;
  int priority;

  if(argc != 3){
    printf("Usage: setpriority <pid> <priority>\n");
    exit(1);
  }

  pid = atoi(argv[1]);
  priority = atoi(argv[2]);

  if(setpriority(pid, priority) < 0){
    printf("setpriority: failed\n");
    exit(1);
  }

  printf("Process %d priority set to %d\n", pid, priority);
  exit(0);
}