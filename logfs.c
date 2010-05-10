#include "types.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "buf.h"
#include "fs.h"
#include "fsvar.h"
#include "file.h"
#include "fcntl.h"
#include "dev.h"

#define min(a, b) ((a) < (b) ? (a) : (b))

struct buf *bp[20];
uint b_index;

struct trans_start{
  uint state;
  uint num_blks;
  uint sector[20];
};

#define READY 0
#define LOGGING 1
#define LOGGED 2

static void
printblock(uchar *p)
{
  int i;

  for(i=0;i<512;i++){
    cprintf("%x", p[i]);
    if(!((i+1)%32)) cprintf("\n");
  }
}

static void
log_start()
{
  struct inode *ip;
  int i;
  struct trans_start start;
  uint state = LOGGING;

  ip = iget(1, 3);
  ilock(ip);
  start.state = READY;
  start.num_blks = b_index;
  for(i=0;i<b_index;i++){
    start.sector[i] = bp[i]->sector;
  }

  writei(ip, &start, 0, sizeof(start));

  for(i=0;i<b_index;i++){
    writei(ip, bp[i]->data, (i*512) + 512, sizeof(bp[i]->data));
  }

  writei(ip, &state, 0, sizeof(state));

  iunlock(ip);
}

static void
log_end()
{
  uint state = LOGGED;
  struct inode *ip;
  ip = iget(1, 3);
  ilock(ip);
  writei(ip, &state, 0, sizeof(state));
  iunlock(ip);
}

void
log_initialize()
{
  struct inode *ip;
  uchar buffer[512];
  int i, j;
  struct buf *bp;
  struct trans_start t_blk;

  for(j=0;j<512;j++)
    buffer[j] = 0;

  ip = iget(1, 3);
  ilock(ip);
  if(ip->size < 512*20){
    cprintf("Creating Journal...\n");
    for(i=0;i<20;i++){
      writei(ip, buffer, i*512, sizeof(buffer));
    }
  }
  else {
    readi(ip, &t_blk, 0, sizeof(t_blk));

    if(t_blk.state == LOGGING){
      cprintf("Inconsistency found in file system. Attempting to recover.\n");

      for(i = 0; i < t_blk.num_blks; i++){
    	  readi(ip, buffer, i*512+512, sizeof(buffer));
    	  bp = bread(1, t_blk.sector[i]);
    	  cprintf("Recovering data in sector: %d\n", t_blk.sector[i]);
    	  memmove(bp->data, buffer, sizeof(buffer));
    	  bwrite(bp);
    	  brelse(bp);
      }

      writei(ip, buffer, 0, sizeof(buffer));
      cprintf("Recovery Complete.\n");
    }
  }

  iunlock(ip);
}


static uint
log_balloc(uint dev)
{
  int b, bi, m, i;
  struct superblock sb;

  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    for(i = 0; i < b_index; i++)
      if(bp[i]->sector == BBLOCK(b, sb.ninodes)) {
	for(bi = 0; bi < BPB; bi++){
	  m = 1 << (bi % 8);
	  if((bp[i]->data[bi/8] & m) == 0){
	    bp[i]->data[bi/8] |= m;
	    return b + bi;
	  }
	}
      }

    bp[b_index] = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB; bi++){
      m = 1 << (bi % 8);
      if((bp[b_index]->data[bi/8] & m) == 0){
	bp[b_index]->data[bi/8] |= m;
	b_index++;
	return b + bi;
      }
    }
    brelse(bp[b_index]);
  }
  panic("balloc: out of blocks");
}

