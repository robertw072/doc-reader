#include <iostream>
#include <fstream>
#include <cstring>
#include <cctype>
#include <cmath>
#include <string>
#include <vector>
#include <sstream>
#include <unordered_map>

using namespace std;

bool isNumber (string token)
{
	stringstream ss;
	ss << token;

	string temp;
	int found;
	while (!ss.eof())
	{
		ss >> temp;

		if (stringstream(temp) >> found)
		{
			//cout << temp << endl;
			return true;
		}

	}
	return false;
}

int checkSyllable (string token)									// this function checks fo syllables and increments the count
{
	int count = 0;
	bool noAdjVowel = true;

	for (int i = 0; i < token.length(); i++)
	{
		switch (token[i])
		{
			case 'a':
				count = (noAdjVowel) ? count + 1:count;
				noAdjVowel = false;
				break;
			case 'e':
				if (i == token.length() - 1)
					continue;
				count = (noAdjVowel) ? count + 1:count;
				noAdjVowel = false;
				break;
			case 'i':
				count = (noAdjVowel) ? count + 1:count;
				noAdjVowel = false;
				break;
			case 'o':
				count = (noAdjVowel) ? count + 1:count;
				noAdjVowel = false;
				break;
			case 'u':
				count = (noAdjVowel) ? count + 1:count;
				noAdjVowel = false;
				break;
			case 'y':
				count = (noAdjVowel) ? count + 1:count;
				noAdjVowel = false;
				break;
			default:
				noAdjVowel = true;
				continue;
		}
	}
	if (count == 0)
		count++;
	return count;	
}

void checkDictionary (string token, unordered_map<string, int> dictionary, int& numWords)		// this function identifies if a token is in the dictionary
{
	if (dictionary.find(token) == dictionary.end())
		numWords++;

	//cout << numWords << endl;
} 

int main()
{
	cout << "Enter the name of the file you'd like to read: " << endl;
	string name;
	cin >> name;

	ifstream myFile (name);			// open text file
	
	if (myFile.is_open())								// check if file opened correctly
	{
		cout << "The file opened correctly." << endl;
	}
	
	else cout << "Unable to open the file. " << endl;

	ifstream daleChall ("/pub/pounds/CSC330/dalechall/wordlist1995.txt");		// opens Dale-Chall list

	if (daleChall.is_open())
		cout << "The Dale-Chall list opened correctly." << endl;

	else cout << "Unable to open Dale-Chall list." << endl;

	unordered_map<string, int> dictionary;
	string key;
	int n = 0;
	while (daleChall >> key)							// reads each line into dictionary vector
	{
		n++;
		for (int i = 0; i < key.size(); i++)
		{
			if (ispunct(key[i]))
			{
				key.erase(i--, 1);
			}
			key[i] = tolower(key[i]);
		}
		dictionary.insert(make_pair(key, n));
	}

	/* for (int x = 0; x < dictionary.size(); x++)
		cout << dictionary[x] << endl; */ 

	//string contents((istreambuf_iterator<char>(myFile)),				// puts the file into a string
	// istreambuf_iterator<char>());

	vector <string> tokens;

	//stringstream check1(contents);

	string line;

	while (getline(myFile, line))
	{
		stringstream contents(line);
		
		while (getline(contents, line, ' '))
		{
			tokens.push_back(line);
		}
	}
	
	int word = 0;
	int sentence = 0;
	int syllable = 0;
	int diffWord = 0;

	for (int i = 0; i < tokens.size(); i++)								// this loops counts the number of words
	{
		string token = tokens[i];

		for (int f = 0; f < token.length(); f++)
		{
			if (token[f] == '[' || token[f] == ']')
			{
				token.erase(f--, 1);
			}
			token[f] = tolower(token[f]);
		}

		if (!isNumber(token))
		{
			word++;
			//cout << token << endl;
		}

		for (int n = 0; n < token.length(); n++)					// this loop counts the number of sentences
		{
			char ch = token[n];		
	
			if (ch == '.' || ch == ':'
			|| ch == ';' || ch == '?'
			|| ch == '!')
			{
				sentence++;
				token = token.substr(0, token.length() - 1);	
			} 
		}

		syllable = syllable + checkSyllable(token);

		//checkDictionary(token, dictionary, diffWord);
	}

	cout << "Word count: " << word << endl;	
	cout << "Sentence count: " << sentence << endl;
	cout << "Syllable count: " << syllable << endl;
	cout << "Difficult Word count: " << diffWord << endl;

	double alpha = ((double)syllable / (double)word);
	double beta = ((double)word / (double)sentence);
	double gamma = ((double)diffWord / (double)word) * 100;

	double index = (206.835 - (alpha * 84.6) - (beta * 1.015));
	double grade = ((alpha * 11.8) + (beta * 0.39) - 15.59);

	cout << "The Flesch index score is: " << round(index) << endl;
	cout << "The Flesch Kincaid Grade Level index is: " << grade << endl;

	double readability;

	if (gamma > 5.0)
		readability = (gamma * 0.1579) + (beta * 0.0496) + 3.6365;
	else
		readability = (gamma * 0.1579) + (beta * 0.0496);

	cout << "The Dale-Chall Readability score is: " << readability << endl; 

	myFile.close();	

	return 0;
} 
