#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int i;
  uint64 mask;
  char *nargv[MAXARG];

  if(argc < 3){
    fprintf(2, "Usage: strace <mask|-a> <command> [args...]\n");
    exit(1);
  }

  if(strcmp(argv[1], "-a") == 0){
    mask = ~(uint64)0;
  } else if(argv[1][0] >= '0' && argv[1][0] <= '9'){
    mask = (uint64)atoi(argv[1]);
  } else {
    fprintf(2, "Usage: strace <mask|-a> <command> [args...]\n");
    exit(1);
  }

  if(trace(mask) < 0){
    fprintf(2, "strace: trace failed\n");
    exit(1);
  }

  for(i = 2; i < argc && i - 2 < MAXARG - 1; i++){
    nargv[i - 2] = argv[i];
  }
  nargv[i - 2] = 0;

  exec(nargv[0], nargv);
  fprintf(2, "strace: exec %s failed\n", nargv[0]);
  exit(1);
}
