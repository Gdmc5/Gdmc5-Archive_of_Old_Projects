#!/usr/bin/env lua

--------------
-- Settings --
--------------

---------------------
-- End of settings --
---------------------

local base = require "build_tools.lua.common"

local compression = improved_sound_driver_compression and "kosinski-optimised" or "kosinski"
os.exit(base.build_rom("sonic3k", "sonic3k", "-D Sonic3_Complete=1", "-p=FF -z=0," .. compression .. ",Size_of_Snd_driver_guess,before -z=1300," .. compression .. ",Size_of_Snd_driver2_guess,before", false, "https://github.com/sonicretro/skdisasm"))

-- Correct the ROM's header with a proper checksum and end-of-ROM value.
common.fix_header("sonic3k.bin")
