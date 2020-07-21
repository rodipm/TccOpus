# https: // ruslanspivak.com/lsbasi-part1/

# TERMINAIS PARA EIP

# START, END, SIMPLE, ONETOMANY

# START = Message
# END = MessageEndpoint
# SIMPLE = Pipes, Filters, Translators, Spliter, Aggregator, Transformation
# ONETOMANY = Routers

# Gramática

# route = START (transformation | fork)*
# fork = ONETOMANY transformation (transformation)*
# transformation = (SIMPLE)* END

# route = START (path)*
# path = transformation | fork
# fork = ONETOMANY path (path)*
# transformation = (SIMPLE | fork)* END

# route := START transformation
# transformation := (SIMPLE)* (END | fork)
# fork := ONETOMANY transformation

from copy import deepcopy
import sys

START, END, SIMPLE, ONETOMANY, EOF = (
    'START', 'END', 'SIMPLE', 'ONETOMANY', 'EOF'
)


class Token(object):
    def __init__(self, type, value):
        # token type: START, END, SIMPLE, ONETOMANY
        self.type = type
        # token value: Elementos EIP
        self.value = value

    def __str__(self):
        return 'Token({type}, {value})'.format(
            type=self.type,
            value=repr(self.value)
        )

    def __repr__(self):
        return self.__str__()


class Lexer(object):
    def __init__(self, diagramElements, startElement):
        # elementos do diagrama
        self.diagramElements = diagramElements
        self.diagramTokens = [
            x for x in self.tokenize_diagram(startElement).split(" ") if x != ""]
        print(self.diagramTokens)
        self.pos = 0

    def error(self):
        raise Exception('Invalid Element')

    def get_next_token(self):
        if self.pos == len(self.diagramTokens):
            return Token(EOF, None)

        nextToken = Token(self.diagramTokens[self.pos], "")
        self.pos += 1
        return nextToken

    def tokenize_diagram(self, current_node_number="0", tokenized="", visited_nodes=[]):
        if current_node_number not in visited_nodes:
            current_node = self.diagramElements[str(current_node_number)]

            new_visited_nodes = deepcopy(visited_nodes)
            new_visited_nodes.append(current_node_number)

            nonTerminal = "NONE"
            if current_node['type'] in ["Message"]:
                nonTerminal = "START"
            elif current_node['type'] in ["MessageTranslator", "MessageFilter"]:
                nonTerminal = "SIMPLE"
            elif current_node['type'] in ["ContentBasedRouter"]:
                nonTerminal = "ONETOMANY"
            elif current_node['type'] in ["MessageEndpoint"]:
                nonTerminal = "END"

            new_tokenized = f"{nonTerminal} "

            if current_node['type'] == 'PollingConsumer' or current_node['type'] == "Message":
                for child_node_number in current_node['connectsTo']:
                    return new_tokenized + self.tokenize_diagram(child_node_number, tokenized, new_visited_nodes)

            if current_node['type'] == 'MessageTranslator':
                for child_node_number in current_node['connectsTo']:
                    return new_tokenized + self.tokenize_diagram(child_node_number, tokenized, new_visited_nodes)

            if current_node['type'] == "ContentBasedRouter":

                forks = []
                for child_node_number in current_node['connectsTo']:
                    forks.append(self.tokenize_diagram(
                        child_node_number, tokenized, new_visited_nodes))

                return tokenized + " " + new_tokenized + "".join(forks)

            if current_node['type'] == 'MessageFilter':
                for child_node_number in current_node['connectsTo']:
                    return tokenized + new_tokenized + self.tokenize_diagram(child_node_number, tokenized, new_visited_nodes)

            if current_node['type'] == "MessageEndpoint":
                return tokenized + new_tokenized

            return tokenized


class Interpreter(object):
    def __init__(self, lexer):
        self.lexer = lexer
        # set current token to the first token taken from the input
        self.current_token = self.lexer.get_next_token()

    def error(self):
        raise Exception('Invalid syntax')

    def eat(self, token_type):
        # compare the current token type with the passed token
        # type and if they match then "eat" the current token
        # and assign the next token to the self.current_token,
        # otherwise raise an exception.
        if self.current_token.type == token_type:
            self.current_token = self.lexer.get_next_token()
        else:
            self.error()


    def fork(self):
        """fork := ONETOMANY transformation"""

        token = self.current_token
        if token.type == ONETOMANY:
            self.eat(ONETOMANY)
            print("[FORK] consumido ONETOMANY")
        else:
            raise Exception(
                f"Erro de sintaxe [FORK]: esperado {ONETOMANY} - encontrado {self.current_token.type}")

        token = self.current_token
        if token.type:
            print(f"[FORK] Token atual {token}. Indo para [TRNSF]")
            self.transformation()
        else:
            raise Exception(
                f"Erro de sintaxe [FORK]: esperado {SIMPLE} | {END} | {ONETOMANY} - encontrado {self.current_token.type}")

    def transformation(self):
        """transformation := (SIMPLE)* (END | fork)"""

        token = self.current_token
        while self.current_token.type in (SIMPLE):
            token = self.current_token
            if token.type == SIMPLE:
                self.eat(SIMPLE)
                print("[TRANSF] consumido SIMPLE")

        token = self.current_token
        if token.type == END:
            self.eat(END)
            print("[TRANSF] consumido END")
        elif token.type == ONETOMANY:
            print(f"[TRANSF] Token atual {token}. Indo para [FORK]")
            self.fork()
        else:
            raise Exception(
                f"Erro de sintaxe [TRANSF]: esperado {END} | {ONETOMANY} - encontrado {self.current_token.type}")

    def route(self):
        """route = START transformation"""

        token = self.current_token
        if token.type == START:
            self.eat(START)
            print("[ROUTE] START consumido")
        else:
            raise Exception(
                f"Erro de sintaxe [ROUTE]: esperado {START} - encontrado {self.current_token.type}")

        token = self.current_token
        if token.type:
            print(f"[ROUTE] Token atual {token}. Indo para [TRANSF]")
            self.transformation()
        else:
            raise Exception(
                f"Erro de sintaxe [ROUTE]: esperado {SIMPLE} | {ONETOMANY} | {END} - encontrado {self.current_token.type}")


def parse(items_info):

    for itemKey in items_info:
        item = items_info[itemKey]

        if item['type'] == "Message":
            lexer = Lexer(items_info, itemKey)
            interpreter = Interpreter(lexer)
            try:
                interpreter.route()
            except Exception as ex:
                print(f"{ex.args[0]}")
                return False
    return True
