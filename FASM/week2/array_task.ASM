format PE CONSOLE 4.0

entry begin

include 'win32a.inc'

section '.data' data readable writable

        element db '%d', 0
        helpEl dd ?
        strEnterN db 'Enter N, array`s length: ', 0
        strA db 'A: ', 0
        strB db 'B: ', 0

        slashn db 10, 13, 0
        numerating db '  ', 0

        arrayA dd ?
        arrayB dd ?
        copyAr dd ?
        _heap dd ?

        N dd ?
        M dd 0
        minBound dd 0
        firstElem dd 0
        cnt dd ?
        lastInd dd 0
        lastElem dd 0
        i dd -1

section '.code' code readable executable

        begin:

                call Read_N

                invoke HeapCreate, HEAP_NO_SERIALIZE, 0, 0
                mov [_heap], eax
                invoke HeapAlloc,[_heap], HEAP_NO_SERIALIZE, N ;reserve memory for Initial
                call InitA
                call Reload
                call EqualityTwo
                call PrepDA
                cinvoke printf, slashn

                invoke HeapAlloc,[_heap], HEAP_NO_SERIALIZE, M ;reserve memory for Result
                call InitB
                call PrepDB

                invoke HeapFree, _heap, 0, arrayA
                invoke HeapFree, _heap, 0, arrayB

                call [getch]

                push 0
                call [ExitProcess]


Read_N:

        cinvoke printf, strEnterN
        cinvoke scanf, element, N

        ;Initialize lastInd
        mov ecx, [N]
        sub ecx, 1

        mov [lastInd], ecx

        ret

InitA:
        mov [arrayA], eax

        lA:
                add [i], 1

                mov ecx, [i]
                ;indexes /4
                imul ecx, dword 4
                mov eax, [arrayA]
                add eax, ecx
                mov ecx, [eax]
                cinvoke scanf, element, eax

                mov ecx, [i]
                imul ecx, dword 4

                mov eax, [arrayA]
                add eax, ecx
                mov ecx, [eax]

                cmp [i], 0
                ja check_equality
                mov [firstElem], ecx

        lAcont:

                mov [lastElem], ecx

                mov ecx, [i]
                add ecx, 1
                cmp ecx, [N]
                jne lA

         mov [i], -1
        ret

        check_equality:
                cmp [firstElem], ecx
                jne NotEqualToFirst

                jmp lAcont

InitB:
        mov [arrayB], eax
        mov [cnt], 0
        mov [i], 0
        jmp lB

        lB:
                add [i], 1

                mov eax, [arrayA]
                ;Getting element from array
                mov [copyAr], eax
                mov ecx, [i]
                imul ecx, dword 4
                mov eax, [copyAr]
                add eax, ecx
                mov ecx, [eax]

                cmp ecx, [firstElem]
                jne toarB

        lBcont:

                mov ecx, [i]
                add ecx, 1
                cmp ecx, [N]
                jne lB

        ret

        NotEqualToFirst:
                add [M], 1
                jmp lAcont

        adding:
                mov [helpEl], ecx

                mov ecx, [cnt]
                imul ecx, dword 4
                mov eax, [arrayB]
                add eax, ecx

                mov ecx, [helpEl]
                mov [eax], ecx

                add [cnt], 1
                jmp lBcont

Reload:
        mov eax, [arrayA]
        mov [copyAr], eax
        mov ecx, [N]
        mov [cnt], ecx

        ret

PrepDA:

        mov eax, [arrayA]
        mov [copyAr], eax
        mov ecx, [N]   ;edx
        mov [cnt], ecx

        cinvoke printf, slashn
        cinvoke printf, strA

        call Print

        ret

PrepDB:

        mov eax, [arrayB]
        ;mov eax, [arrayA]
        mov [copyAr], eax
        mov ecx, [M]
        mov [cnt], ecx
        cinvoke printf, strB

        call Print

        ret

        toarB:

                mov edx, ecx
                cmp edx, [lastElem]
                jne adding
                jmp lBcont

Print:

        mov [i], -1
        cmp [cnt], 0
        jle endwr
        pl:

                add [i], 1

                mov ecx, [i]
                imul ecx, dword 4
                mov eax, [copyAr]
                add eax, ecx
                cinvoke printf, element, dword [eax]
                mov ecx, [i]
                add ecx, 1

                cmp ecx, [cnt]
                jne enumer
                jmp plcont

                enumer:
                        cinvoke printf, numerating

                plcont:

                        mov ecx, [i]
                        add ecx, 1
                        cmp ecx, [cnt]
                        jne pl

        endwr:

                cinvoke printf, slashn

                ret

EqualityTwo:

        mov [i], 0
        mov edx, [firstElem]
        cmp edx, [lastElem]
        jne looper
        jmp fend
cinvoke printf, strEnterN, [M]

        looper:
                add [i], 1

                mov ecx, [i]
                imul ecx, dword 4
                mov eax, [copyAr]
                add eax, ecx
                mov edx, [eax]

                cmp edx, [lastElem]
                jne contlooper
                add[M], -1
                contlooper:

                        mov ecx, [i]
                        add ecx, 1
                        cmp ecx, [cnt]

                        mov ecx, [i]
                        add ecx, 1

                        cmp ecx, [cnt]
                        jne looper
        fend:
                ret


section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll',\
                user32,'user32.'

        import msvcrt,\
               printf, 'printf',\
                scanf, 'scanf',\
               getch, '_getch'

        import kernel,\
               ExitProcess, 'ExitProcess',\
               HeapCreate, 'HeapCreate',\
               HeapFree, 'HeapFree',\
               HeapAlloc,'HeapAlloc'