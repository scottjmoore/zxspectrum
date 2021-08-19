program.tap:	loader.tap main.tap
	-@cat loader.tap main.tap > program.tap

loader.tap:	loader.bas
	-@bas2tap -a10 -sloader loader.bas loader.tap

main.tap:	main.z80
	-@vasmz80_oldstyle main.z80 -z80asm -chklabels -nocase -L main.lst -Fbin -o main.bin
	-@mctrd new main.tap
	-@mctrd add main.bin main.tap

clean:
	-@rm -f *.tap
	-@rm -f *.bin
	-@rm -f *.lst

run:
	@make
	@fuse --tape program.tap -g 4x & disown

run-retroarch:
	@make
	@retroarch -D -L /usr/lib64/libretro/fuse_libretro.so ./program.tap & disown

clean-run:
	@make clean
	@make run
