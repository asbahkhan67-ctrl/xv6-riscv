struct sysinfo {
  uint64 freemem;  // Free physical memory (bytes)
  uint64 totalmem; // Total managed physical memory (bytes)
  uint64 nproc;    // Number of active processes
  uint64 uptime;   // Ticks since boot
};
