luastaticlib = /mingw64/lib/libluajit-5.1.a
luaincludedir = /mingw64/include/luajit-2.0/
all:
	luajit luastatic.lua \
	  init.lua \
	  $(luastaticlib) \
	  -I$(luaincludedir) -o valvekiller.exe
