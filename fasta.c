#include <stdlib.h>
#include <string.h>
#include "fasta.h"

static char* str_append(char* s,char c,size_t* buff,size_t* size) {
if(*size+1>=*buff) {
s = 
}
s[size] = c;
s[size+1] = 0;
*size += 1;
}

FastaPtr fasta_read(FILE* in) {
   FastaPtr ptr = NULL;
   while(!feof(in)) {
    int c= fgetc(in);
    if(c=='>') {
        if(ptr!=NULL) {
		fungetc(in,c);
		return ptr;
		}
        ptr->name=(char*)malloc(BUFZIZ);
        ptr->name[0]=0;
        ptr->seq=(char*)malloc(BUFZIZ);
        ptr->seq[0]=0;
        ptr = (FastaPtr)calloc(1,sizeof(Fasta));
	buff = BUFSIZE;
	size = 0UL;
        while((c=fgetc(in))!=EOF && c!='\n')
		{
		ptr->name = str_append(ptr->name,c,&buff,&size);
		}
        buff = BUFSIZE;
        size = 0UL;
	} else
    {
    if(ptr==NULL || isspace(c)) continue;
    ptr->seq = str_append(ptr->seq,c,&buff,&size);
    }
    return ptr;
    }

  }
void fasta_free(FastaPtr* seq) {
if(seq==NULL) return;
free(seq->name);
free(seq->seq);
free(seq);
}

#endif
