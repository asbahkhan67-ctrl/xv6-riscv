// cowtest - Demonstrates Copy-on-Write (COW) fork behavior:
//   1. Reading a shared page after fork triggers 0 new COW faults.
//   2. Writing to a shared page triggers a private copy without changing parent.
//   3. Kernel copyout() (via pipe read) also resolves COW pages safely.

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

static void
fail(const char *msg)
{
  printf("cowtest: FAIL - %s\n", msg);
  exit(1);
}

// Test 1: Reading shared memory after fork should not copy the page.
static void
test_readonly_share(void)
{
  char *page = sbrk(4096);
  if (page == SBRK_ERROR)
    fail("sbrk failed in test_readonly_share");

  *page = 'S';

  int pid = fork();
  if (pid < 0)
    fail("fork failed in test_readonly_share");

  if (pid == 0) {
    int before = getcowfaults(0);
    char seen = *page;
    int after = getcowfaults(0);

<<<<<<< HEAD
<<<<<<< HEAD
    printf("[Test 1] Child read '%c' -> new COW faults: %d (page stayed shared)\n",
           seen, after - before);
=======
    printf(
      "[Test 1] Child read '%c' -> new COW faults: %d (page stayed shared)\n",
      seen, after - before);
>>>>>>> b8719fe (updated project)
=======
    printf(
      "[Test 1] Child read '%c' -> new COW faults: %d (page stayed shared)\n",
      seen, after - before);
>>>>>>> bc531db (Implemented modules 11-15)
    if (seen != 'S' || (after - before) != 0)
      exit(1);
    exit(0);
  }

  int status = 0;
  wait(&status);
  if (status != 0)
    fail("read-only sharing check failed");
}

// Test 2: Writing to a shared page copies it privately for each child.
static void
test_write_isolation(void)
{
  char *page = sbrk(4096);
  if (page == SBRK_ERROR)
    fail("sbrk failed in test_write_isolation");

  *page = 'A';
  printf("[Test 2] Original: %c\n", *page);

  int pid1 = fork();
  if (pid1 < 0)
    fail("first fork failed");

  if (pid1 == 0) {
    int before = getcowfaults(0);
    *page = 'B';
    int after = getcowfaults(0);

<<<<<<< HEAD
<<<<<<< HEAD
    printf("         Child 1 wrote '%c' -> new COW faults: %d\n",
           *page, after - before);
=======
    printf("         Child 1 wrote '%c' -> new COW faults: %d\n", *page,
           after - before);
>>>>>>> b8719fe (updated project)
=======
    printf("         Child 1 wrote '%c' -> new COW faults: %d\n", *page,
           after - before);
>>>>>>> bc531db (Implemented modules 11-15)
    if (*page != 'B' || (after - before) < 1)
      exit(1);
    exit(0);
  }

  int status = 0;
  wait(&status);
  if (status != 0)
    fail("child 1 write isolation failed");
  printf("         After child 1: %c (parent unchanged)\n", *page);
  if (*page != 'A')
    fail("parent memory was overwritten by child 1");

  int pid2 = fork();
  if (pid2 < 0)
    fail("second fork failed");

  if (pid2 == 0) {
    int before = getcowfaults(0);
    *page = 'C';
    int after = getcowfaults(0);

<<<<<<< HEAD
<<<<<<< HEAD
    printf("         Child 2 wrote '%c' -> new COW faults: %d\n",
           *page, after - before);
=======
    printf("         Child 2 wrote '%c' -> new COW faults: %d\n", *page,
           after - before);
>>>>>>> b8719fe (updated project)
=======
    printf("         Child 2 wrote '%c' -> new COW faults: %d\n", *page,
           after - before);
>>>>>>> bc531db (Implemented modules 11-15)
    if (*page != 'C' || (after - before) < 1)
      exit(1);
    exit(0);
  }

  wait(&status);
  if (status != 0)
    fail("child 2 write isolation failed");
  printf("         After child 2: %c (parent unchanged)\n", *page);
  if (*page != 'A')
    fail("parent memory was overwritten by child 2");
}

// Test 3: Kernel copyout() into a shared COW page (via pipe read).
static void
test_copyout_cow(void)
{
  int fds[2];
  char *page = sbrk(4096);
  if (page == SBRK_ERROR)
    fail("sbrk failed in test_copyout_cow");

  *page = 'P';
  if (pipe(fds) < 0)
    fail("pipe failed");

  int pid = fork();
  if (pid < 0)
    fail("fork failed in test_copyout_cow");

  if (pid == 0) {
    close(fds[1]);
    int before = getcowfaults(0);
    if (read(fds[0], page, 1) != 1)
      exit(1);
    int after = getcowfaults(0);
    close(fds[0]);

<<<<<<< HEAD
<<<<<<< HEAD
    printf("[Test 3] Kernel copyout wrote '%c' into child -> new COW faults: %d\n",
           *page, after - before);
=======
    printf(
      "[Test 3] Kernel copyout wrote '%c' into child -> new COW faults: %d\n",
      *page, after - before);
>>>>>>> b8719fe (updated project)
=======
    printf(
      "[Test 3] Kernel copyout wrote '%c' into child -> new COW faults: %d\n",
      *page, after - before);
>>>>>>> bc531db (Implemented modules 11-15)
    if (*page != 'K' || (after - before) < 1)
      exit(1);
    exit(0);
  }

  close(fds[0]);
  char msg = 'K';
  if (write(fds[1], &msg, 1) != 1)
    fail("pipe write failed");
  close(fds[1]);

  int status = 0;
  wait(&status);
  if (status != 0 || *page != 'P')
    fail("copyout COW isolation failed");
<<<<<<< HEAD
<<<<<<< HEAD
  printf("         Parent still sees '%c' (protected from kernel copyout)\n", *page);
=======
  printf("         Parent still sees '%c' (protected from kernel copyout)\n",
         *page);
>>>>>>> b8719fe (updated project)
=======
  printf("         Parent still sees '%c' (protected from kernel copyout)\n",
         *page);
>>>>>>> bc531db (Implemented modules 11-15)
}

int
main(void)
{
  printf("cowtest: starting Copy-on-Write verification\n");
  test_readonly_share();
  test_write_isolation();
  test_copyout_cow();
  printf("cowtest: ALL TESTS PASSED\n");
  exit(0);
}
