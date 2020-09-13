format PE console

entry begin ;Starter flag

include 'win32a.inc'

section '.data' data readable writable

        helloMsg db 'Hello, world!', 0 ;Даем компилятору понять, что далее ничего не будет.

        NULL = 0

section '.code' code readable executable
        begin:
                push helloMsg
                call[printf]

                call [getch]

                push NULL
                call [ExitProcess]

section '.data' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               getch, '_getch'