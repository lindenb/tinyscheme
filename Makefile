# Makefile for TinyScheme
# Time-stamp: <2002-06-24 14:13:27 gildea>
SHELL:=/bin/bash

# Windows/2000
#CC = cl -nologo
#DEBUG= -W3 -Z7 -MD
#DL_FLAGS=
#SYS_LIBS=
#Osuf=obj
#SOsuf=dll
#LIBsuf=.lib
#EXE_EXT=.exe
#LD = link -nologo
#LDFLAGS = -debug -map -dll -incremental:no
#LIBPREFIX =
#OUT = -out:$@
#RM= -del
#AR= echo

# Unix, generally
CC = gcc -fpic -pedantic
DEBUG=-g -Wall -Wno-char-subscripts -O
Osuf=o
SOsuf=so
LIBsuf=a
EXE_EXT=
LIBPREFIX=lib
RM= -rm -f
AR= ar crs

# Linux
LD = gcc
LDFLAGS = -shared
DEBUG=-g -Wno-char-subscripts -O
SYS_LIBS= -ldl -lm
PLATFORM_CFLAGS= 

# Cygwin
#PLATFORM_FEATURES = -DUSE_STRLWR=0

# MinGW/MSYS
#SOsuf=dll
#PLATFORM_FEATURES = -DUSE_STRLWR=0

# Mac OS X
#LD = gcc
#LDFLAGS = --dynamiclib
#DEBUG=-g -Wno-char-subscripts -O
#SYS_LIBS= -ldl
#PLATFORM_FEATURES= -DUSE_STRLWR=1 -D__APPLE__=1 -DOSX=1


# Solaris
#SYS_LIBS= -ldl -lc
#Osuf=o
#SOsuf=so
#EXE_EXT=
#LD = ld
#LDFLAGS = -G -Bsymbolic -z text
#LIBPREFIX = lib
#OUT = -o $@


CFLAGS = $(PLATFORM_CFLAGS) -DUSE_DL=1 -DUSE_MATH=1 -DUSE_ASCII_NAMES=0 -DTINYSCHEME_EXTENDED=1 -DUSE_REGEX=1
APPNAME=scheme

OBJS = $(addsuffix .$(Osuf),$(APPNAME) dynload)

LIBTARGET = $(addsuffix .$(SOsuf),$(LIBPREFIX)tiny$(APPNAME))
STATICLIBTARGET = $(addsuffix .$(LIBsuf),$(LIBPREFIX)tiny$(APPNAME))

.PHONY: all clean test test-extended

all: test $(LIBTARGET) $(STATICLIBTARGET)

test : test-extended

test-extended: $(addsuffix $(EXE_EXT),$(APPNAME))  
	echo '(display "AAA\n")' | ./$(APPNAME)  | grep AAA
	echo '(display (string-append "\n" (number->string (rand)) "\n") )' | ./$(APPNAME)  | awk '($$1>=0.0 && $$1<=1.0)' | grep -F '.'
	echo '(display (tolower "ABC\n"))' | ./$(APPNAME)  | grep abc
	echo '(display (toupper "abc\n"))' | ./$(APPNAME)  | grep ABC
	echo '(display (trim "  \n  A B C     \n"))' | ./$(APPNAME)  | grep "A B C"


%.$(Osuf): %.c
	$(CC) -I. -c $(CFLAGS) $(DEBUG) $(CFLAGS) $(DL_FLAGS) $<

$(LIBTARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(SYS_LIBS)

$(addsuffix $(EXE_EXT),scheme) : $(OBJS)
	$(CC) -o $@ $(DEBUG) $(OBJS) $(SYS_LIBS)

$(STATICLIBTARGET): $(OBJS)
	$(AR) $@ $(OBJS)

$(OBJS): scheme.h scheme-private.h opdefines.h
$(addsuffix $(Osuf),dynload): dynload.h

clean:
	$(RM) $(OBJS) $(LIBTARGET) $(STATICLIBTARGET) $(addsuffix $(EXE_EXT),$(APPNAME))
	$(RM) tinyscheme.ilk tinyscheme.map tinyscheme.pdb tinyscheme.exp
	$(RM) scheme.ilk scheme.map scheme.pdb scheme.lib scheme.exp
	$(RM) *~



TAGS_SRCS = scheme.h scheme.c dynload.h dynload.c

tags: TAGS
TAGS: $(TAGS_SRCS)
	etags $(TAGS_SRCS)

