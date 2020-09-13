format PE console

entry begin

include 'win32a.inc'

section '.data' readable writable

        resultStr db 'Result %d', 0
        ;Reserve elements
        A dd ?
        B dd ?
        C dd ?

        NULL = 0

section '.code' code readable executable

        begin:
                ;Заносим значения в А и В
                mov [A], 12
                mov [B], 10


                        ;mov eax, 12
                        ;mov ecx, 4
                        ;mov edx, 0 ;Обнуляем остаток

                        ;div ecx

                        ;imul
                        ;mov eax, [A]
                        ;mul [B]

                        ;push eax
                        mov ecx, [A]
                        add ecx, [B]

                        push ecx
                        push resultStr
                        call [printf]

                        call [getch]

                        push NULL
                        call ExitProcess


section '.idata' import data readable


        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'
