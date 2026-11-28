// ls - List files and directories (displays T_SYMLINK targets as name -> target).

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

static char *
fmtname(char *path)
{
  static char buf[DIRSIZ + 1];
  char *p;

  for (p = path + strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  if (strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  buf[sizeof(buf) - 1] = '\0';
  return buf;
}

static void
print_entry(char *path, struct stat *st)
{
  if (st->type == T_SYMLINK) {
    char target[128];
    int n = readlink(path, target, sizeof(target));
    if (n >= 0) {
      printf("%s -> %s  %d %d %d\n", fmtname(path), target, st->type, st->ino,
             (int)st->size);
      return;
    }
  }
  printf("%s %d %d %d\n", fmtname(path), st->type, st->ino, (int)st->size);
}

static int
stat_nofollow(const char *path, struct stat *st)
{
  int fd = open(path, O_RDONLY | O_NOFOLLOW);
  if (fd < 0)
    return -1;
  int r = fstat(fd, st);
  close(fd);
  return r;
}

void
ls(char *path)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if ((fd = open(path, O_RDONLY | O_NOFOLLOW)) < 0) {
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if (fstat(fd, &st) < 0) {
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch (st.type) {
  case T_DEVICE:
  case T_FILE:
  case T_SYMLINK:
    print_entry(path, &st);
    break;

  case T_DIR:
    if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
      printf("ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf + strlen(buf);
    *p++ = '/';
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
      if (de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if (stat_nofollow(buf, &st) < 0) {
        printf("ls: cannot stat %s\n", buf);
        continue;
      }
      print_entry(buf, &st);
    }
    break;
  }
  close(fd);
}

int
main(int argc, char *argv[])
{
  int i;

  if (argc < 2) {
    ls(".");
    exit(0);
  }
  for (i = 1; i < argc; i++)
    ls(argv[i]);
  exit(0);
}
