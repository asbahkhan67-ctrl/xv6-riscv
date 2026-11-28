// ln - Create a hard link or a symbolic link (-s).
// Usage:
//   ln old new            Create a hard link
//   ln -s target link     Create a symbolic link

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if (argc == 4 && strcmp(argv[1], "-s") == 0) {
    if (symlink(argv[2], argv[3]) < 0) {
      fprintf(2, "ln: symlink %s -> %s failed\n", argv[3], argv[2]);
      exit(1);
    }
    exit(0);
  }

  if (argc != 3) {
    fprintf(2, "Usage: ln old new  OR  ln -s target link\n");
    exit(1);
  }

  if (link(argv[1], argv[2]) < 0) {
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
    exit(1);
  }
  exit(0);
}
