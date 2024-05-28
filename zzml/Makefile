SHELL:=/bin/bash

all: build

build: zzml.l zzml.y
	mkdir -p build
	flex  --outfile build/zzml.lexer.c                         zzml.l 
	bison -d     -o build/zzml.parser.h -o build/zzml.parser.c zzml.y
	g++             build/zzml.parser.c -o build/zzml                 -std=c++11 -I./

clean:
	shopt -s extglob;\
	eval 'rm -vr build'
