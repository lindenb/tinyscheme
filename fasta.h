#ifndef FASTA_H
#define FASTA_H

#include <stdio.h>

typedef struct fasta_t
	{
	char* name;
	char* seq;
	} Fasta,*FastaPtr;

FastaPtr fasta_read(FILE* in);
void fasta_free(FastaPtr* seq);

#endif
