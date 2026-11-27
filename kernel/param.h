#define NPROC           64  // maximum number of processes
#define NCPU            8   // maximum number of CPUs
#define NOFILE          16  // open files per process
#define NFILE           100 // open files per system
#define NINODE          50  // maximum number of active i-nodes
#define NDEV            10  // maximum major device number
#define ROOTDEV         1   // device number of file system root disk
#define MAXARG          32  // max exec arguments
#define MAXOPBLOCKS     10  // max # of blocks any FS op writes
#define LOGBLOCKS       (MAXOPBLOCKS * 3) // max data blocks in on-disk log
#define NBUF            (MAXOPBLOCKS * 3) // size of disk block cache
#define FSSIZE          4000              // size of file system in blocks
#define MAXPATH         128               // maximum file path name
#define USERSTACK       1                 // user stack pages
<<<<<<< HEAD
<<<<<<< HEAD
#define AGING_THRESHOLD 10                // ticks before priority aging boost
#define PRIO_MIN        1                 // highest scheduling priority
#define PRIO_DEFAULT    10                // default process priority
#define PRIO_MAX        20                // lowest scheduling priority
=======
#define AGING_THRESHOLD 10                // default ticks before priority aging boost
#define PRIO_MIN        1                 // highest scheduling priority
#define PRIO_DEFAULT    10                // default process priority
#define PRIO_MAX        20                // lowest scheduling priority
#define MAX_SYSCALLS    48                // max syscall slots tracked for per-call stats

#define TRACE_ERRORS    0x1               // strace -e: log only failing syscalls (ret < 0)
#define TRACE_SUMMARY   0x2               // strace -c: print call & error summary on exit
>>>>>>> e18456e (Updated xv6-riscv)

#define PROT_READ       0x1
#define PROT_WRITE      0x2

#define MAP_SHARED      0x1
#define MAP_PRIVATE     0x2
#define MAP_ANONYMOUS   0x4               // zero-filled mapping without a file
=======
#define AGING_THRESHOLD 10 // default ticks before priority aging boost
#define PRIO_MIN        1  // highest scheduling priority
#define PRIO_DEFAULT    10 // default process priority
#define PRIO_MAX        20 // lowest scheduling priority
#define MAX_SYSCALLS    48 // max syscall slots tracked for per-call stats

#define TRACE_ERRORS  0x1 // strace -e: log only failing syscalls (ret < 0)
#define TRACE_SUMMARY 0x2 // strace -c: print call & error summary on exit

#define PROT_READ  0x1
#define PROT_WRITE 0x2

#define MAP_SHARED    0x1
#define MAP_PRIVATE   0x2
#define MAP_ANONYMOUS 0x4 // zero-filled mapping without a file
>>>>>>> b8719fe (updated project)
