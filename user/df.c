// df - Display disk block, inode, and buffer-cache usage diagnostics.
// Usage:
//   df      Show disk and inode usage
//   df -c   Include buffer-cache hits, misses, and hit rate
//   df -t   Run self-test verifying block/inode accounting

#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "kernel/statfs.h"
#include "user/user.h"

static void
print_report(const struct statfs *st, int show_cache)
{
  uint64 blk_pct = (st->total_blocks > 0)
                     ? ((uint64)st->used_blocks * 100) / st->total_blocks
                     : 0;
  uint64 ino_pct = (st->total_inodes > 0)
                     ? ((uint64)st->used_inodes * 100) / st->total_inodes
                     : 0;

  printf("Filesystem (ROOTDEV 1, block size %u B):\n", st->bsize);
  printf("Total disk:   %u KB (%u blocks: %u data, %u log)\n", st->total_blocks,
         st->total_blocks, st->data_blocks, st->log_blocks);
  printf("Used disk:    %u KB (%u blocks, %lu%%)\n", st->used_blocks,
         st->used_blocks, blk_pct);
  printf("Free disk:    %u KB (%u blocks)\n", st->free_blocks, st->free_blocks);
  printf("Inodes:       %u used / %u total (%u free, %lu%%)\n", st->used_inodes,
         st->total_inodes, st->free_inodes, ino_pct);

  if (show_cache) {
    uint64 total_io = st->bcache_hits + st->bcache_misses;
    uint64 hit_pct = (total_io > 0) ? (st->bcache_hits * 100) / total_io : 0;
    printf("Buffer cache: %lu hits / %lu misses (%lu%% hit rate)\n",
           st->bcache_hits, st->bcache_misses, hit_pct);
  }
}

static void
run_selftest(void)
{
  struct statfs before, during, after;
  char buf[512];

  if (statfs(&before) < 0) {
    printf("df: statfs failed\n");
    exit(1);
  }

  memset(buf, 'D', sizeof(buf));
  int fd = open("df_probe", O_CREATE | O_RDWR);
  if (fd < 0 || write(fd, buf, sizeof(buf)) != sizeof(buf) ||
      write(fd, buf, sizeof(buf)) != sizeof(buf)) {
    printf("df: FAIL - could not create test file\n");
    unlink("df_probe");
    exit(1);
  }
  close(fd);

  if (statfs(&during) < 0)
    exit(1);

  if (during.used_inodes != before.used_inodes + 1 ||
      during.used_blocks <= before.used_blocks) {
    printf("df: FAIL - disk/inode counts did not increase as expected\n");
    unlink("df_probe");
    exit(1);
  }

  unlink("df_probe");
  if (statfs(&after) < 0)
    exit(1);

  if (after.used_inodes != before.used_inodes) {
    printf("df: FAIL - inode count did not return to baseline\n");
    exit(1);
  }

  print_report(&after, 1);
  printf("df: ALL TESTS PASSED\n");
}

int
main(int argc, char *argv[])
{
  struct statfs st;
  int show_cache = 0;

  if (argc == 2 && strcmp(argv[1], "-t") == 0) {
    run_selftest();
    exit(0);
  } else if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    show_cache = 1;
  } else if (argc != 1) {
    printf("Usage: df [-c | -t]\n");
    exit(1);
  }

  if (statfs(&st) < 0) {
    printf("df: statfs failed\n");
    exit(1);
  }

  print_report(&st, show_cache);
  exit(0);
}
