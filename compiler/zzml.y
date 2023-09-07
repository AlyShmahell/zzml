%{
    
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <iostream>
#include <stack>
#include <string>
#include <unordered_map>
#include "vendor/nlohmann/json.hpp"
#include "zzml.lexer.c"
using json = nlohmann::json;

std::vector<std::string> stack;
json res = {{"func", json({})}, {"text", json({})}};

void printer()
{
    std::string out = res.dump(4);
    std::cout << out << std::endl;
}

int errors = 0;
extern FILE* yyin;
void yyerror(const char* error)
{
       errors++;
       fprintf(stderr,
               "Parse error %d: %s at line %d, in statement: %s \n",
               errors,
               error,
               line,
               yytext);
       exit(1);
}

int yywrap()
{
    return 1;
}

%}

%union {
    char* string;
    int   integer;
}

%token RETURN NEWLINE
%token <string> TAGOPN TAGCLS TXT


%start START


%%
START: EXP	{
                std::cout<<std::endl;
                exit(0);
            };
EXP:
| RETURN
| NEWLINE
| EXP NEWLINE {
    printer();
}
| EXP TAGOPN {
    char*       tag = $2;
    std::string idx = std::to_string(res["func"].size());
    json tmp = {
                {"name", tag}
            
        };
    res["func"][idx] = tmp;
    stack.push_back(idx);
}
| EXP TAGCLS {
    stack.pop_back();
}
| EXP TXT {
    char* txt = $2;

    std::string idx = std::to_string(res["text"].size());
    std::reverse(stack.begin(), stack.end());
    json tmp = {
                {"val", txt},
                {"ops", stack}
            
    };
    std::reverse(stack.begin(), stack.end());
    res["text"][idx] = tmp;
}
%%


/**
 * Main
 */
int main(int argc, char *argv[])
{
    if(argc==2)
    {
        yyin =  fopen(argv[1], "r");
        if (yyin==NULL)
            {
                fprintf(stderr,
                    "error opening file (%s).\n",
                    argv[1]);
                exit(1);
            }
    }
    else if (argc==1)
    {
        yyin = stdin;
    }
    else
    {
        fprintf(stderr,
                "Too many arguments (%d).\n",
                argc-1);
        exit(1);
    }
    do
    {
        yyparse();
    }
    while(!feof(yyin));
    return 0;
}