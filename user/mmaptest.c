// mmaptest - Demonstrates lazy demand-paged mmap() and munmap():
//   1. MAP_SHARED: edits in memory are saved back to the file on munmap().
//   2. MAP_PRIVATE: edits stay private and do NOT change the file on disk.
//   3. MAP_ANONYMOUS: allocates zero-filled memory without any file on disk.

#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "kernel/param.h"
#include "user/user.h"

static void
fail(const char *msg)
{
  printf("mmaptest: FAIL - %s\n", msg);
  unlink("mmapfile");
  exit(1);
}

// Test 1: MAP_SHARED loads from disk on demand and writes changes back.
static void
test_map_shared(void)
{
  int fd;
  char *p;
  char buf[8];

  fd = open("mmapfile", O_CREATE | O_RDWR);
  if (fd < 0)
    fail("open mmapfile failed");

  if (write(fd, "hello", 5) != 5)
    fail("write initial file data failed");

  p = mmap(0, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if (p == (char *)-1)
    fail("MAP_SHARED mmap failed");

  printf("[Test 1] MAP_SHARED mapped at %p\n", p);
  if (p[0] != 'h')
    fail("MAP_SHARED initial read mismatch");

  p[0] = 'H';
  if (munmap(p, 4096) < 0)
    fail("MAP_SHARED munmap failed");
  close(fd);

  fd = open("mmapfile", O_RDONLY);
  if (fd < 0)
    fail("reopen after MAP_SHARED failed");

  memset(buf, 0, sizeof(buf));
  if (read(fd, buf, 5) != 5)
    fail("readback after MAP_SHARED failed");
  close(fd);

  if (buf[0] != 'H')
    fail("MAP_SHARED writeback did not persist to disk");

  printf("         Edited 'hello' -> '%s' (saved to disk on munmap)\n", buf);
}

// Test 2: MAP_PRIVATE isolates memory edits from the backing file.
static void
test_map_private(void)
{
  int fd;
  char *p;
  char buf[8];

  fd = open("mmapfile", O_RDWR);
  if (fd < 0)
    fail("open for MAP_PRIVATE failed");

  p = mmap(0, 4096, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
  if (p == (char *)-1)
    fail("MAP_PRIVATE mmap failed");

  printf("[Test 2] MAP_PRIVATE mapped at %p\n", p);
  if (p[0] != 'H')
    fail("MAP_PRIVATE read mismatch");

  p[0] = 'X';
  if (munmap(p, 4096) < 0)
    fail("MAP_PRIVATE munmap failed");
  close(fd);

  // Confirm the file on disk still says "Hello", not "Xello".
  fd = open("mmapfile", O_RDONLY);
  if (fd < 0)
    fail("reopen after MAP_PRIVATE failed");

  memset(buf, 0, sizeof(buf));
  if (read(fd, buf, 5) != 5)
    fail("readback after MAP_PRIVATE failed");
  close(fd);

  if (buf[0] != 'H')
    fail("MAP_PRIVATE unexpectedly modified file on disk");

<<<<<<< HEAD
<<<<<<< HEAD
  printf("         Changed memory to 'Xello', disk still has '%s' (isolated)\n", buf);
=======
  printf("         Changed memory to 'Xello', disk still has '%s' (isolated)\n",
         buf);
>>>>>>> b8719fe (updated project)
=======
  printf("         Changed memory to 'Xello', disk still has '%s' (isolated)\n",
         buf);
>>>>>>> bc531db (Implemented modules 11-15)
}

// Test 3: MAP_ANONYMOUS allocates zero-filled pages with no backing file.
static void
test_map_anonymous(void)
{
<<<<<<< HEAD
<<<<<<< HEAD
  char *p = mmap(0, 8192, PROT_READ | PROT_WRITE,
                 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
=======
  char *p =
    mmap(0, 8192, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>>>>>>> b8719fe (updated project)
=======
  char *p =
    mmap(0, 8192, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>>>>>>> bc531db (Implemented modules 11-15)
  if (p == (char *)-1)
    fail("MAP_ANONYMOUS mmap failed");

  printf("[Test 3] MAP_ANONYMOUS (2 pages) mapped at %p\n", p);

  // Both pages must start zero-filled on first touch.
  if (p[0] != 0 || p[4095] != 0 || p[4096] != 0 || p[8191] != 0)
    fail("MAP_ANONYMOUS pages were not zero-filled");

  p[0] = 'N';
  p[4096] = 'X';
  if (p[0] != 'N' || p[4096] != 'X')
    fail("MAP_ANONYMOUS read/write verification failed");

  if (munmap(p, 8192) < 0)
    fail("MAP_ANONYMOUS munmap failed");

  printf("         Verified 8 KB zero-filled memory without a disk file\n");
}

int
main(void)
{
  printf("mmaptest: starting memory-mapping verification\n");
  test_map_shared();
  test_map_private();
  test_map_anonymous();
  unlink("mmapfile");
  printf("mmaptest: ALL TESTS PASSED\n");
  exit(0);
}
