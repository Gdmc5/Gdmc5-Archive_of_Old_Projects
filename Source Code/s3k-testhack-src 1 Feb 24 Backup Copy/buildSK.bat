@ECHO OFF

REM // This file has been gutted and replaced with the Lua build script.
REM // It has been kept around for ease-of-use for Windows users.
"build_tools/Lua/lua.exe" buildSK.lua || pause REM // Pause on Lua parse failure so that the user can read the error message.

IF EXIST skbuilt.bin (
   ConvSym sonic3k.lst skbuilt.bin -input as_lst -a
   goto LABLEXIT
)
