format PE console

entry begin

include 'win32a.inc'

section '.data' data readable writable

        strA db 'Enter A: ', 0
        strB db 'Enter B: ', 0
        strOp db 'Enter operation (+, -, *, /, %): ', 0

        resultStr db 'Result: %d', 0
        resMod db '/%d', 0

        spaceStr db ' %d', 0
        emptyStr db '%d', 0

        infinity db 'infinity', 0
        point db ',', 0

        A dd ?
        B dd ?
        C dd ?

        NULL = 0

section '.code' code readable executable

        begin:
                push strA
                call [printf]

                push A
                push spaceStr
                call [scanf]

                ;B scanning
                push strB
                call [printf]

                push B
                push spaceStr
                call [scanf]

                push strOp
                call [printf]

                call [getch] ;Read the entered value from the keyboard

                cmp eax, 43 ;+ true or false
                jne notAdd
                    mov ecx, [A]
                    add ecx, [B]

                    push ecx
                    push resultStr
                    call [printf]

                    jmp finish
                notAdd:

                cmp eax, 45 ;-
                jne notSub
                    mov ecx, [A]
                    sub ecx, [B]

                    push ecx
                    push resultStr
                    call [printf]

                    jmp finish

                notSub:

                cmp eax, 42 ;*
                jne notMul
                    mov ecx, [A]
                    imul ecx, [B]

                    push ecx
                    push resultStr
                    call [printf]

                    jmp finish

                notMul:

                cmp eax, 37 ;% Format "I num/den", I - integer, num - numerator, den - denominator.
                jne notMod
                    mov eax, [A]
                    mov ecx, [B]
                    mov edx, 0

                    cmp [B], 0 ;checking whether B = 0
                    jne notNullDiv
                        push infinity
                        call [printf]

                        jmp finish
                    notNullDiv:

                    div ecx
                    mov [C], edx

                    push eax
                    push resultStr
                    call [printf]

                    push [C] ;remainder.
                    push spaceStr
                    call [printf]

                    push [B]
                    push resMod
                    call [printf]

                    jmp finish

                notMod:

                cmp eax, 47 ;/
                jne notDiv
                    mov eax, [A]
                    mov ecx, [B]
                    mov edx, 0

                    cmp [B], 0
                    jne notNullDiv1
                        push infinity
                        call [printf]

                        jmp finish
                    notNullDiv1:

                    div ecx
                    mov [C], edx

                    push eax
                    push resultStr
                    call [printf]

                    push point
                    call [printf]

                    mov ebx, 0 ;counter

                notDiv:

                lp: ;loop

                        mov eax, [C]
                        mov ecx, [B]
                        imul eax, 10

                        mov edx, 0

                        div ecx
                        mov [C], edx

                        push eax
                        push emptyStr
                        call [printf]

                        add ebx, 1 ; counter++
                        cmp ebx, 3 ; 0.xxx
                jne lp ;if ebx != 3, continue

                jmp finish


                finish:

                call [getch]

                push NULL
                call [ExitProcess]

section '.idata' import data readable

        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'