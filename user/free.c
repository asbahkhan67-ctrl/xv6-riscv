#include "kernel/types.h"
#include "kernel/param.h"
#include "kernel/riscv.h"
#include "kernel/sysinfo.h"
#include "user/user.h"

int
main(void)
{
  struct sysinfo info;
  uint64 used;

  if(sysinfo(&info) < 0){
    printf("free: sysinfo failed\n");
    exit(1);
  }

  used = (info.totalmem >= info.freemem) ? (info.totalmem - info.freemem) : 0;

  printf("Total memory:  %lu KB (%lu pages)\n", info.totalmem / 1024, info.totalmem / PGSIZE);
  printf("Used memory:   %lu KB (%lu pages)\n", used / 1024, used / PGSIZE);
  printf("Free memory:   %lu KB (%lu pages)\n", info.freemem / 1024, info.freemem / PGSIZE);
  printf("Active procs:  %lu / %d\n", info.nproc, NPROC);
  printf("System uptime: %lu ticks\n", info.uptime);

  exit(0);
}
