#include <iostream>
#include <fstream>
#include <cstring>
#include <string>

using namespace std;

bool isNumber (const char* input, int base);

int main()
{

	ifstream myFile ("/pub/pounds/CSC330/translations/KJV.txt");			// open text file
	
	if (myFile.is_open())								// check if file opened correctly
	{
		cout << "The file opened correctly." << endl;
	}
	
	else cout << "Unable to open the file. " << endl;

	/*int sentence = 0;
        char ch;

        while (myFile)                                                                  // this loop gets the sentence count
        {
                myFile.get(ch);

                if (ch == '.' || ch == ':' || ch == ';' || ch
                == '?' || ch == '!')
                {
                        sentence++;
                }
        }

        cout << "Sentence Count: " << sentence << endl;*/

	string contents((istreambuf_iterator<char>(myFile)),				// puts the file into a string
	 istreambuf_iterator<char>());

	char *contentsCopy = new char [contents.length() + 1];				// instantiates a character array which holds a copy of contents
	strcpy (contentsCopy, contents.c_str());

	char *token = strtok(contentsCopy, " ");					// tokenizes contents and puts in a token array
	
	int word = 0;
	int sentence = 0;

	while (token != NULL)								// this loops counts the number of words
	{
		//cout << token << endl;
		word++;

		for (int i = 0; i < strlen(token); i++)					// this loop counts the number of sentences
		{
			char ch = token[i];		
	
			if (ch == '.' || ch == ':'
			|| ch == ';' || ch == '?'
			|| ch == '!')
			{
				sentence++;	
			} 
		}

		token = strtok(NULL, " ");
	}

	cout << "Word count: " << word << endl;	
	cout << "Sentence count: " << sentence << endl;

	myFile.close();	

	return 0;
}

bool isNumber (const char* input, int base)
{
	string numbase = "0123456789ABCDEF";
	string in = input;

	return (in.find_first_not_of(numbase.substr(0, base)) == string::npos);
} 
