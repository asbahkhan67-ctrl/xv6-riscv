// ps - Display a formatted table of all active processes, including priority,
// user/kernel CPU ticks, memory footprint (KB), state, and process name.

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
  ps();
  exit(0);
}
