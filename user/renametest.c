#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  const char *newname = (argc >= 2) ? argv[1] : "nexus_worker";

  printf("renametest (PID %d): before setprocname()\n", getpid());
  ps();

  if(setprocname(newname) < 0){
    printf("renametest: setprocname failed\n");
    exit(1);
  }

  printf("\nrenametest (PID %d): after setprocname(\"%s\")\n", getpid(), newname);
  ps();

  printf("renametest: ALL TESTS PASSED\n");
  exit(0);
}
