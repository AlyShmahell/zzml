# zzml
- SSML (Speech Synthesis Markup Language) Preprocessor/Interpreter/Compiler.  
- **work in progress**
## Requirements
```sh
sudo apt update && sudo apt install g++ flex bison python3-dev
```
## Installation
```sh
pip install git+https://github.com/AlyShmahell/zzml.git
```
## Example
```py
import zzml

print(
    zzml.zzml(
        """
        <speak>hello</speak>
        """
    )
)
```
