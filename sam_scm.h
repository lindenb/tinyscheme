#ifndef SAM_SCM_HH
#define SAM_SCM_HH

#include <htslib/sam.h>



typedef void* sam_scm_filter;

sam_scm_filter sam_scm_filter_from_file(const char* fname);
sam_scm_filter sam_scm_filter_from_string(const char* expr);
void sam_scm_filter_destroy(sam_scm_filter);

#endif

