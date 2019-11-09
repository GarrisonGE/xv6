#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
	settick(15);
	int i,k;
	const int loop=10000;
	for(i=0;i<loop;i++)
	{
		asm("nop");
		for(k=0;k<loop;k++)
		{
			asm("nop");
		}
	}
	exit();
}
