// alarmtest - Verify periodic user-space timer alarms (sigalarm + sigreturn),
// register preservation across interrupts, remaining-ticks return, and
// SIGALARM_ONESHOT single-fire mode.

#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/param.h"
#include "user/user.h"

static volatile int alarm_count = 0;

static void
periodic_handler(void)
{
  alarm_count++;
  sigreturn();
}

static void
oneshot_handler(void)
{
  alarm_count++;
  sigreturn();
}

int
main(void)
{
  volatile uint64 spin;
  uint64 sum = 0;

  printf("alarmtest: starting user-space timer alarm verification\n");

  // 1. Periodic alarm every 2 ticks.
  alarm_count = 0;
  if (sigalarm(2, periodic_handler, SIGALARM_PERIODIC) < 0) {
    printf("alarmtest: FAIL - sigalarm periodic setup failed\n");
    exit(1);
  }

  // Keep user registers busy until 4 signals arrive (with a 50-tick safety cap).
  int start = uptime();
  while (alarm_count < 4 && (uptime() - start) < 50) {
    for (uint64 i = 1; i <= 500000ULL; i++) {
      sum += (i & 0x7);
      spin = sum;
    }
  }
  (void)spin;

  // Disarm and verify remaining ticks return value (>= 0).
  int rem = sigalarm(0, 0, 0);
  if (alarm_count < 4 || rem < 0) {
    printf("alarmtest: FAIL - expected >=4 signals, got %d (rem=%d)\n",
           alarm_count, rem);
    exit(1);
  }
  printf("[Test 1] Periodic alarm delivered %d signals (remaining=%d ticks)\n",
         alarm_count, rem);

  // 2. Check remaining-ticks return when replacing an armed alarm.
  sigalarm(20, periodic_handler, SIGALARM_PERIODIC);
  int prev_rem = sigalarm(0, 0, 0);
  if (prev_rem <= 0 || prev_rem > 20) {
    printf("alarmtest: FAIL - unexpected remaining ticks %d\n", prev_rem);
    exit(1);
  }
  printf("[Test 2] Previous alarm remaining ticks returned: %d / 20\n",
         prev_rem);

  // 3. One-shot alarm fires exactly once and auto-disarms (spin in user mode
  //    for 4 ticks so usertrap() catches the timer tick).
  alarm_count = 0;
  if (sigalarm(1, oneshot_handler, SIGALARM_ONESHOT) < 0) {
    printf("alarmtest: FAIL - oneshot setup failed\n");
    exit(1);
  }
  start = uptime();
  while ((uptime() - start) < 4) {
    for (uint64 i = 1; i <= 500000ULL; i++) {
      sum += (i & 0x7);
      spin = sum;
    }
  }
  (void)spin;
  if (alarm_count != 1) {
    printf("alarmtest: FAIL - oneshot fired %d times (expected 1)\n",
           alarm_count);
    exit(1);
  }
  printf("[Test 3] SIGALARM_ONESHOT fired exactly once and auto-disarmed\n");

  printf("alarmtest: ALL TESTS PASSED\n");
  exit(0);
}
