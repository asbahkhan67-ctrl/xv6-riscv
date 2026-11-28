// symlinktest - Verify symbolic links, readlink(), O_NOFOLLOW, chained links,
// dangling links, and cycle detection (MAXSYMLINK).

#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

static void
cleanup(void)
{
  unlink("sym_target");
  unlink("sym_link1");
  unlink("sym_link2");
  unlink("sym_cycA");
  unlink("sym_cycB");
  unlink("sym_dangling");
}

static void
fail(const char *msg)
{
  printf("symlinktest: FAIL - %s\n", msg);
  cleanup();
  exit(1);
}

int
main(void)
{
  int fd;
  char buf[64];
  struct stat st;

  cleanup();
  printf("symlinktest: starting symbolic link verification\n");

  // 1. Create target file and symlink to it.
  fd = open("sym_target", O_CREATE | O_RDWR);
  if (fd < 0 || write(fd, "nexus-link", 10) != 10)
    fail("failed to create target file");
  close(fd);

  if (symlink("sym_target", "sym_link1") < 0)
    fail("symlink sym_link1 failed");

  if (symlink("sym_link1", "sym_link2") < 0)
    fail("chained symlink sym_link2 failed");

  // 2. Opening sym_link2 follows the chain to sym_target.
  fd = open("sym_link2", O_RDONLY);
  if (fd < 0)
    fail("open chained symlink failed");
  memset(buf, 0, sizeof(buf));
  if (read(fd, buf, 10) != 10 || strcmp(buf, "nexus-link") != 0)
    fail("read through symlink mismatch");
  close(fd);
  printf(
    "[Test 1] Chained symlink sym_link2 -> sym_link1 -> sym_target read \"%s\"\n",
    buf);

  // 3. readlink() + O_NOFOLLOW inspect the raw symlink without following it.
  memset(buf, 0, sizeof(buf));
  if (readlink("sym_link1", buf, sizeof(buf)) < 0 ||
      strcmp(buf, "sym_target") != 0)
    fail("readlink mismatch");
  fd = open("sym_link1", O_RDONLY | O_NOFOLLOW);
  if (fd < 0 || fstat(fd, &st) < 0 || st.type != T_SYMLINK)
    fail("O_NOFOLLOW did not return T_SYMLINK");
  close(fd);
  printf(
    "[Test 2] readlink(\"sym_link1\") = \"%s\" (O_NOFOLLOW type=T_SYMLINK)\n",
    buf);

  // 4. Dangling symlink fails cleanly.
  if (symlink("no_such_file", "sym_dangling") < 0)
    fail("create dangling symlink failed");
  if (open("sym_dangling", O_RDONLY) >= 0)
    fail("open dangling symlink unexpectedly succeeded");
  printf("[Test 3] Dangling symlink rejected cleanly\n");

  // 5. Mutual symlink cycle is caught by MAXSYMLINK.
  if (symlink("sym_cycB", "sym_cycA") < 0 ||
      symlink("sym_cycA", "sym_cycB") < 0)
    fail("create cycle symlinks failed");
  if (open("sym_cycA", O_RDONLY) >= 0)
    fail("symlink cycle was not detected");
  printf("[Test 4] Symlink cycle caught cleanly (MAXSYMLINK guard)\n");

  cleanup();
  printf("symlinktest: ALL TESTS PASSED\n");
  exit(0);
}
