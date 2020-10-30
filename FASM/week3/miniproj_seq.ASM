format PE CONSOLE 4.0

entry begin

include 'win32a.inc'

section '.data' data readable writable

        ;Initial values
        t_1 dd 0
        t_2 dd 0
        t_3 dd 0
        t_4 dd 1

        t_n dd 0
        cnt dd 4  ;count of sequence's elements

        ;output strings
        slashn db 13, 10, 0
        numerating db ' ', 0
        el dd '%u', 0
        strRes db 'Number of elements of the recurrent sequence: %d.', 0


section '.code' code readable executable

        begin:

                mov ecx, 0
                call Rec_meth   ;proc of recurrent seq.
                call FinishProgram    ;Finishing program




Rec_meth:

        lp:
                ;sum of values
                mov eax, [t_1]
                add eax, [t_2]
                add eax, [t_3]
                add eax, [t_4]

                mov dword [t_n], eax

                ;Shifting t1->t2,....
                ;rewrite in t_1
                mov ecx, [t_1]
                mov ebx, [t_2]

                mov [t_1], ebx

                ;rewrite in t_2
                mov ecx, [t_2]
                mov ebx, [t_3]

                mov [t_2], ebx

                ;rewrite in t_3
                mov ecx, [t_3]
                mov ebx, [t_4]

                mov [t_3], ebx

                ;rewrite in t_4
                mov ecx, [t_4]
                mov ebx, [t_n]

                mov [t_4], ebx

                ;Checking for subsequent overflow
                mov edx, eax
                add edx, [t_2]
                jo lpEnd      ;if overflowed
                sub edx, [t_2]

                cinvoke printf, el, [t_n]
                cinvoke printf, slashn
                inc [cnt] ;increment counter
                jmp lp

        lpEnd:
                cinvoke printf, slashn  ;NewLine
                cinvoke printf, strRes, [cnt] ;output cnt

                ret     ;return type void to exit from the proc

FinishProgram:

        call [getch]
        push 0
        call [ExitProcess]

        ret


section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll',\
                user32,'user32.dll'

        import msvcrt,\
               printf, 'printf',\
                scanf, 'scanf',\
               getch, '_getch'

        import kernel,\
               ExitProcess, 'ExitProcess'
;https://board.flatassembler.net/topic.php?t=9031