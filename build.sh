#!/usr/bin/bash

pasmo --tap main.z80 main.tap
bas2tap -a loader.bas
cat loader.tap main.tap > program.tap
fuse --tape program.tap -g 4x