format PE console 4.0
entry start
 
include 'win32ax.inc'
 
 
 
section '.text' code readable executable
 
  start:
        cinvoke fopen, name, mode
        mov     [F],   eax
        ;cinvoke gets, Buffer
        ;cinvoke puts, text
        cinvoke fputs, text, [F]
        cinvoke fclose, [F]
 
        ;ожидание нажатия ENTER
        ;cinvoke printf, aszPressEnter
        ;invoke  _getch
 
        invoke  ExitProcess, 0
 
section '.data' data readable writeable
        aszPressEnter   db      0Dh, 0Ah, 0Dh, 0Ah, "Press any key to exit", 0
        aszCrLf         db      0Dh, 0Ah, 0
        LenCrLf         dd      $-aszCrLf-1
 
        name            db      'writeToFile_2.txt', 0
        mode            db      'w', 0
        text            db      'Write this text to file', 0
 
section '.bss' readable writeable
        hConsoleOutput  dd      ?
        hConsoleInput   dd      ?
        CountWords      dd      ?
        Buffer          db      1024 dup(?)
        BufLen          dd      ?
        F               dd      ?
 
section '.idata' import data readable writeable
 
        library kernel32,'KERNEL32.DLL',\
                user32,'USER32.DLL',\
                msvcrt, 'msvcrt.dll'
 
        include 'api\kernel32.inc'
        include 'api\user32.inc'
        import  msvcrt,\
                fopen, 'fopen',\
                gets, 'gets',\
                fputs, 'fputs',\
                puts, 'puts',\
                fclose, 'fclose',\
                printf, 'printf',\
                scanf,  'scanf',\
                _getch, '_getch'