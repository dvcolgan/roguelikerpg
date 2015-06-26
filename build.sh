#!/bin/bash

#cat build/love.exe > build/roguelikerpg.exe
zip --exclude=*build* -r - * | cat build/love.exe - > build/roguelikerpg.exe

chmod +x build/roguelikerpg.exe
