format PE CONSOLE 4.0

entry begin

include 'win32a.inc'

section '.data' data readable writable

        element db '%d', 0
        helpEl dd ?
        strEnterSize db 'Enter array`s length: ', 0
        strA db 'A: ', 0
        strB db 'B: ', 0

        slashn db 10, 0, 0
        numerating db '  ', 0

        arrayA rd 4
        arrayB rd 4
        buffer dd ?
        copyAr rd 4

        sizeA dd ?
        sizeB dd ?
        firstElem dd 0
        cnt dd 0
        lastInd dd 0
        lastElem dd 0
        i dd 0

section '.code' code readable executable

        begin:

                call ReadSize

                ;reserve memory for Initial
                invoke GetProcessHeap
                mov [buffer], eax
                invoke HeapAlloc, [buffer], 0, sizeA

                call InitA
                call Reload
                call EqualityTwo
                call PrepDA
                cinvoke printf, slashn

                invoke HeapAlloc, [buffer], 0, sizeB ;reserve memory for Out

                call InitOut
                call PrepDB

                invoke HeapFree, [buffer], 0, [arrayA]
                invoke HeapFree, [buffer], 0, [arrayB]

                call [getch]

                cinvoke ExitProcess, 0


ReadSize:

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
                mov eax, [arrayA]
                mov ecx, [i]

                imul ecx, 4 ;shifting pointer/4
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
                inc [i]
                cmp ecx, [sizeA]
                jne lA

         mov [i], 0
        ret

        check_equality:
                cmp [firstElem], ecx
                jne NotEqualToFirst

                jmp lAcont

InitOut:

        mov [arrayB], eax
        mov [cnt], 0

        lB:

                mov eax, [arrayA]
                ;Taking element from array
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
                inc [i]
                cmp ecx, [sizeA]
                jne lB

        mov [i], 0
        ret

        NotEqualToFirst:
                add [sizeB], 1
                jmp lAcont

        adding:
                mov [helpEl], ecx
                mov eax, [arrayB]

                mov ecx, [cnt]
                imul ecx, 4

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
        mov [i], 0
        call Print

        ret

PrepDB:

        mov eax, [arrayB]
        ;mov eax, [arrayA]
        mov [copyAr], eax
        mov ecx, [sizeB]
        mov [cnt], ecx
        cinvoke printf, strB
        mov [i], 0
        call Print

        ret

        toarB:

                mov edx, ecx
                cmp edx, [lastElem]
                jne adding
                jmp lBcont

Print:

        cmp [cnt], 0
        jbe endwr
        pl:

                mov eax, [copyAr]
                mov ecx, [i]
                imul ecx, 4

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
                        inc [i]
                        cmp ecx, [cnt]
                        jne pl

        endwr:

                cinvoke printf, slashn
                mov [i], 0
                ret

EqualityTwo:

        mov [i], 0
        mov edx, [firstElem]
        cmp edx, [lastElem]
        jne looper
        jmp fend
cinvoke printf, strEnterSize, [sizeB]

        looper:
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

                        inc [i]
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
