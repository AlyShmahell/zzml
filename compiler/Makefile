SHELL:=/bin/bash

all: build clean

build: zzml.l zzml.y
	flex zzml.l
	cp lex.yy.c zzml.lexer.c
	bison -d zzml.y
	cp zzml.tab.h zzml.tokens.h
	cp zzml.tab.c zzml.c
	g++ zzml.c -o zzml.elf -std=c++11

clean:
	shopt -s extglob;\
	eval 'rm -v !("zzml.l"|"zzml.y"|"zzml.elf"|"Makefile"|"vendor")'
