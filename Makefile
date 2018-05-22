# Makefile for TinyScheme
# Time-stamp: <2002-06-24 14:13:27 gildea>
SHELL:=/bin/bash

HSTLIB?=../htslib

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
LDFLAGS = -L$(HSTLIB) -shared
DEBUG=-g -Wno-char-subscripts -O
SYS_LIBS= -ldl -lm -lhts
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

define EXEC_APP
LD_LIBRARY_PATH=$(HSTLIB) ./$(APPNAME)
endef

CFLAGS = $(PLATFORM_CFLAGS) -I$(HSTLIB) -DUSE_DL=1 -DUSE_MATH=1 -DUSE_ASCII_NAMES=0 -DTINYSCHEME_EXTENDED=1 -DSTANDALONE=0
APPNAME=scheme

OBJS = $(addsuffix .$(Osuf),$(APPNAME) dynload init_scm_str)

LIBTARGET = $(addsuffix .$(SOsuf),$(LIBPREFIX)tiny$(APPNAME))
STATICLIBTARGET = $(addsuffix .$(LIBsuf),$(LIBPREFIX)tiny$(APPNAME))

.PHONY: all clean test test-extended

all: test $(LIBTARGET) $(STATICLIBTARGET)

test : test-bam

test-bam: $(addsuffix $(EXE_EXT),$(APPNAME))
	$(EXEC_APP) -f test01.scm ../jvarkit-git/src/test/resources/S1.bam
	$(EXEC_APP) -f test02.scm ../jvarkit-git/src/test/resources/S1.bam
	$(EXEC_APP) -f test03.scm ../jvarkit-git/src/test/resources/S1.bam
	$(EXEC_APP) -f test04.scm ../jvarkit-git/src/test/resources/S1.bam

test-extended: $(addsuffix $(EXE_EXT),$(APPNAME))
	echo '(display "AAA\n")' | $(EXEC_APP)  | grep AAA
	echo '(display (string-append "\n" (number->string (rand)) "\n") )' | $(EXEC_APP)  | awk '($$1>=0.0 && $$1<=1.0)' | grep -F '.'
	echo '(display (tolower "ABC\n"))' | $(EXEC_APP)  | grep abc
	echo '(display (toupper "abc\n"))' | $(EXEC_APP)  | grep ABC
	echo '(display (trim "  \n  A B C     \n"))' | $(EXEC_APP)  | grep "A B C"
	echo '(display (string-split "A B C " " "))' | $(EXEC_APP) | grep -F "#(A B C)"
	echo '(vector-length (string-split "A B C D E  " " "))' | $(EXEC_APP) | grep -F "5"
	echo '(display (normalize-space "  A    B \n C \n\n"))' | $(EXEC_APP) | grep "A B C"

%.$(Osuf): %.c
	$(CC) -I. -c $(CFLAGS) $(DEBUG) $(CFLAGS) $(DL_FLAGS) $<

$(LIBTARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(SYS_LIBS)

$(addsuffix $(EXE_EXT),scheme) : $(OBJS)
	$(CC) -o $@ $(DEBUG)  -L$(HSTLIB) $(OBJS) $(SYS_LIBS)

$(STATICLIBTARGET): $(OBJS)
	$(AR) $@ $(OBJS)

$(OBJS): scheme.h scheme-private.h opdefines.h sam_scm.h
$(addsuffix $(Osuf),dynload): dynload.h


init_scm_str.c : init.scm
	echo 'const char* init_scm_str = "" ' > $@
	grep -v '^;' $< | sed -e 's/"/\\"/g' -e 's/^/"/' -e 's/$$/"/' >> $@
	echo '"";' >> $@


clean:
	$(RM) $(OBJS) $(LIBTARGET) $(STATICLIBTARGET) $(addsuffix $(EXE_EXT),$(APPNAME))
	$(RM) tinyscheme.ilk tinyscheme.map tinyscheme.pdb tinyscheme.exp
	$(RM) scheme.ilk scheme.map scheme.pdb scheme.lib scheme.exp init_scm_str.c
	$(RM) *~



TAGS_SRCS = scheme.h scheme.c dynload.h dynload.c

tags: TAGS
TAGS: $(TAGS_SRCS)
	etags $(TAGS_SRCS)

