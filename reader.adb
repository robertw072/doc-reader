with Ada.Text_IO;
with Ada.IO_Exceptions;
with Ada.Characters.Handling;
with Ada.Command_Line;
with Ada.Containers.Indefinite_Vectors;
with Ada.Strings.Fixed;
with Ada.Strings.Unbounded;
with Ada.Strings.Maps.Constants;
with Ada.Text_IO.Unbounded_IO;
use Ada.Text_IO;
use Ada.IO_Exceptions;
use Ada.Characters.Handling;
use Ada.Command_Line;
use Ada.Containers;
use Ada.Strings;
use Ada.Strings.Unbounded;
use Ada.Strings.Maps.Constants;
use Ada.Text_IO.Unbounded_IO;

procedure reader is

	In_File		:Ada.Text_IO.File_Type;
	value		:Character;
	string_array	:array(1..5000000) of Character;
	pos		:Integer;

	package String_Vector is new Indefinite_Vectors(Natural,String); use String_Vector;
	s		:String(1..50000000):=(others => Character'Val(0));
	current		:Positive:=s'First;
	v		:Vector;

	word		:Integer;
	sentence	:Integer;
	syllable	:Integer;
	ezword		:Integer;
	diffword	:Integer;
	flag		:Boolean;
	alpha		:Float;
	beta		:Float;
	gamma		:Float;
	flesch		:Float;
	readability	:Float;
	grade		:Float;
	dict		:Ada.Strings.Unbounded.Unbounded_String;

begin
	Ada.Text_IO.Open(File=>In_File, Mode=>Ada.Text_IO.In_File, Name=>"/pub/pounds/CSC330/translations/KJV.txt");

	pos:=0;
	
	while not Ada.Text_IO.End_Of_File(In_File) loop
		Ada.Text_IO.Get(File=>In_File, Item=>value);
		pos:=pos + 1;
		string_array(pos):=value;
	end loop;

exception
	when Ada.IO_Exceptions.END_ERROR=>Ada.Text_IO.Close(File=>In_File);

	word:=0;
	sentence:=0;
	syllable:=0;
	ezword:=0;
	
	for i in 1..pos loop
		string_array(i):=Ada.Characters.Handling.To_Lower(string_array(i));
--		Ada.Text_IO.Put(Item=>string_array(i));
		if string_array(i) = ' ' then
			word:=word + 1;
		end if;

		if string_array(i) = '.' or string_array(i) = ':' or string_array(i) = ';' or string_array(i) = '!' or string_array(i) = '?' then
			sentence:=sentence + 1;
			string_array(i):=' ';
		end if;

		if string_array(i) = ',' or string_array(i) = '#' or string_array(i) = '[' or string_array(i) = ']' then
			string_array(i):=' ';
		end if;

		flag:=TRUE;
		if string_array(i) = 'a' or string_array(i) = 'i' or string_array(i) = 'o' or string_array(i) = 'u' then
			if flag = TRUE then
				syllable:=syllable + 1;
			end if;
			flag:=FALSE;
		elsif string_array(i) = 'e' then
			if string_array(i+1) = ' ' then
				syllable:=syllable;
			end if;

			if flag = TRUE and string_array(i+1) /= ' ' then
				syllable:=syllable + 1;
			end if;
			flag:=FALSE;
		else
			flag:=TRUE;
		end if;
	end loop;

	for i in string_array'range loop
		s(i):= string_array(i);
	end loop;

	for i in s'range loop
		if s(i) = ' ' or i = s'last then
			v.append(s(current..i-1));
			current:=i + 1;
		end if;
	end loop;

	dict:=To_Unbounded_String("");
	Ada.Text_IO.Open(File=>In_File,Mode=>Ada.Text_IO.In_File,Name=>"/pub/pounds/CSC330/dalechall/wordlist1995.txt");
	for s of v loop
		while not End_Of_File(In_File) loop
			dict:=To_Unbounded_String(Get_Line(File=>In_File));
			Translate(dict, Ada.Strings.Maps.Constants.Lower_Case_Map);
			if To_Unbounded_String(s) = dict then
				ezword:=ezword + 1;
			end if;
		end loop;
	end loop;

	diffword:=word - ezword;

	Ada.Text_IO.New_Line;
	Ada.Text_IO.Put_Line("The word count is: ");
	Ada.Text_IO.Put(Integer'Image(word));
	Ada.Text_IO.New_Line;
	Ada.Text_IO.Put_Line("The sentence count is: ");
	Ada.Text_IO.Put(Integer'Image(sentence));
	Ada.Text_IO.New_Line;
	Ada.Text_IO.Put_Line("The syllable count is: ");
	Ada.Text_IO.Put(Integer'Image(syllable));
	Ada.Text_IO.New_Line;
	Ada.Text_IO.Put_Line("The difficult word count is: ");
	Ada.Text_IO.Put(Integer'Image(diffword));

	alpha:=Float(syllable) / Float(word);
	beta:=Float(word) / Float(sentence);
	gamma:=Float(diffWord)/Float(word);

	flesch:=206.835 - (alpha * 84.6) - (beta * 1.015);
	grade:=(alpha * 11.8) + (beta * 0.39) - 15.59;
	readability:=((gamma * 100.0) * 0.1579) + (beta * 0.0496);

	Ada.Text_IO.New_Line;
	Ada.Text_IO.Put_Line("The Flesch Readability index is: ");
	Ada.Text_IO.Put(Float'Image(flesch));
	Ada.Text_IO.New_Line;
	Ada.Text_IO.Put_Line("The Flesch-Kincaid Grade Level index is: ");
	Ada.Text_IO.Put(Float'Image(grade));
	Ada.Text_IO.New_Line;
	Ada.Text_IO.Put_Line("The Dale-Chall Readability score is: ");
	Ada.Text_IO.Put(Float'Image(readability));

end reader;
