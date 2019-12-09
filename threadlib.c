#include "types.h"
#include "stat.h"
#include "fcntl.h"
#include "user.h"
#include "x86.h"
#include "threadlib.h"
#include "mmu.h"
#include "spinlock.h"

struct lock_t lock;

void thread_create(void *(*start_routine)(void*), void *arg){

  void *stack = malloc(PGSIZE*2);//allocate a block of memory for stack of thread
  if((uint)stack % PGSIZE)
      stack = stack + (PGSIZE - (uint)stack % PGSIZE);
  int id;
  id = clone(stack, PGSIZE*2);
  // id == 0 means this process is a thread
  if(id == 0){
    (*start_routine)(arg);
    free(stack);
    exit();
  }

}

// initiate a lock
void lock_init(struct lock_t *lk){
    lk->locked = 0;
}

void lock_acquire(struct lock_t *lk){
  while(xchg(&lk->locked, 1) != 0);//atmoic language
}

void lock_release(struct lock_t *lk){
  xchg(&lk->locked, 0);
}