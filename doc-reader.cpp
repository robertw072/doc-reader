nclude <iostream>
#include <fstream>
#include <string>

using namespace std;

int main()
{
	string line;
	ifstream myFile ("/pub/pounds/CSC330/translations/KJV.txt");
	
	if (myFile.is_open())
	{
		while (getline(myFile, line))
		{
			cout << line << endl;
		}
	myFile.close();
	}
	
	else cout << "Unable to open file." << endl;


	return 0;
}
