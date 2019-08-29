#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main()
{

	ifstream myFile ("/pub/pounds/CSC330/translations/KJV.txt");			// open text file
	
	if (myFile.is_open())								// check if file opened correctly
	{
		cout << "The file opened correctly." << endl;
	}
	
	else cout << "Unable to open file." << endl;

	int word = 1;									// first word will not be counted so its initial val is 1
	char ch;

	while (myFile)
	{
		myFile.get(ch);
	
		if (ch == ' ' || ch == '\n')
			word++;
	
	}

	cout << "Word Count: " << word << endl;

	myFile.close();	

	return 0;
}
