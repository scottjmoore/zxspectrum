#!/usr/bin/bash

bas2tap -a10 -sloader loader.bas loader.tap
pasmo --tap -d main.z80 main.tap
cat loader.tap main.tap > program.tap
fuse --tape program.tap -g 4x