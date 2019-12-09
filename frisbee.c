#include "types.h"
#include "stat.h"
#include "user.h"
#include "threadlib.h"





struct lock_t *lock;
static int pass =0; //pass value right now
static int numofthread;//the number of thread we what create
static int round;// the total round that we want
static int turn=0;//define the turn of thread


void* frisbee();

int main ( int argc , char * argv []){
    
    if(argc != 3){
        printf(1, "You need to input the number of threads and rounds\n");
        printf(1,"argc:%d\n",argc);
        exit();
    }

    
    numofthread =atoi(argv[1]);
    round = atoi(argv[2]);
    
    int i = 0;
    
    lock_init(lock);//initiate lock.
    for(i=0;i<numofthread;i++){
        thread_create(frisbee,(void *)i);
    }
    for(i = 0; i < numofthread; i++){
        wait();
    }
    printf(1,"Simulation of Frisbee game has finished, %d rounds were played in total!\n", round);
    exit();

}

void* frisbee(void *arg){

    int pidnum = (int)arg; // each thread has a unique pid
 
    while(pass < round)//running until pass is beyond round
    {
        lock_acquire(lock);//acquire for the lock
        
        if(pass==round){
            sleep(1);
            break;
        }
        if(numofthread == 0)
            break;
        if(pidnum == turn){
            pass++;
            printf(2,"(%d)pass number no:%d, Thread %d is passing the token to ",numofthread,pass,pidnum);
            
            // pass to next thread
            turn = pidnum + 1;
            if(turn ==  numofthread) 
                turn = 0;

            printf(1,"thread %d\n",turn);
            sleep(1);
            lock_release(lock);
            sleep(1);
        }else{
            printf(1,"This is not the turn of thread no:%d\n", pidnum);
            lock_release(lock);
            sleep(1);
        }
    }
    
    lock_release(lock);//release the lock
    exit();

}
