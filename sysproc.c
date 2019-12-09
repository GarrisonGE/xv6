#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
int
sys_info(void)
{
	int param;// parameter required
	argint(0,&param);
	//1
	if(param==1)
	{
		
		return info(param);
	}
	else if(param==2)
	{
		return info(param);
	}
	else if(param==3)
	{
		return info(param);
	}
	else return info(param);
	return 0;

}
int
sys_settick(void)
{
	int tick;
	argint(0,&tick);
	return settick(tick);
}
int
sys_tickprintf(void)
{ 
  int para;
  argint(0,&para);
  if(para==0) return tickprintf(0);
  else 
  return tickprintf(1);
}
int 
sys_clone(void)
{
  void *stack;
  int size;
  argint(1, &size); 
  argptr(0, (char **)&stack, size); 
  return clone(stack,size);
}
