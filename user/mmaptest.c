#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "kernel/param.h"
#include "user/user.h"

int
main(void)
{
  int fd;
  int fd2;
  char *p;
  char buf[8];

  printf("mmaptest: starting\n");

  fd = open("mmapfile", O_CREATE | O_RDWR);

  if(fd < 0){
    printf("mmaptest: open failed\n");
    exit(1);
  }

  if(write(fd, "hello", 5) != 5){
    printf("mmaptest: write failed\n");
    close(fd);
    exit(1);
  }

  p = mmap(0, 4096, PROT_READ | PROT_WRITE,
           MAP_SHARED, fd, 0);

  if(p == (char *)-1){
    printf("mmaptest: shared mmap failed\n");
    close(fd);
    exit(1);
  }

  printf("mmaptest: mapped address %p\n", p);

  if(p[0] != 'h'){
    printf("mmaptest: file data incorrect: %c\n", p[0]);
    exit(1);
  }

  p[0] = 'H';

  if(munmap(p, 4096) < 0){
    printf("mmaptest: shared munmap failed\n");
    exit(1);
  }

  close(fd);

  fd2 = open("mmapfile", O_RDONLY);

  if(fd2 < 0){
    printf("mmaptest: reopen failed\n");
    exit(1);
  }

  memset(buf, 0, sizeof(buf));

  if(read(fd2, buf, 5) != 5){
    printf("mmaptest: readback failed\n");
    exit(1);
  }

  if(buf[0] != 'H'){
    printf("mmaptest: shared writeback failed: %c\n", buf[0]);
    exit(1);
  }

  close(fd2);

  fd = open("mmapfile", O_RDWR);

  if(fd < 0){
    printf("mmaptest: second open failed\n");
    exit(1);
  }

  p = mmap(0, 4096, PROT_READ | PROT_WRITE,
           MAP_PRIVATE, fd, 0);

  if(p == (char *)-1){
    printf("mmaptest: private mmap failed\n");
    exit(1);
  }

  if(p[0] != 'H'){
    printf("mmaptest: private read failed\n");
    exit(1);
  }

  p[0] = 'X';

  if(munmap(p, 4096) < 0){
    printf("mmaptest: private munmap failed\n");
    exit(1);
  }

  close(fd);

  printf("mmaptest: ALL TESTS PASSED\n");

  unlink("mmapfile");
  exit(0);
}