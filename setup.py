import os
from distutils.core import setup, Extension as _Extension

class Extension(_Extension):
    def __init__(self, *args, prefix_scripts, **kwargs):
        for prefix_script in prefix_scripts:
            os.system(prefix_script)
        super().__init__(*args, **kwargs)

ssml = Extension(
    'ssml',
    sources=['build/ssml.y.cpp'],
    extra_compile_args=["-fPIC", "-std=c++11", "-I./ssml", os.popen("python3-config --cflags --libs --embed").read()], 
    language="c++",
    prefix_scripts=[
        "rm          -rf build",
        "mkdir        -p build",
        "flex  --outfile build/ssml.l.cpp                     ssml/ssml.l",
        "bison -d     -o build/ssml.y.hpp -o build/ssml.y.cpp ssml/ssml.y"
    ]
)

setup(
    name='zzml', 
    version='0.1',
    python_requires='>=3.10',
    description='SSML (Speech Synthesis Markup Language) Preprocessor/Interpreter/Compiler.',
    packages=['zzml'],
    ext_modules=[ssml]
)