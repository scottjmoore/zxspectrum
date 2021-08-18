program.tap:	loader.tap main.tap
	-@cat loader.tap main.tap > program.tap

loader.tap:	loader.bas
	-@bas2tap -a10 -sloader loader.bas loader.tap

main.tap:	main.z80
	-@pasmo --tap -d main.z80 main.tap

clean:
	-@rm -f *.tap

run:
	@make
	@fuse --tape program.tap -g 4x & disown

run-retroarch:
	@make
	@retroarch -D -L /usr/lib64/libretro/fuse_libretro.so ./program.tap & disown

clean-run:
	@make clean
	@make run
