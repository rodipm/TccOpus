https://ruslanspivak.com/lsbasi-part1/

# TERMINAIS PARA EIP

START, END, SIMPLE, ONETOMANY

START = Message
END = MessageEndpoint
SIMPLE = Pipes, Filters, Translators, Spliter, Aggregator, Transformation
ONETOMANY = Routers

# Gramática

route = START (transformation | fork)*
fork = ONETOMANY transformation (transformation)*
transformation = SIMPLE (SIMPLE)* END


