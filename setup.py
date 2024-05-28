import os
from distutils.core import setup, Extension as _Extension

class Extension(_Extension):
    def __init__(self, *args, prefix_scripts, **kwargs):
        for prefix_script in prefix_scripts:
            os.system(prefix_script)
        super().__init__(*args, **kwargs)

zzml = Extension(
    'zzml',
    sources=['build/zzml.y.cpp'],
    extra_compile_args=["-fPIC", "-std=c++11", "-I./parser", os.popen("python3-config --cflags --libs --embed").read()], 
    language="c++",
    prefix_scripts=[
        "rm   -rf build",
        "mkdir -p build",
        "flex  --outfile build/zzml.l.cpp                     parser/zzml.l",
        "bison -d     -o build/zzml.y.hpp -o build/zzml.y.cpp parser/zzml.y"
    ]
)

setup(
    name='zzml', 
    version='0.1',
    python_requires='>=3.10',
    description='SSML (Speech Synthesis Markup Language) Preprocessor/Interpreter/Compiler.',
    packages=['build'],
    ext_modules=[zzml]
)