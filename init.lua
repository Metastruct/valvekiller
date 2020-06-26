local ffi  = require "ffi"

local kernel32 = ffi.load "kernel32"
local user32  = ffi.load "user32"

ffi.cdef "void *FindWindowA(const char *, const char *)"
ffi.cdef "bool  GetWindowThreadProcessId(void *, uint32_t *)"
ffi.cdef "void *OpenProcess(uint32_t, bool, uint32_t)"
ffi.cdef "void  CloseHandle(void *)"
ffi.cdef "void *GetModuleHandleA(const char *)"
ffi.cdef "void *GetProcAddress(void *, const char *)"
ffi.cdef "void *VirtualAllocEx(void *, void *, uint32_t, uint32_t, uint32_t)"
ffi.cdef "void  VirtualFreeEx(void *, void *, uint32_t, uint32_t)"
ffi.cdef "void *CreateRemoteThread(void *, void *, uint32_t, void *, void *, uint32_t, uint32_t *)"

local processid = ffi.new( "uint32_t[?]", 1 )
user32.GetWindowThreadProcessId( user32.FindWindowA( "Valve001", nil ), processid )

local game = ffi.gc( kernel32.OpenProcess( 0x043a, false, processid[0] ), kernel32.CloseHandle )
local ret = 0

if tonumber( ffi.cast( "intptr_t", game ) ) ~= 0 then
	local kernel32_ptr = kernel32.GetModuleHandleA( "kernel32.dll" )
	local lla_ptr  = kernel32.GetProcAddress( kernel32_ptr, "LoadLibraryA" )

	local garbage = kernel32.VirtualAllocEx( game, nil, 0x0100, 0x3000, 4 )


	kernel32.CreateRemoteThread( game, nil, 0, garbage, garbage, 0, nil )

	kernel32.VirtualFreeEx( game, garbage, 0, 0xc000 )
	
else
	print("Could not find Valve001")
	ret=1
end

kernel32.CloseHandle( ffi.gc( game, nil ) )

return ret