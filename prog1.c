#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
	settick(30);
	int i,k;
	const int loop=40000;
	for(i=0;i<loop;i++)
	{
		asm("nop");	
	//	if(i%1000==0){ tickprintf(1);}	
	for(k=0;k<loop;k++)
		{
			
			asm("nop");
		}
	}

	exit();
}
