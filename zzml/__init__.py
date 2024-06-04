from   ssml import ssml
import re 
import json 
import logging
import numpy       as np
from   copy    import copy 

logging.basicConfig(
    level=logging.DEBUG
)

def zzml(text):
    data = json.loads(ssml(text))
    return data

class Base:
    def __opt__(self, op):
        pass
    def __call__(self, text, ops):
        self.variations = [func for func in dir(self) if callable(getattr(self, func)) and not func.startswith("__")]
        for op in ops:
            try:
                name, *args = self.__opt__(op)
                if name not in self.variations:
                    raise Exception(f"{param} not in {self.variations}")
                return getattr(self, name)(text, *args)
            except Exception as e:
                logging.error(e)


class SayAS(Base):
    def __call__(self, text, ops):
        super().__call__(text, ops)
        