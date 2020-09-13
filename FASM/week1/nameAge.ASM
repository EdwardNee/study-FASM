format PE console

entry start

include 'win32a.inc'

section 'data' data readable writable

        formatStr db '%s', 0
        formatNum db '%d', 0

        name rd 2 ; Reserve double size 2 - word
        age rd 1

        wn db 'What is your name? ', 0
        ho db 'How old are you? ', 0
        hello db 'Hello %s, you are %d years old.', 0

        address db 10, 13, 'name string address is %d' ;10, 13, - \n

        NULL = 0

section '.code' code readable executable

        start:

                push wn
                call [printf]

                ;pushing to stack
                push name
                push formatStr
                call [scanf]

                push ho
                call [printf]

                push age
                push formatNum
                call [scanf]

                push [age]
                push name
                push hello
                call [printf]

                lea eax, [formatStr] ;data address

                push eax
                push address
                call [printf]

                call [getch]

                push NULL

                call [ExitProcess]


section '.idada' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch',\
               scanf, 'scanf'
