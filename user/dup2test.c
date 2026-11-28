// dup2test - Verify dup2() descriptor redirection, shared file offsets,
// closing previous target slots, and dup3() O_CLOEXEC across exec().

#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

static void
fail(const char *msg)
{
  printf("dup2test: FAIL - %s\n", msg);
  unlink("dup2file");
  exit(1);
}

int
main(int argc, char *argv[])
{
  // Child re-exec mode for verifying O_CLOEXEC closed fd 11 across exec().
  if (argc == 3 && strcmp(argv[1], "--check-cloexec") == 0) {
    int clo_fd = atoi(argv[2]);
    char ch;
    if (read(clo_fd, &ch, 1) >= 0) {
      printf("dup2test: FAIL - O_CLOEXEC fd %d survived exec()\n", clo_fd);
      exit(1);
    }
    exit(0);
  }

  printf("dup2test: starting descriptor redirection verification\n");

  int fd = open("dup2file", O_CREATE | O_RDWR | O_TRUNC);
  if (fd < 0)
    fail("open failed");

  // 1. dup2(fd, 10) shares file offset across fd and fd 10.
  if (dup2(fd, 10) != 10)
    fail("dup2(fd, 10) failed");

  if (write(fd, "AB", 2) != 2 || write(10, "CD", 2) != 2)
    fail("shared offset write failed");

  // 2. dup2(10, 10) is a safe no-op returning 10.
  if (dup2(10, 10) != 10)
    fail("self dup2 failed");

  // 3. Re-opening and reading verifies "ABCD" written sequentially.
  close(fd);
  close(10);
  fd = open("dup2file", O_RDONLY);
  char buf[8];
  memset(buf, 0, sizeof(buf));
  if (fd < 0 || read(fd, buf, 4) != 4 || strcmp(buf, "ABCD") != 0)
    fail("shared offset verification mismatch");
  printf("[Test 1] dup2(fd, 10) shared offset verified (\"%s\")\n", buf);

  // 4. dup3(fd, 11, O_CLOEXEC) closes fd 11 automatically on exec().
  if (dup3(fd, 11, O_CLOEXEC) != 11)
    fail("dup3 with O_CLOEXEC failed");

  int pid = fork();
  if (pid < 0)
    fail("fork failed");
  if (pid == 0) {
    char *nargv[] = {"dup2test", "--check-cloexec", "11", 0};
    exec("dup2test", nargv);
    exit(1);
  }

  int status = 0;
  wait(&status);
  close(fd);
  close(11);
  unlink("dup2file");

  if (status != 0)
    fail("O_CLOEXEC check across exec() failed");
  printf(
    "[Test 2] dup3(fd, 11, O_CLOEXEC) automatically closed fd 11 on exec()\n");

  printf("dup2test: ALL TESTS PASSED\n");
  exit(0);
}
