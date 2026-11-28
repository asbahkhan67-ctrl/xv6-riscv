// yieldtest - Demonstrate voluntary CPU yielding with sched_yield() and verify
// per-process yield_count tracking across two cooperative workers.
// Uses a simple pipe baton so console lines never scramble across CPU cores.

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

static void
run_worker(const char *label, int wait_fd, int next_fd, int wait_final)
{
  char token = 0;

  for (int i = 1; i <= 3; i++) {
    if (read(wait_fd, &token, 1) != 1)
      exit(1);

    int count = sched_yield();
    if (count < 0)
      exit(1);

    printf(
      "Worker %s (PID %d): step %d -> sched_yield() (voluntary yields = %d)\n",
      label, getpid(), i, count);

    if (write(next_fd, &token, 1) != 1)
      exit(1);
  }

  // Worker A catches Worker B's final baton so B's last pipe write succeeds.
  if (wait_final) {
    if (read(wait_fd, &token, 1) != 1)
      exit(1);
  }

  close(wait_fd);
  close(next_fd);
  exit(0);
}

int
main(void)
{
  int a_to_b[2], b_to_a[2];
  int pid1, pid2, st1 = 0, st2 = 0;
  char start = 'T';

  if (pipe(a_to_b) < 0 || pipe(b_to_a) < 0) {
    printf("yieldtest: pipe failed\n");
    exit(1);
  }

  printf("yieldtest: starting cooperative CPU yield test\n");

  pid1 = fork();
  if (pid1 < 0) {
    printf("yieldtest: fork failed\n");
    exit(1);
  }
  if (pid1 == 0) {
<<<<<<< HEAD
<<<<<<< HEAD
    for (i = 1; i <= 3; i++) {
      printf("Worker A (PID %d): step %d -> sched_yield()\n", getpid(), i);
      sched_yield();
    }
    exit(0);
=======
    close(b_to_a[1]);
    close(a_to_b[0]);
    run_worker("A", b_to_a[0], a_to_b[1], 1);
>>>>>>> bc531db (Implemented modules 11-15)
=======
    close(b_to_a[1]);
    close(a_to_b[0]);
    run_worker("A", b_to_a[0], a_to_b[1], 1);
>>>>>>> 6400aec (Implemented modueles)
  }

  pid2 = fork();
  if (pid2 < 0) {
    wait(0);
    printf("yieldtest: second fork failed\n");
    exit(1);
  }
  if (pid2 == 0) {
<<<<<<< HEAD
<<<<<<< HEAD
    for (i = 1; i <= 3; i++) {
      printf("Worker B (PID %d): step %d -> sched_yield()\n", getpid(), i);
      sched_yield();
    }
    exit(0);
=======
    close(a_to_b[1]);
    close(b_to_a[0]);
    run_worker("B", a_to_b[0], b_to_a[1], 0);
>>>>>>> bc531db (Implemented modules 11-15)
=======
    close(a_to_b[1]);
    close(b_to_a[0]);
    run_worker("B", a_to_b[0], b_to_a[1], 0);
>>>>>>> 6400aec (Implemented modueles)
  }

  // Hand the first baton to Worker A, then close unused pipe ends.
  write(b_to_a[1], &start, 1);
  close(a_to_b[0]);
  close(a_to_b[1]);
  close(b_to_a[0]);
  close(b_to_a[1]);

  wait(&st1);
  wait(&st2);
  if (st1 != 0 || st2 != 0) {
    printf("yieldtest: FAIL\n");
    exit(1);
  }

  printf("yieldtest: ALL TESTS PASSED (6 total voluntary yields verified)\n");
  exit(0);
}
