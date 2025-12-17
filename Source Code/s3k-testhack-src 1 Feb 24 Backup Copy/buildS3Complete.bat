@ECHO OFF

REM // This file has been gutted and replaced with the Lua build script.
REM // It has been kept around for ease-of-use for Windows users.
"build_tools/Lua/lua.exe" buildS3Complete.lua || pause REM // Pause on Lua parse failure so that the user can read the error message.

IF EXIST sonic3k.bin (
   ConvSym sonic3k.lst sonic3k.bin -input as_lst -a
   goto LABLEXIT
)
