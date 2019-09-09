#include <iostream>
#include <fstream>
#include <cstring>
#include <cctype>
#include <cmath>
#include <string>

using namespace std;

bool isVowel (char c)									// this function checks for vowels lul
{
	if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u'
	|| c == 'y')
	{
		return true;
	}

	return false;
}

void checkSyllable(string token, int index, int& numSyllables)				// this function checks fo syllables and increments the count
{
	bool noSyllable = true;
	bool twoVowels = false;

	for (int i = 0; i <= index; i++)
	{
		if (isVowel(token[i]))
		{
			if (!twoVowels)
			{
				if (!((i == index) && (token[i] ==			// checks if the last character is an e
				'e')))
				{
					numSyllables++;
					noSyllable = false;
					twoVowels = true;
				}
			}
		}
		else
			twoVowels = false;
	}
	
	if (noSyllable)
		numSyllables++;								// every word has at least one syllable
}

int main()
{

	ifstream myFile ("/pub/pounds/CSC330/translations/KJV.txt");			// open text file
	
	if (myFile.is_open())								// check if file opened correctly
	{
		cout << "The file opened correctly." << endl;
	}
	
	else cout << "Unable to open the file. " << endl;

	string contents((istreambuf_iterator<char>(myFile)),				// puts the file into a string
	 istreambuf_iterator<char>());

	char *contentsCopy = new char [contents.length() + 1];				// instantiates a character array which holds a copy of contents
	strcpy (contentsCopy, contents.c_str());

	char *token = strtok(contentsCopy, " ");					// tokenizes contents and puts in a token array
	
	int word = 0;
	int sentence = 0;
	int syllable = 0;

	while (token != NULL)								// this loops counts the number of words
	{
		for (int i = 0; i < strlen(token); i++)
			tolower(token[i]);
	
		if (isalpha(token[0]))
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

		checkSyllable(token, strlen(token), syllable);

		token = strtok(NULL, " ");
	}

	cout << "Word count: " << word << endl;	
	cout << "Sentence count: " << sentence << endl;
	cout << "Syllable count: " << syllable << endl;

	double alpha = ((double)syllable / (double)word);
	double beta = ((double)word / (double)sentence);

	double index = (206.835 - (alpha * 84.6) - (beta * 1.015));
	double grade = ((alpha * 11.8) + (beta * 0.39) - 15.59);

	cout << "The Flesch index score is: " << round(index) << endl;
	cout << "The Flesch Kincaid Grade Level index is: " << grade << endl;

	myFile.close();	

	return 0;
} 
