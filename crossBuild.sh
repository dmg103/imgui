#!/bin/bash

git checkout master
make APP=libImguiLinux.a
rm -rf obj/
make APP=libImguiWin.a CC=x86_64-w64-mingw32-g++
rm -rf obj/

