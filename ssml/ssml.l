%{
#include <stdio.h>
#include "ssml.y.hpp"
int line = 1;
%}

%%
[ \t]+		;
\n          {return NEWLINE;}
"<"[^>^/]*> {yylval.string = yytext; return TAGOPN;}
"</"[^>]*>  {yylval.string = yytext; return TAGCLS;}
[^<\n]+     {yylval.string = yytext; return TXT;}
%%
