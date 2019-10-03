program reader 

        character(:), allocatable       :: long_string, outline, token, dictionary, dict, dictToken
        integer                         :: filesize
        integer                         :: word, syllable, sentence, space, diffWord
        
        integer                         :: n, p
        logical                         :: flag, dictFlag, lengthFlag

interface
        subroutine read_file(string, filesize)
                character(:), allocatable       :: string
                integer                         :: filesize
        end subroutine read_file

        subroutine read_dictionary(string)
                character(:), allocatable       :: string
        end subroutine read_dictionary


        subroutine get_next_token(inline, outline, word)
                character(:), allocatable       :: inline
                character(:), allocatable       :: outline, word
        end subroutine get_next_token

        function to_upper(in) result(out)
                character(*), intent(in)         :: in
                character(:), allocatable        :: out
        end function to_upper
end interface

        call read_file(long_string, filesize)
!        print *, long_string
        print *, "Read ", filesize, " characters."
        outline = long_string

        print *, token
        call read_dictionary(dictionary)
!        print *, dictionary
        dict = dictionary

        word = 0
        syllable = 0
        sentence = 0
        space = 0
        diffWord = 0        

        flag = .true.
        dictFlag = .true.
        lengthFlag = .false.

        do while (len(outline) .ne. 0)
                call get_next_token(long_string, outline, token)
                word = word + 1

                do n = 0, LEN_TRIM(token)
                        if (token(n:n) .eq. "." .or. token(n:n) .eq. "!" .or. &
                        token(n:n) .eq. "?" .or. token(n:n) .eq. ":" .or.     &
                        token(n:n) .eq. ";") then
                                sentence = sentence + 1
                                token(n:n) = ""
                        end if

                        if (token(n:n) .eq. ",") then
                                token(n:n) = ""
                        end if

                        if  (token(n:n) .eq. "") then 
                                space = space + 1
                        end if 
                       
                        if (to_upper(token(n:n)) .eq. "A" .or. &
                            to_upper(token(n:n)) .eq. "I" .or. &
                            to_upper(token(n:n)) .eq. "O" .or. &
                            to_upper(token(n:n)) .eq. "U" .or. &
                            to_upper(token(n:n)) .eq. "Y") then
                                if (flag .eqv. .true.) then
                                        syllable = syllable + 1
                                        flag = .false.
                                end if
                        
                        else if (to_upper(token(n:n)) .eq. "E") then
                                if (n .eq. LEN_TRIM(token) - 1) then
                                        syllable = syllable
                                else
                                        if (flag .eqv. .true.) then
                                                syllable = syllable + 1
                                                flag = .false.
                                        end if
                                end if
                        
                        else 
                                flag = .true.
                        end if 
                end do

                if (INDEX(to_upper(dictionary), to_upper(token)) == 0) then
                        print *, token
                        diffWord = diffWord + 1
                end if
                
!                print *, to_upper(token)

                long_string = outline
        end do

        word = word - space
        diffWord = diffWord - space
        print *, "The word count is: ", word
        print *, "The sentence count is: ", sentence
        print *, "The syllable count is : ", syllable
        print *, "The difficult word count is: ", diffWord

end program reader

        subroutine read_file(string, filesize)
                character(:), allocatable       :: string
                character(50)                   :: filename
                integer                         :: counter
                integer                         :: filesize

                character(LEN=1)                :: input

                call getarg(1, filename)
                inquire(file=filename, size=filesize)
                open(unit=5,status="old",access="direct",form="unformatted",recl=1,file=filename)
                allocate(character(filesize)    :: string)

                counter = 1
100             read (5, rec = counter, err = 200) input
                string(counter:counter) = input
                counter = counter + 1
                goto 100

200             continue

                counter = counter - 1
                close(5)
        end subroutine read_file

        subroutine read_dictionary(string)
                character(:), allocatable       :: string
                character(50)                   :: filename
                integer                         :: counter
                integer                         :: filesize

                character(LEN=1)                :: input

!                print *, "Enter the filepath of the file you'd like to read: "
!                call get_command_argument(1, filename)

                filename = "/pub/pounds/CSC330/dalechall/wordlist1995.txt"
                inquire(file=filename, size=filesize)
                open(unit=5,status="old",access="direct",form="unformatted",recl=1,file=filename)
                allocate(character(filesize)    :: string)

                counter = 1
100             read (5, rec = counter, err = 200) input
                string(counter:counter) = input
                counter = counter + 1
                goto 100

200             continue

                counter = counter - 1
                close(5)
        end subroutine read_dictionary


        subroutine get_next_token(inline, outline, token)
                character(:), allocatable       :: inline
                character(:), allocatable       :: outline, token
                integer                         :: i, j
                logical                         :: foundFirst, foundLast

                foundFirst = .false.
                foundLast = .false.
                i = 0
                       
                do while (.not. foundFirst .and. (i < len(inline)))
                        if (inline(i:i) .eq. " ") then
                                i = i + 1
                        else
                                foundFirst = .true.
                        end if
                        
                       select case (inline(i:i))
                                case ("0":"9")
                                        inline(i:i) = ""
                                case ("[":"]")
                                        inline(i:i) = ""
                                case ("#")
                                        inline(i:i) = ""
                       end select                       
                end do

                j = i
                do while (foundFirst .and. .not. foundLast .and. (j < len(inline)))
                        if (inline(j:j) .ne. " ") then
                                j = j + 1
                        else
                                foundLast = .true.
                        end if
                
                        select case (inline(j:j))
                                case ("0":"9")
                                        inline(j:j) = ""
                                case ("[":"]")
                                        inline(j:j) = ""
                                case ("#")
                                        inline(j:j) = ""
                        end select
                end do     

                token = trim(inline(i:j))
                outline = trim(inline(j+1:len(inline)))
        end subroutine get_next_token

        function to_upper(in) result(out)
                implicit none
                character(*), intent(in)        :: in
                character(:), allocatable       :: out
                integer                         :: i, j

                character(*), parameter         :: upp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                character(*), parameter         :: low = 'abcdefghijklmnopqrstuvwxyz'

                out = in

                do i = 1, LEN_TRIM(out)
                        j = INDEX(low, out(i:i))
                        if (j > 0) out(i:i) = upp(j:j)
                end do
        end function to_upper
