/** BEGIN-OF-EXTENDED-SECTION */
    _OP_DEF(opexe_ext, "rand",                           0,  0,       0,                               OP_RAND             )
    _OP_DEF(opexe_ext, "toupper",                        1,  1,       TST_STRING,                      OP_TOUPPER          )
    _OP_DEF(opexe_ext, "tolower",                        1,  1,       TST_STRING,                      OP_TOLOWER          )
    _OP_DEF(opexe_ext, "trim",                           1,  1,       TST_STRING,                      OP_TRIM             )
    
#if USE_REGEX
    _OP_DEF(opexe_ext, "regcomp",                        1,  2,   TST_STRING TST_STRING,            OP_REGCOMP          )
    _OP_DEF(opexe_ext, "string-match",                   2,  2,   TST_STRING  TST_ANY ,             OP_REGMATCH         )
#endif

/** END-OF-EXTENDED-SECTION */

