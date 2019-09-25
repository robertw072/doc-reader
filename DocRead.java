import java.io.*;
import java.lang.*;	
import java.util.*;

public class DocRead
{
	public static void main(String[] args) throws IOException
	{
		System.out.println("Enter the file path of the translation you'd like to use: ");
		Scanner tranScan = new Scanner(System.in);
		String translation = tranScan.nextLine();
	
		Scanner s = new Scanner(new File(translation));
		ArrayList<String> tokens = new ArrayList<String>();
		while (s.hasNext())
		{
			String word = s.next();
			tokens.add(word);
			//System.out.println(tokens.get(index));
			//index++;
		}

		Scanner s2 = new Scanner(new File("/pub/pounds/CSC330/dalechall/wordlist1995.txt"));
		Map<String, Object> dictionary = new HashMap<String, Object>();
		while (s2.hasNextLine())
		{
			String word = s2.nextLine();
			word = word.toLowerCase();
			dictionary.put(word, null);
		}

		int word = 0;
		int sentence = 0;
		int syllables = 0;
		int diffWord = 0;

		for (int i = 0; i < tokens.size(); i++)
		{
			String token = tokens.get(i);
			token = token.toLowerCase();		

			for (int n = 0; n < token.length(); n++)
			{
				char c = token.charAt(n);
				

				if (c == '.' || c == ':' ||
				c == ';' || c == '?' || c == '!')
				{
					sentence++;
					//System.out.println(token);
				}
			}

			token = token.replaceAll("[^a-zA-Z0-9]", "");

			if (!isInteger(token))
			{
				word++;
				syllables = syllables + numSyllables(token);
				//System.out.println(token);
				if (!dictionary.containsKey(token))
					diffWord++;
			}
		}

		System.out.println("Word count: " + word);
		System.out.println("Sentence count: " + sentence);
		System.out.println("Syllable count: " + syllables);
		System.out.println("Difficult Word count: " + diffWord);

		double alpha = ((double)syllables / (double)word);
		double beta = ((double)word / (double)sentence);
		double gamma = ((double)diffWord / (double)word);

		double flesch = 206.835 - (alpha * 84.6) - (beta * 1.015);
		double grade = (alpha * 11.8) + (beta * 0.39) - 15.59;
		double readability;
		if (gamma > 0.05)
			readability = ((gamma * 100.0) * 0.1579) + (beta * 0.0496) + 3.6365;
		else
			readability = ((gamma * 100.0) * 0.1579) + (beta * 0.0496);

		System.out.println("The Flesch Readability index is: " + flesch);
		System.out.println("The Flesh-Kincaid Grade Level index is: " + grade);
		System.out.println("The Dale-Chall Readability Score is: " + readability);
	}

	public static boolean isInteger(String input)
	{
		try
		{
			Integer.parseInt(input);
			return true;
		}

		catch(Exception e)
		{
			return false;
		}
	}

	public static int numSyllables(String token)
	{
		int count = 0;
		boolean noAdjVowel = true;

		for (int i = 0; i < token.length(); i++)
		{
			char c = token.charAt(i);
			switch (c)
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
}
