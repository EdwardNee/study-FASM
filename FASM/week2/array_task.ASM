format PE CONSOLE 4.0

entry begin

include 'win32a.inc'

section '.data' data readable writable

        element db '%d', 0
        helpEl dd ?
        strEnterSize db 'Enter N, array`s length: ', 0
        strA db 'A: ', 0
        strB db 'B: ', 0

        slashn db 10, 0, 0
        numerating db '  ', 0

        arrayA dd ?
        arrayB dd ?
        buffer dd ?
        copyAr dd ?

        sizeA dd ?
        sizeB dd ?
        firstElem dd 0
        cnt dd 0
        lastInd dd 0
        lastElem dd 0
        i dd -1

section '.code' code readable executable

        begin:

                call Read_N

                ;reserve memory for Initial
                invoke GetProcessHeap
                mov [buffer], eax
                invoke HeapAlloc,[buffer], 0, sizeA
                mov [arrayA],eax

                call InitA
                call Reload
                call EqualityTwo
                call PrepDA
                cinvoke printf, slashn

                invoke HeapAlloc,[buffer], 0, sizeB ;reserve memory for Out
                mov [arrayB],eax

                call InitOut

                call PrepDB

                invoke HeapFree,[buffer], 0, [arrayA]
                invoke HeapFree, [buffer], 0, [arrayB]

                call [getch]

                push 0
                call [ExitProcess]


Read_N:

        cinvoke printf, strEnterSize
        cinvoke scanf, element, sizeA

        ;Initialize lastInd
        mov ecx, [sizeA]
        sub ecx, 1

        mov [lastInd], ecx

        ret

InitA:
        mov [arrayA], eax

        lA:
                inc [i]
                mov ecx, [i]
                ;indexes /4
                imul ecx, 4
                mov eax, [arrayA]
                add eax, ecx
                mov ecx, [eax]
                cinvoke scanf, element, eax

                mov ecx, [i]
                imul ecx, 4

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
                cmp ecx, [sizeA]
                jne lA

         mov [i], -1
        ret

        check_equality:
                cmp [firstElem], ecx
                jne NotEqualToFirst

                jmp lAcont

InitOut:

        mov [arrayB], eax
        mov [cnt], 0
        mov [i], 0
        jmp lB

        lB:
                inc [i]
                mov eax, [arrayA]
                ;Getting element from array
                mov [copyAr], eax
                mov ecx, [i]
                imul ecx, 4
                mov eax, [copyAr]
                add eax, ecx
                mov ecx, [eax]

                cmp ecx, [firstElem]
                jne toarB

        lBcont:

                mov ecx, [i]
                add ecx, 1
                cmp ecx, [sizeA]
                jne lB

        mov [i], -1
        ret

        NotEqualToFirst:
                add [sizeB], 1
                jmp lAcont

        adding:
                mov [helpEl], ecx

                mov ecx, [cnt]
                imul ecx, 4
                mov eax, [arrayB]
                add eax, ecx

                mov ecx, [helpEl]
                mov [eax], ecx

                add [cnt], 1
                jmp lBcont

Reload:
        mov eax, [arrayA]
        mov [copyAr], eax
        mov ecx, [sizeA]
        mov [cnt], ecx

        ret

PrepDA:

        mov eax, [arrayA]
        mov [copyAr], eax
        mov ecx, [sizeA]   ;edx
        mov [cnt], ecx

        cinvoke printf, slashn
        cinvoke printf, strA
        mov [i], -1
        call Print

        ret

PrepDB:

        mov eax, [arrayB]
        ;mov eax, [arrayA]
        mov [copyAr], eax
        mov ecx, [sizeB]
        mov [cnt], ecx
        cinvoke printf, strB
        mov [i], -1
        call Print

        ret

        toarB:

                mov edx, ecx
                cmp edx, [lastElem]
                jne adding
                jmp lBcont

Print:

        cmp [cnt], 0
        jle endwr
        pl:

                inc [i]
                mov ecx, [i]
                imul ecx, 4
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
                mov [i], -1
                ret

EqualityTwo:

        mov [i], 0
        mov edx, [firstElem]
        cmp edx, [lastElem]
        jne looper
        jmp fend
cinvoke printf, strEnterSize, [sizeB]

        looper:
                inc [i]
                mov ecx, [i]
                imul ecx, 4
                mov eax, [copyAr]
                add eax, ecx
                mov edx, [eax]

                cmp edx, [lastElem]
                jne contlooper
                add[sizeB], -1
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
                user32,'user32.dll'

        import msvcrt,\
               printf, 'printf',\
                scanf, 'scanf',\
               getch, '_getch'

        import kernel,\
               GetProcessHeap, 'GetProcessHeap',\
               ExitProcess, 'ExitProcess',\
               HeapAlloc,'HeapAlloc',\
               HeapFree, 'HeapFree'

