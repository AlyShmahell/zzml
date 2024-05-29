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

class Parser {
    private:
        const std::regex opener{R"(\s*([^=\s<>]+)\s*((?:=)\s*(\"[^\"]*\"|\'[^\']*\'|[^>\s]+))?)"};
        const std::regex closer{"</(\\w+)>"};
        std::smatch match;
        std::vector<std::string> stack;
        json res;
        std::pair<std::string, std::string> process(std::sregex_iterator &next, std::sregex_iterator &end){
            std::smatch match = *next;
            std::string name  = match[1]; 
            std::string value = match[2]; 
            ++next;
            return std::make_pair(name, value);
        }   
    public:
        Parser(): 
            res({{"func", json({})}, {"text", json({})}})
        {
            
        }
        void printer()
        {
            std::string out = this->res.dump(4);
            std::cout << out << std::endl;
        }
        const char* c_str(){
            return this->res.dump(4).c_str();
        }
        void tagopn(std::string tag){
            std::vector<std::string> params;
            std::string name;
            if (std::regex_search(tag, match, opener)) {
                std::sregex_iterator next(tag.begin(), tag.end(), opener);
                std::sregex_iterator end;
                std::pair<std::string, std::string> header = this->process(next, end);
                name   = header.first;
                while (next != end) {
                    std::pair<std::string, std::string> param = this->process(next, end);
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
            this->res["func"][idx] = tmp;
            this->stack.push_back(idx);
        }
        void tagcls(std::string tag){
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
            this->stack.pop_back();
        }
        void text(char* txt){
            std::string idx = std::to_string(res["text"].size());
            std::reverse(stack.begin(), stack.end());
            json tmp = {
                        {"val", txt},
                        {"ops", stack}
            };
            std::reverse(stack.begin(), stack.end());
            res["text"][idx] = tmp;
        }
}
parser = Parser();

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
    parser.printer();
}
| EXP TAGOPN {
    std::string       tag = $2;
    parser.tagopn(tag);
}
| EXP TAGCLS {
    std::string       tag = $2;
    parser.tagcls(tag);
}
| EXP TXT {
    char* txt = $2;
    parser.text(txt);
}
%%

static PyObject * zzml(PyObject * self, PyObject * args)
{
  char * input;
  PyObject * ret;         
  if (!PyArg_ParseTuple(args, "s", &input)) {
    return NULL;
  }
  yy_scan_string(input);
  yyparse();
  ret = PyBytes_FromString(parser.c_str());
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