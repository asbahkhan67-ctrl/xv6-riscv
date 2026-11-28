// free - Display system memory, shared COW pages, open files, processes, and uptime.
// Usage:
//   free      Display memory in kilobytes (KB)
//   free -m   Display memory in megabytes (MB) with usage percentage

#include "kernel/types.h"
#include "kernel/param.h"
#include "kernel/riscv.h"
#include "kernel/sysinfo.h"
#include "user/user.h"

static void
print_pct(uint64 part, uint64 total)
{
  if (total == 0) {
    printf("0%%");
    return;
  }
  uint64 pct = (part * 100) / total;
  if (part > 0 && pct == 0)
    printf("<1%%");
  else
    printf("%lu%%", pct);
}

int
main(int argc, char *argv[])
{
  struct sysinfo info;
  int mb_mode = 0;

  if (argc == 2 && strcmp(argv[1], "-m") == 0) {
    mb_mode = 1;
  } else if (argc != 1) {
    printf("Usage: free [-m]\n");
    exit(1);
  }

  if (sysinfo(&info) < 0) {
    printf("free: sysinfo failed\n");
    exit(1);
  }

  uint64 used =
    (info.totalmem >= info.freemem) ? (info.totalmem - info.freemem) : 0;
  uint64 total_pages = info.totalmem / PGSIZE;
  uint64 used_pages = used / PGSIZE;
  uint64 free_pages = info.freemem / PGSIZE;

  if (mb_mode) {
    uint64 half_mb = 512ULL * 1024ULL;
    uint64 one_mb = 1024ULL * 1024ULL;
    uint64 total_mb = (info.totalmem + half_mb) / one_mb;
    uint64 used_mb = (used + half_mb) / one_mb;
    uint64 free_mb = (info.freemem + half_mb) / one_mb;

    printf("Total memory:  %lu MB (%lu pages)\n", total_mb, total_pages);
    printf("Used memory:   %lu MB (%lu pages, ", used_mb, used_pages);
    print_pct(used, info.totalmem);
    printf(")\n");
    printf("Free memory:   %lu MB (%lu pages)\n", free_mb, free_pages);
  } else {
    printf("Total memory:  %lu KB (%lu pages)\n", info.totalmem / 1024,
           total_pages);
    printf("Used memory:   %lu KB (%lu pages, ", used / 1024, used_pages);
    print_pct(used, info.totalmem);
    printf(")\n");
    printf("Free memory:   %lu KB (%lu pages)\n", info.freemem / 1024,
           free_pages);
  }

  printf("Shared COW:    %lu pages | Open files: %lu / %d\n", info.shared_pages,
         info.nfiles, NFILE);
  printf("Active procs:  %lu / %d  | Uptime: %lu ticks\n", info.nproc, NPROC,
         info.uptime);

  exit(0);
}
