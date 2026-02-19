@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "REPO_DIR=%cd%"
set "VS_DIR=C:\Program Files\Microsoft Visual Studio\18\Community"

call :BUILD_WIN32 x86
call :BUILD_WIN32 x64

exit /b %ERRORLEVEL%

:BUILD_WIN32
    echo build win32-%1...

    call "%VS_DIR%\VC\Auxiliary\Build\vcvarsall.bat" %1 || exit /b 1

    pushd "%REPO_DIR%\luajit\src" || exit /b 1
    call msvcbuild.bat || exit /b 1
    popd

    rmdir /s /q "generated\win32-%1" 2>nul

    mkdir "generated\win32-%1\lib"
    mkdir "generated\win32-%1\include"

    robocopy "luajit\src" "generated\win32-%1\lib" lua51.lib
    robocopy "luajit\src" "generated\win32-%1\include" lua.h lualib.h lauxlib.h luaconf.h lua.hpp

    echo build win32-%1...Done
exit /b 0