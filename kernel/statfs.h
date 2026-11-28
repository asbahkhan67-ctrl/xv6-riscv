struct statfs {
  uint bsize;           // Block size in bytes (BSIZE = 1024)
  uint total_blocks;    // Total blocks in filesystem
  uint data_blocks;     // Total data blocks
  uint log_blocks;      // Log blocks
  uint used_blocks;     // Allocated blocks in bitmap
  uint free_blocks;     // Free blocks in bitmap
  uint total_inodes;    // Total on-disk inodes (excluding ino 0)
  uint used_inodes;     // Allocated on-disk inodes
  uint free_inodes;     // Free on-disk inodes
  uint64 bcache_hits;   // Buffer cache hits
  uint64 bcache_misses; // Buffer cache disk-read misses
};
