#!/usr/bin/env lua

local clownmd5 = require "build_tools.lua.clownmd5"

-- Prevent build.lua's calls to os.exit from terminating the program.
local os_exit = os.exit
os.exit = coroutine.yield

-- Build the ROM.
local co = coroutine.create(function() dofile("build.lua") end)
assert(coroutine.resume(co))

-- Restore os.exit back to normal.
os.exit = os_exit

-- Hash the ROM.
local hash = clownmd5.HashFile("s2testhackbuilt.bin")

-- Verify the hash against known builds.
print "-------------------------------------------------------------"

if hash == "\x11\xD8\xD0\xD1\xD1\x19\xD9\xC7\x31\xBB\xF1\xF3\x03\x2F\xF0\x32" then
	print "ROM is bit-perfect with REV02 (speculative)."
else
	print "ROM is not bit-perfect with REV02."
end
