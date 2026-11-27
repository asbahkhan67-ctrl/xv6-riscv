// agetest - Verify anti-starvation priority aging and runtime setaging() tuning.
// Usage:
//   agetest              Run full aging & starvation-prevention verification
//   agetest get          Show current aging threshold (in ticks)
//   agetest set <ticks>  Set aging threshold at runtime (1..1000 ticks)

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define NHOGS 4

static int
is_digits(const char *s)
{
  if (s == 0 || *s == '\0')
    return 0;
  for (; *s; s++) {
    if (*s < '0' || *s > '9')
      return 0;
  }
  return 1;
}

static void
fail(const char *msg)
{
  printf("agetest: FAIL - %s\n", msg);
  exit(1);
}

static void
test_setaging(void)
{
  int orig = setaging(0);
  if (orig <= 0)
    fail("setaging(0) failed to return current threshold");

  if (setaging(-1) != -1 || setaging(5000) != -1)
    fail("setaging accepted out-of-range threshold");

  if (setaging(5) != orig)
    fail("setaging(5) did not return previous threshold");

  if (setaging(orig) != 5)
    fail("setaging restore check failed");

  printf("[Test 1] Runtime setaging() verified (current threshold: %d ticks)\n",
         orig);
}

static void
test_starvation_prevention(void)
{
  int hogs[NHOGS];
  int lowpid;
  int i, pid;
  volatile uint64 work;

  printf("[Test 2] Starting %d high-priority hogs (prio 3) and 1 low-priority worker (prio 20)\n",
         NHOGS);

  for (i = 0; i < NHOGS; i++) {
    pid = fork();
    if (pid < 0)
      fail("hog fork failed");
    if (pid == 0) {
      setpriority(0, 3);
      for (;;) {
        for (work = 0; work < 1000000ULL; work++)
          ;
      }
    }
    setpriority(pid, 3);
    hogs[i] = pid;
  }

  lowpid = fork();
  if (lowpid < 0) {
    for (i = 0; i < NHOGS; i++)
      kill(hogs[i]);
    for (i = 0; i < NHOGS; i++)
      wait(0);
    fail("worker fork failed");
  }

  if (lowpid == 0) {
    setpriority(0, 20);
    for (work = 0; work < 5000000ULL; work++)
      ;
    exit(0);
  }
  setpriority(lowpid, 20);

  // Give parent high priority so it reaps immediately when worker exits.
  setpriority(0, 2);

  pid = wait(0);
  if (pid != lowpid)
    fail("expected low-priority worker to finish first");

  printf("         Low-priority worker (PID %d, prio 20) completed without starvation\n",
         lowpid);

  for (i = 0; i < NHOGS; i++)
    kill(hogs[i]);
  for (i = 0; i < NHOGS; i++)
    wait(0);
}

int
main(int argc, char *argv[])
{
  if (argc == 2 && strcmp(argv[1], "get") == 0) {
    printf("Current aging threshold: %d ticks\n", setaging(0));
    exit(0);
  }

  if (argc == 3 && strcmp(argv[1], "set") == 0) {
    if (!is_digits(argv[2])) {
      printf("agetest: invalid tick value '%s'\n", argv[2]);
      exit(1);
    }
    int val = atoi(argv[2]);
    if (val <= 0 || val > 1000) {
      printf("agetest: threshold must be between 1 and 1000 ticks\n");
      exit(1);
    }
    int old = setaging(val);
    printf("Aging threshold changed: %d -> %d ticks\n", old, val);
    exit(0);
  }

  if (argc != 1) {
    printf("Usage: agetest [get | set <ticks>]\n");
    exit(1);
  }

  printf("agetest: starting priority aging verification\n");
  test_setaging();
  test_starvation_prevention();
  printf("agetest: ALL TESTS PASSED\n");
  exit(0);
}
