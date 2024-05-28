%{
    
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <iostream>
#include <stack>
#include <string>
#include <regex>
#include <utility>
#include "Python.h"
#include "vendor/nlohmann/json.hpp"
#include "zzml.l.cpp"
using json = nlohmann::json;

std::pair<std::string, std::string> process(std::sregex_iterator &next, std::sregex_iterator &end){
    std::smatch match = *next;
    std::string name = match[1]; 
    std::string value = match[2]; 
    ++next;
    return std::make_pair(name, value);
}

std::regex opener(R"(\s*([^=\s<>]+)\s*((?:=)\s*(\"[^\"]*\"|\'[^\']*\'|[^>\s]+))?)");
std::regex  closer("</(\\w+)>");
std::smatch match;

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
    std::string       tag = $2;
    std::cout<<tag<<std::endl;
    std::vector<std::string> params;
    std::string name;
    if (std::regex_search(tag, match, opener)) {
        std::sregex_iterator next(tag.begin(), tag.end(), opener);
        std::sregex_iterator end;

        std::pair<std::string, std::string> header = process(next, end);
        name   = header.first;
        while (next != end) {
            
            std::pair<std::string, std::string> param = process(next, end);
            params.push_back(param.first+param.second);
        }
    } else {
        throw std::runtime_error("ill formatted opening tag: " + tag);
    }
    std::string idx = std::to_string(res["func"].size());
    json tmp = {
                {"name", name},
                {"params", params}
            
        };
    res["func"][idx] = tmp;
    stack.push_back(idx);
}
| EXP TAGCLS {
    std::string       tag = $2;
    std::string name;
    if (std::regex_search(tag, match, closer)) {
        name   = match[1];
        if (name!=res["func"][stack.back()]["name"])
        {
            throw std::runtime_error("mismatched closing tag: " + tag);
        }
    }
    else {
        throw std::runtime_error("ill formatted closing tag: " + tag);
    }
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

static PyObject * zzml(PyObject * self, PyObject * args)
{
  char * input;
  PyObject * ret;         
  if (!PyArg_ParseTuple(args, "s", &input)) {
    return NULL;
  }
  yy_scan_string(input);
  yyparse();
  printer();
  // build the resulting string into a Python object.
  ret = PyBytes_FromString(res.dump().c_str());
  return ret;
}

static PyMethodDef Methods[] = {
  { "zzml", zzml, METH_VARARGS},
  { NULL, NULL, 0, NULL}
};

static struct PyModuleDef definition = {
    PyModuleDef_HEAD_INIT,
    "zzml",
    "A Python module extension for C++ lib",
    -1,
    Methods
};
PyMODINIT_FUNC PyInit_zzml(void) {
    Py_Initialize();
    return PyModule_Create(&definition);
}