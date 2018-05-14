#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <getopt.h>
#include <errno.h>
#include <assert.h>

#include "scheme-private.h"
#include "fasta.h"

extern pointer mk_fasta(scheme *sc,FastaPtr ptr);

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


extern void fasta_filter(scheme* sc,FILE* in);

 static const struct option loptions[] =
	{
	{"help", no_argument, NULL, 'h'},
	{"script", no_argument, NULL, 'f'},
	{NULL, 0, NULL, 0}
	};

int main(int argc,char** argv) {
	scheme sc;
	int retcode = 0;
	char* user_script_file = NULL;
	FILE* script_f = NULL;	   
    int opt;


    while ( (opt=getopt_long(argc,argv,"f:",loptions,NULL))>0 )
    	{
        switch (opt)
        {
        case 'f' : user_script_file  = optarg; break;
        case '?': break;
        default: return -1; break;
        }
       }
    if(user_script_file == NULL ) {
    	fprintf(stderr,"use script missing!\n");
    	return 2;
    }
	
    if(!scheme_init(&sc)) {
    	fprintf(stderr,"Could not initialize!\n");
    	return 2;
  	}
  	scheme_set_input_port_file(&sc, stdin);
  	scheme_set_output_port_file(&sc, stdout);
  	
  	script_f = fopen(user_script_file,"r");
  	if(script_f==NULL) {
	  	fprintf(stderr,"cannot open user script\n");
	  	return -1;
	  	}
  	scheme_load_named_file(&sc,script_f,user_script_file);
  	fclose(script_f);
  	
	if(argc==optind) {
		fasta_filter(&sc,stdin);
		}
	else {
		int i;
		for(i=optind;i<argc;i++) {
			FILE* in = fopen(argv[i],"r");
			if(in==NULL) {
				fprintf(stderr,"cannot open %s.\n",argv[i]);
				return -1;
				}
			fasta_filter(&sc,in);
			fclose(in);
			}
		}
	retcode=sc.retcode;
  	scheme_deinit(&sc);
	return retcode;
	}

