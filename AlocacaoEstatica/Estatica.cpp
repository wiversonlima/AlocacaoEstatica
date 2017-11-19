#include <stdio.h>
#include <conio.h>

void ponteiros();

void main()
{
	ponteiros();
	_getch();
}

void ponteiros()
{
	int num;
	int *p;
	num = 5;
	p = &num;
	printf("%d", num);
}