uint
log_lookup(struct inode *ip, uint bn)
{
  uchar found = 0;
  int i;
  uint addr, *a;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0){
      panic("FS failure");
    }
    return addr;
  }
  bn -= NDIRECT;
  if(bn < (NINDIRECT * NINDIRECT)){
    if((addr = ip->addrs[INDIRECT]) == 0){
      panic("FS failure");
    }
    for(i = 0; i < b_index; i++){
      if(bp[i]->sector == addr){
	found = 1;
	a = (uint*)bp[i]->data;
	if((addr = a[(bn / NINDIRECT)]) == 0){
	  panic("fs fail");
	}
	break;
      }
    }
    if(!found) panic("FS failure");
    found = 0;
    for(i = 0;i < b_index; i++){
      if(bp[i]->sector == addr){
	found = 1;
	a = (uint*)bp[i]->data;
	if((addr = a[(bn % NINDIRECT)]) == 0){
	  panic("FS failure");
	}
	break;
      }
    }
    if(!found)    panic("FS failure");

    return addr;
  }

  panic("bmap: out of range");

}

uint
log_bmap(struct inode *ip, uint bn)
{
  uchar found;
  int i;
  uint addr, *a;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0){
      ip->addrs[bn] = addr = log_balloc(ip->dev);
    }
    return addr;
  }
  bn -= NDIRECT;
  if(bn < (NINDIRECT * NINDIRECT)){

    // Load double indirect block, allocating if necessary.
    if((addr = ip->addrs[INDIRECT]) == 0){
      ip->addrs[INDIRECT] = addr = log_balloc(ip->dev);
    }
    // check dirty blocks
    found = 0;
    for(i = 0; i < b_index; i++){
      if(bp[i]->sector == addr){
	found = 1;
	a = (uint*)bp[i]->data;
	if((addr = a[(bn / NINDIRECT)]) == 0){
	  a[(bn / NINDIRECT)] = addr = log_balloc(ip->dev);
	}
	break;
      }
    }
    if(!found){
      // load new block from mem

      bp[b_index] = bread(ip->dev, addr);
      a = (uint*)bp[b_index]->data;

      b_index++;
      if((addr = a[(bn / NINDIRECT)]) == 0){
	a[(bn / NINDIRECT)] = addr = log_balloc(ip->dev);
      }
    }
    found = 0;
    for(i = 0;i < b_index; i++){
      if(bp[i]->sector == addr){
	found = 1;
	a = (uint*)bp[i]->data;
	if((addr = a[(bn % NINDIRECT)]) == 0){
	  a[(bn % NINDIRECT)] = addr = log_balloc(ip->dev);
	}
	break;
      }
    }
    if(!found){
      // load new block
      bp[b_index] = bread(ip->dev, addr);
      a = (uint*)bp[b_index]->data;

      b_index++;
      if((addr = a[(bn % NINDIRECT)]) == 0){
	a[(bn % NINDIRECT)] = addr = log_balloc(ip->dev);
      }
    }

    return addr;
  }

  panic("bmap: out of range");
}

void
log_iupdate(struct inode *ip)
{
  struct dinode *dip;
  bp[b_index] = bread(ip->dev, IBLOCK(ip->inum));
  dip = (struct dinode*)bp[b_index]->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  b_index++;
}

int
log_writei(struct inode *ip, char *src, uint off, uint n)
{
  uint tot, m, i, j;
  struct buf *tbp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;


  b_index = 0; // new xfer, start keeping track of open bufs

  /* allocate all space needed */
  for(i=0, j=off; i<n; i+=m, j+=m){
    log_bmap(ip, j/BSIZE);
    m = min(n - i, BSIZE - j%BSIZE);
  }

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp[b_index] = bread(ip->dev, log_lookup(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp[b_index]->data + off%BSIZE, src, m);
    b_index++;
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
    log_iupdate(ip);
  }

  log_start();
  for(i = 0; i < b_index; i++){
    bwrite(bp[i]);
    brelse(bp[i]);
  }

  log_end();

  return n;

}

void
start_trans_man_action()
{
  b_index = 0;
}

void
end_trans_man_action()
{
  int i;
  log_start();
  for(i = 0; i < b_index; i++){
    bwrite(bp[i]);
    brelse(bp[i]);
  }

  log_end();
}
