# OS X users should use additionally gcc-6, gcc will invoke the Clang compiler
CC=gcc-6
CFLAGS=-std=c11 -Wall -Werror -Wextra -pedantic -g

.PHONY: clean all

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

