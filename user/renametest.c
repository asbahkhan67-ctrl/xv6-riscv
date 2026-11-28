// renametest - Verify dynamic process naming (setprocname), runtime name
// retrieval (getprocname), and lookup by name (findproc).

#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/param.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  const char *newname = (argc >= 2) ? argv[1] : "nexus_worker";
  char check[16];
  int pids[NPROC];
  int me = getpid();

  printf("renametest (PID %d): before setprocname()\n", me);
  ps();

  if (setprocname(newname) < 0) {
    printf("renametest: setprocname failed\n");
    exit(1);
  }

<<<<<<< HEAD
  printf("\nrenametest (PID %d): after setprocname(\"%s\")\n", getpid(),
         newname);
=======
  memset(check, 0, sizeof(check));
  if (getprocname(0, check, sizeof(check)) < 0 || strcmp(check, newname) != 0) {
    printf("renametest: getprocname verification failed ('%s')\n", check);
    exit(1);
  }

  int found = findproc(newname, pids, NPROC);
  int matched = 0;
  for (int i = 0; i < found && i < NPROC; i++) {
    if (pids[i] == me)
      matched = 1;
  }
  if (!matched) {
    printf("renametest: findproc('%s') did not find PID %d\n", newname, me);
    exit(1);
  }

  printf(
    "\nrenametest (PID %d): renamed to \"%s\" (verified via getprocname & findproc)\n",
    me, check);
>>>>>>> bc531db (Implemented modules 11-15)
  ps();

  printf("renametest: ALL TESTS PASSED\n");
  exit(0);
}
