#!/bin/bash

make APP=libImguiLinux.a
git checkout master
make APP=libImguiWin.a CC=x86_64-w64-mingw32-g++
git checkout docking
