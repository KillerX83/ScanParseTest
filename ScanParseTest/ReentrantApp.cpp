// ScanParseTest.cpp : Defines the entry point for the console application.
//


#include "ParseTree.h"

#include <iostream>

int main(int argc, char* argv[])
{
	CParseTree pt;

	pt.RunParser(argv[1]);

	std::cout << "Type any key"; char c = std::cin.get();

	return 0;
}