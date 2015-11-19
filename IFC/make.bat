set VS=C:\Program Files (x86)\Microsoft Visual Studio 14.0
set PyX64=C:\Program Files\Python 3.5
set PyX32=C:\Program Files (x86)\Python 3.5
set PyLib=python35.lib
set C_DLL=module1
set C_EXE=module2
set Python_C=module3

copy /y ifcengine\data\* *

echo ==== x86 ====

swig -python -DWIN32 %Python_C%.i

call "%VS%\VC\vcvarsall.bat"

cl %C_DLL%.c /I"ifcengine\include" "ifcengine\lib32\ifcengine.lib" /LD /D "_WINDOWS" /D "WIN32"
lib %C_DLL%.obj

cl %C_EXE%.c %C_DLL%.lib ifcengine\lib32\ifcengine.lib /D "WIN32"
copy /y ifcengine\bin32\ifcengine.dll ifcengine.dll
%C_EXE%.exe

cl %Python_C%_wrap.c /I"%PyX32%\include" "%PyX32%\libs\%PyLib%" %C_DLL%.lib "ifcengine\lib32\ifcengine.lib" /LD /Fe_%Python_C%.pyd /D "WIN32"
"%PyX32%\python.exe" runme.py

echo ==== x64 ====

swig -python -DWIN64 %Python_C%.i

call "%VS%\VC\vcvarsall.bat" amd64

cl %C_DLL%.c /I"ifcengine\include" "ifcengine\lib64\ifcengine.lib" /LD /D "_WINDOWS" /D "WIN64"
lib %C_DLL%.obj

cl %C_EXE%.c %C_DLL%.lib ifcengine\lib64\ifcengine.lib /D "WIN64"
copy /y ifcengine\bin64\ifcengine.dll ifcengine.dll
%C_EXE%.exe

cl %Python_C%_wrap.c /I"%PyX64%\include" "%PyX64%\libs\%PyLib%" %C_DLL%.lib "ifcengine\lib64\ifcengine.lib" /LD /Fe_%Python_C%.pyd /D "WIN64"
"%PyX64%\python.exe" runme.py