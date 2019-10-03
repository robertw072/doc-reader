#!/usr/bin/perl
use strict;

my $filename = $ARGV[0] or die "Need to get file name on the command line\n";
open(DATA, "<$filename") or die "Couldn't open file $filename, $!";
my @all_lines = <DATA>;

open(LINES, "</pub/pounds/CSC330/dalechall/wordlist1995.txt") or die "Couldn't open Dale-Chall list!\n";
my @dale_chall = <LINES>;

our $word = 0;
our $sentence = 0;
our $syllable = 0;
our $ez_word = 0;

foreach my $line(@all_lines)
{
	my @tokens = split(' ', $line);
	foreach my $token(@tokens)
	{
		our $lc_token = lc($token);
#		print"$lc_token\n";
		if ($lc_token ne $lc_token + 0)
		{
			$word++;
		}

		my @chars = split('', $token);
		my $length = @chars;
		foreach my $i(0..$#chars)
		{
#			print"$char\n";
			if ($chars[$i] eq '.' || $chars[$i] eq ':' || $chars[$i] eq ';' || $chars[$i] eq '!' || $chars[$i] eq '?')
			{
				$sentence++;
			}

			my $flag = 0; 
			if ($chars[$i] eq 'a' || $chars[$i] eq 'i' || $chars[$i] eq 'o' || $chars[$i] eq 'u' || $chars[$i] eq 'y')
			{
				if ($flag == 0)
				{
					$syllable++;
				}
				$flag = 1;	
			}
			
			elsif ($chars[$i] eq 'e')
			{
				if ($i == $length - 1)
				{
					$syllable = $syllable;
				}

				if (($flag == 0) && ($i != $length - 1))
				{
					$syllable++;
				}
				$flag = 1;
			}

			else 
			{
				$flag = 0;
			}
		}
		$lc_token =~ s/[^a-zA-Z0-9]*//g;

		foreach my $j(0..$#dale_chall)
		{
			chomp($dale_chall[$j]);
			if ($lc_token eq $dale_chall[$j])
			{
				$ez_word++;
			}			
		}
	}
}

my $diffWord = $word - $ez_word;

print"The word count is: $word\n";
print"The sentence count is: $sentence\n";
print"The syllable count is: $syllable\n";
print"The difficult word Count is: $diffWord\n";

our $alpha = ($syllable / $word);
our $beta = ($word / $sentence);
our $gamma = ($diffWord / $word);

our $flesch = 206.835 - ($alpha * 84.6) - ($beta * 1.015);
our $grade = ($alpha * 11.8) + ($beta * 0.39) - 15.59;
our $readability;
if ($gamma > 0.05)
{
	$readability = (($gamma * 100) * 0.1579) + ($beta * 0.0496) + 3.6365;
}

else
{
        $readability = (($gamma * 100) * 0.1579) + ($beta * 0.0496);
}

print"The Flesch Readability index is: $flesch\n";
print"The Flesch-Kincaid Grade Level index is: $grade\n";
print"The Dale-Chall Readability Score is: $readability\n";
