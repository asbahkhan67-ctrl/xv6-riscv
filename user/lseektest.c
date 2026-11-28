// lseektest - Verify SEEK_SET, SEEK_CUR, SEEK_END, invalid offset rejection,
// and sparse seek past EOF with automatic zero-fill.

#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

static void
fail(const char *msg)
{
  printf("lseektest: FAIL - %s\n", msg);
  unlink("lseekfile");
  exit(1);
}

int
main(void)
{
  int fd;
  char buf[32];

  printf("lseektest: starting random-access file positioning test\n");

  fd = open("lseekfile", O_CREATE | O_RDWR | O_TRUNC);
  if (fd < 0)
    fail("open failed");

  if (write(fd, "0123456789ABCDEF", 16) != 16)
    fail("initial write failed");

  // 1. SEEK_SET: jump to offset 4 and patch 4 bytes.
  if (lseek(fd, 4, SEEK_SET) != 4)
    fail("SEEK_SET failed");
  if (write(fd, "WXYZ", 4) != 4)
    fail("patch write failed");
  printf("[Test 1] SEEK_SET offset 4 -> patched \"WXYZ\"\n");

  // 2. SEEK_CUR: advance +4 from current offset (8 -> 12) and read "CDEF".
  if (lseek(fd, 4, SEEK_CUR) != 12)
    fail("SEEK_CUR failed");
  memset(buf, 0, sizeof(buf));
  if (read(fd, buf, 4) != 4 || strcmp(buf, "CDEF") != 0)
    fail("SEEK_CUR read mismatch");
  printf("[Test 2] SEEK_CUR +4 (offset 12) -> read \"%s\"\n", buf);

  // 3. SEEK_END: move -12 from EOF (16 -> 4) and verify "WXYZ".
  if (lseek(fd, -12, SEEK_END) != 4)
    fail("SEEK_END failed");
  memset(buf, 0, sizeof(buf));
  if (read(fd, buf, 4) != 4 || strcmp(buf, "WXYZ") != 0)
    fail("SEEK_END read mismatch");
  printf("[Test 3] SEEK_END -12 (offset 4) -> verified \"%s\"\n", buf);

  // 4. Reject negative resulting offset.
  if (lseek(fd, -100, SEEK_SET) != -1)
    fail("negative SEEK_SET was not rejected");

  // 5. Sparse seek past EOF: jump 8 bytes past EOF and write "END!".
  if (lseek(fd, 8, SEEK_END) != 24)
    fail("sparse SEEK_END failed");
  if (write(fd, "END!", 4) != 4)
    fail("sparse write failed");

  if (lseek(fd, 16, SEEK_SET) != 16)
    fail("seek to sparse gap failed");
  memset(buf, 0x7f, sizeof(buf));
  if (read(fd, buf, 12) != 12)
    fail("read sparse gap failed");
  for (int i = 0; i < 8; i++) {
    if (buf[i] != 0)
      fail("sparse gap was not zero-filled");
  }
  if (memcmp(buf + 8, "END!", 4) != 0)
    fail("sparse tail mismatch");
  printf(
    "[Test 4] Sparse seek past EOF -> 8 zero-filled gap bytes + \"END!\" (size=28)\n");

  close(fd);
  unlink("lseekfile");
  printf("lseektest: ALL TESTS PASSED\n");
  exit(0);
}
