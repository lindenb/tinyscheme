#ifndef SAM_SCM_HH
#define SAM_SCM_HH

#include <htslib/sam.h>



typedef void* sam_scm_filter;

sam_scm_filter sam_scm_filter_from_file(const char* fname);
void sam_scm_filter_destroy(sam_scm_filter);

#endif

