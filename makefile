build/program.tap:	build/loader.tap build/main.tap
	-@cat build/loader.tap build/main.tap > build/program.tap

build/loader.tap:	loader.bas
	-@bas2tap -a10 -sloader loader.bas build/loader.tap

build/main.tap:	main.z80
	-@vasmz80_oldstyle main.z80 -z80asm -chklabels -nocase -L main.lst -Fbin -o build/main.bin
	-@mctrd new build/main.tap
	-@mctrd add build/main.bin build/main.tap

clean:
	-@rm -f build/*.*
	-@rm -f *.lst

run:
	@make
	@fuse --tape build/program.tap -g 4x & disown

run-retroarch:
	@make
	@retroarch -D -L /usr/lib64/libretro/fuse_libretro.so build/program.tap & disown

clean-run:
	@make clean
	@make run
