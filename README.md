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
from zzml import zzml

print(
    zzml(
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <ssml>
            <speak>
                <p>
                    <break time="1s"> </break>
                    Hello, this is an example of a complex SSML document.
                    <emphasis level="strong">This text will be spoken with strong emphasis.</emphasis>
                    <prosody rate="slow">This text will be spoken at a slower pace.</prosody>
                    <p>
                    <break time="2s"> </break>
                        This is a paragraph break with a 2-second pause.
                        <say-as interpret-as="date">January 1, 2022</say-as>
                        <say-as interpret-as="time">12:30 PM</say-as>
                    </p>
                    <p>
                        <break time="1s"> </break>
                        This is another paragraph with a 1-second pause.
                        <phoneme alphabet="ipa" ph="tɪm ɪz ən ɔðər pɑrəɡræf">This is another paragraph.</phoneme>
                    </p>
                </p>
            </speak>
        </ssml>
        """
    )
)

```  

result:  
```sh
{
    "func": {
        "0": {
            "name": "?xml",
            "params": [
                "version=\"1.0\"",
                "encoding=\"UTF-8\"",
                "?"
            ]
        },
        "1": {
            "name": "ssml",
            "params": []
        },
        "10": {
            "name": "say-as",
            "params": [
                "interpret-as=\"time\""
            ]
        },
        "11": {
            "name": "p",
            "params": []
        },
        "12": {
            "name": "break",
            "params": [
                "time=\"1s\""
            ]
        },
        "13": {
            "name": "phoneme",
            "params": [
                "alphabet=\"ipa\"",
                "ph=\"tɪm ɪz ən ɔðər pɑrəɡræf\""
            ]
        },
        "2": {
            "name": "speak",
            "params": []
        },
        "3": {
            "name": "p",
            "params": []
        },
        "4": {
            "name": "break",
            "params": [
                "time=\"1s\""
            ]
        },
        "5": {
            "name": "emphasis",
            "params": [
                "level=\"strong\""
            ]
        },
        "6": {
            "name": "prosody",
            "params": [
                "rate=\"slow\""
            ]
        },
        "7": {
            "name": "p",
            "params": []
        },
        "8": {
            "name": "break",
            "params": [
                "time=\"2s\""
            ]
        },
        "9": {
            "name": "say-as",
            "params": [
                "interpret-as=\"date\""
            ]
        }
    },
    "text": {
        "0": {
            "ops": [
                "3",
                "2",
                "1",
                "0"
            ],
            "val": "                    Hello, this is an example of a complex SSML document."
        },
        "1": {
            "ops": [
                "5",
                "3",
                "2",
                "1",
                "0"
            ],
            "val": "This text will be spoken with strong emphasis."
        },
        "2": {
            "ops": [
                "6",
                "3",
                "2",
                "1",
                "0"
            ],
            "val": "This text will be spoken at a slower pace."
        },
        "3": {
            "ops": [
                "7",
                "3",
                "2",
                "1",
                "0"
            ],
            "val": "                        This is a paragraph break with a 2-second pause."
        },
        "4": {
            "ops": [
                "9",
                "7",
                "3",
                "2",
                "1",
                "0"
            ],
            "val": "January 1, 2022"
        },
        "5": {
            "ops": [
                "10",
                "7",
                "3",
                "2",
                "1",
                "0"
            ],
            "val": "12:30 PM"
        },
        "6": {
            "ops": [
                "11",
                "3",
                "2",
                "1",
                "0"
            ],
            "val": "                        This is another paragraph with a 1-second pause."
        },
        "7": {
            "ops": [
                "13",
                "11",
                "3",
                "2",
                "1",
                "0"
            ],
            "val": "This is another paragraph."
        }
    }
}
```