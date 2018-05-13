#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "fasta.h"

static char* str_append(char* s,char c,size_t* buff,size_t* size) {
	if(*size+2 >= *buff) {
	    *buff += BUFSIZ;
		s = (char*)realloc(s,*buff);
		}
	s[*size] = c;
	s[*size + 1] = 0;
	*size += 1;
	return s;
	}

FastaPtr fasta_read(FILE* in) {
	size_t size=0UL,buff=0UL;
	FastaPtr ptr = NULL;
	while(!feof(in)) {
		int c = fgetc(in);
		if(c=='>') {
			if(ptr!=NULL) {
				ungetc(c,in);
				return ptr;
				}
			ptr = (FastaPtr)calloc(1UL,sizeof(Fasta));
			ptr->name=(char*)malloc(BUFSIZ);
			ptr->name[0] = 0;
			ptr->seq=(char*)malloc(BUFSIZ);
			ptr->seq[0] = 0;
			buff = BUFSIZ;
			size = 0UL;
			while((c=fgetc(in))!=EOF && c!='\n')
				{
				ptr->name = str_append(ptr->name,c,&buff,&size);
				}
			buff = BUFSIZ;
			size = 0UL;
			}
		else
			{
			if(ptr==NULL || isspace(c)) continue;
			ptr->seq = str_append(ptr->seq,c,&buff,&size);
			}
		}
  return ptr;
  }

void fasta_free(FastaPtr seq) {
	if(seq==NULL) return;
	free(seq->name);
	free(seq->seq);
	free(seq);
	}

static void fasta_filter(FILE* in) {
for(;;) {
     FastaPtr seq = fasta_read(in);
     if(seq==NULL) break;
     printf("%s %d\n",seq->name,(int)strlen(seq->seq));
	 fasta_free(seq);
	}

}

int main(int argc,char** argv) {
	if(argc==1) {
		fasta_filter(stdin);
		}
	else {
		int i;
		for(i=1;i<argc;i++) {
			FILE* in = fopen(argv[i],"r");
			if(in==NULL) {
				fprintf(stderr,"cannot open %s.\n",argv[i]);
				return -1;
				}
			fasta_filter(in);
			fclose(in);
			}
		}
	return 0;
	}

