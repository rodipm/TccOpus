# from copy import deepcopy
# # Token types
# #
# # EOF (end-of-file) token is used to indicate that
# # there is no more input left for lexical analysis
# START, END, SIMPLE, ONETOMANY, EOF = (
#    'START', 'END', 'SIMPLE', 'ONETOMANY', 'EOF'
# )


# class Token(object):
#     def __init__(self, type, value):
#         # token type: START, END, SIMPLE, ONETOMANY
#         self.type = type
#         # token value: Elementos EIP
#         self.value = value

#     def __str__(self):
#         """String representation of the class instance.

#         Examples:
#             Token(INTEGER, 3)
#             Token(PLUS, '+')
#             Token(MUL, '*')
#         """
#         return 'Token({type}, {value})'.format(
#             type=self.type,
#             value=repr(self.value)
#         )

#     def __repr__(self):
#         return self.__str__()


# class Lexer(object):
#     def __init__(self, diagramElements):
#         # elementos do diagrama
#         self.diagramElements = diagramElements
#         self.diagramTokens = [x for x in self.tokenize_diagram().split(" ") if  x != ""]
#         self.pos = 0
#         print("diagramTokens", self.diagramTokens)

#     def error(self):
#         raise Exception('Invalid Element')


#     def get_next_token(self):
#         """Lexical analyzer (also known as scanner or tokenizer)
#         """
#         if self.pos == len(self.diagramTokens):
#             print("EOFEOFEOFEFOEFOEOFEFOEFOEFOEOFEOFEOFEOFEOFE")
#             return Token(EOF, None)

#         # print("next token", self.diagramTokens[self.pos])
#         nextToken = Token(self.diagramTokens[self.pos], "")
#         self.pos += 1
#         return nextToken

#     def tokenize_diagram(self, current_node_number="0", tokenized="", visited_nodes=[]):
#         if current_node_number not in visited_nodes:
#             current_node = self.diagramElements[str(current_node_number)]
            
#             new_visited_nodes = deepcopy(visited_nodes)
#             new_visited_nodes.append(current_node_number)
#             print("visited nodes", visited_nodes)
#             print("tokenized", tokenized)

#             nonTerminal = "NONE"
#             if current_node['type'] in ["Message"]:
#                 nonTerminal = "START"
#             elif current_node['type'] in ["MessageTranslator", "MessageFilter"]:
#                 nonTerminal = "SIMPLE"
#             elif current_node['type'] in ["ContentBasedRouter"]:
#                 nonTerminal = "ONETOMANY"
#             elif current_node['type'] in ["MessageEndpoint"]:
#                 nonTerminal = "END"

#             new_tokenized = f"{nonTerminal} "

#             if current_node['type'] == 'PollingConsumer' or current_node['type'] == "Message":
#                 for child_node_number in current_node['connectsTo']:
#                     return new_tokenized + self.tokenize_diagram(child_node_number, tokenized, new_visited_nodes)
        
#             if current_node['type'] == 'MessageTranslator':
#                 for child_node_number in current_node['connectsTo']:
#                     return new_tokenized + self.tokenize_diagram(child_node_number, tokenized, new_visited_nodes)

#             if current_node['type'] == "ContentBasedRouter":

#                 forks = []            
#                 for child_node_number in current_node['connectsTo']:
#                         forks.append(self.tokenize_diagram(child_node_number, tokenized, new_visited_nodes))
                
#                 return tokenized + " " + new_tokenized + "".join(forks)

#             if current_node['type'] == 'MessageFilter':
#                 for child_node_number in current_node['connectsTo']:
#                     return tokenized + new_tokenized + self.tokenize_diagram(child_node_number, tokenized, new_visited_nodes)

#             if current_node['type'] == "MessageEndpoint":
#                 return tokenized + new_tokenized

#             return tokenized

# class Interpreter(object):
#     def __init__(self, lexer):
#         self.lexer = lexer
#         # set current token to the first token taken from the input
#         self.current_token = self.lexer.get_next_token()

#     def error(self):
#         raise Exception('Invalid syntax')

#     def eat(self, token_type):
#         # compare the current token type with the passed token
#         # type and if they match then "eat" the current token
#         # and assign the next token to the self.current_token,
#         # otherwise raise an exception.
#         if self.current_token.type == token_type:
#             self.current_token = self.lexer.get_next_token()
#         else:
#             self.error()

#     def transformation(self):
#         """transformation = SIMPLE (SIMPLE)* END"""
#         # print("TRANSFORMATION")
#         result = ""
        
#         token = self.current_token
#         if token.type == SIMPLE:
#             self.eat(SIMPLE)
#             result = token.type + ' '

#         while self.current_token.type in (SIMPLE):
#             token = self.current_token
#             if token.type == SIMPLE:
#                 self.eat(SIMPLE)
#                 result = result + token.type + ' '

#         token = self.current_token
#         if token.type == END:
#             self.eat(END)
#             result = result + token.type + ' '

#         return result

#     def fork(self):
#         """fork = ONETOMANY transformation (transformation)*"""
#         print("FORK")

#         result = ""

#         token = self.current_token
#         print("Current Token: ", token)
#         if token.type == ONETOMANY:
#             self.eat(ONETOMANY)
#             result = token.type + " "
#         else:
#             raise Exception(f"Erro de sintaxe: esperado {ONETOMANY} - encontrado {self.current_token.type}")

#         token = self.current_token
#         print("Current Token: ", token)
#         if token.type == SIMPLE:
#             result = result + self.transformation()
#         elif token.type == END:
#             result = result + self.transformation()
#         else:
#             raise Exception(f"Erro de sintaxe: esperado {SIMPLE} | {END} - encontrado {self.current_token.type}")

#         while self.current_token.type in (SIMPLE, END):
#             token = self.current_token
#             if token.type == SIMPLE:
#                 result = result + self.transformation()
#             elif token.type == END:
#                 result = result + self.transformation()
#             else:
#                 raise Exception(f"Erro de sintaxe: esperado {SIMPLE} | {END} - encontrado {self.current_token.type}")

#         return result

#     def route(self):
#         """route = START (transformation | fork)*"""
        
#         result = ""

#         token = self.current_token
#         if token.type == START:
#             self.eat(START)
#             result = token.type + " "
#         else:
#             raise Exception(f"Erro de sintaxe: esperado {START} - encontrado {self.current_token.type}")

#         while self.current_token.type in (SIMPLE, ONETOMANY):
#             token = self.current_token
#             if token.type == ONETOMANY:
#                 result = result + self.fork()
#             elif token.type == SIMPLE:
#                 result = result + self.transformation()
#             else:
#                 raise Exception(f"Erro de sintaxe: esperado {SIMPLE} | {ONETOMANY} - encontrado {self.current_token.type}")

#         return result


# def main():

#     # diagramElements = {
#     # '0': {'id': 0, 'type': 'Message', 'connectsTo': ['1']}, 
#     # '1': {'id': 1, 'type': 'ContentBasedRouter', 'connectsTo': ['5', '6', '4']}, 
#     # '2': {'id': 2, 'type': 'MessageEndpoint', 'connectsTo': []}, 
#     # '3': {'id': 3, 'type': 'MessageEndpoint', 'connectsTo': []}, 
#     # '4': {'id': 4, 'type': 'MessageEndpoint', 'connectsTo': []}, 
#     # '5': {'id': 5, 'type': 'MessageTranslator', 'connectsTo': ['2']}, 
#     # '6': {'id': 6, 'type': 'MessageFilter', 'connectsTo': ['3']}}

#     diagramElements = {
#     '0': {'id': 0, 'type': 'Message', 'connectsTo': ['1']}, 
#     '1': {'id': 1, 'type': 'ContentBasedRouter', 'connectsTo': ['5', '6', '4']}, 
#     '2': {'id': 2, 'type': 'MessageEndpoint', 'connectsTo': []}, 
#     '3': {'id': 3, 'type': 'MessageEndpoint', 'connectsTo': []}, 
#     '4': {'id': 4, 'type': 'MessageEndpoint', 'connectsTo': []}, 
#     '5': {'id': 5, 'type': 'MessageTranslator', 'connectsTo': ['2']}, 
#     '6': {'id': 6, 'type': 'MessageFilter', 'connectsTo': ['3']}}

#     lexer = Lexer(diagramElements)
#     interpreter = Interpreter(lexer)
#     result = interpreter.route()
#     print(result)


# if __name__ == '__main__':
#     main()

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

    def transformation(self):
        """transformation = SIMPLE (SIMPLE)* END"""
        result = ""

        token = self.current_token
        if token.type == SIMPLE:
            self.eat(SIMPLE)

        while self.current_token.type in (SIMPLE):
            token = self.current_token
            if token.type == SIMPLE:
                self.eat(SIMPLE)

        token = self.current_token
        if token.type == END:
            self.eat(END)

        return result

    def fork(self):
        """fork = ONETOMANY transformation (transformation)*"""

        result = ""

        token = self.current_token
        if token.type == ONETOMANY:
            self.eat(ONETOMANY)
        else:
            raise Exception(
                f"Erro de sintaxe: esperado {ONETOMANY} - encontrado {self.current_token.type}")

        token = self.current_token
        if token.type == SIMPLE:
            self.transformation()
        elif token.type == END:
            self.transformation()
        else:
            raise Exception(
                f"Erro de sintaxe: esperado {SIMPLE} | {END} - encontrado {self.current_token.type}")

        while self.current_token.type in (SIMPLE, END):
            token = self.current_token
            if token.type == SIMPLE:
                self.transformation()
            elif token.type == END:
                self.transformation()
            else:
                raise Exception(
                    f"Erro de sintaxe: esperado {SIMPLE} | {END} - encontrado {self.current_token.type}")

        return result

    def route(self):
        """route = START (transformation | fork)*"""

        result = ""

        token = self.current_token
        if token.type == START:
            self.eat(START)
        else:
            raise Exception(
                f"Erro de sintaxe: esperado {START} - encontrado {self.current_token.type}")

        while self.current_token.type in (SIMPLE, ONETOMANY):
            token = self.current_token
            if token.type == ONETOMANY:
                self.fork()
            elif token.type == SIMPLE:
                pass
            else:
                raise Exception(
                    f"Erro de sintaxe: esperado {SIMPLE} | {ONETOMANY} - encontrado {self.current_token.type}")

        return result


def Parse(items_info):

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

print(Parse({
'0': {'id': 0, 'type': 'Message', 'connectsTo': ['1']}, 
'1': {'id': 1, 'type': 'ContentBasedRouter', 'connectsTo': ['5', '6', '4']}, 
'2': {'id': 2, 'type': 'MessageEndpoint', 'connectsTo': []}, 
'3': {'id': 3, 'type': 'MessageEndpoint', 'connectsTo': []}, 
'4': {'id': 4, 'type': 'MessageEndpoint', 'connectsTo': []}, 
'5': {'id': 5, 'type': 'ContentBasedRouter', 'connectsTo': ['2']}, 
'6': {'id': 6, 'type': 'MessageFilter', 'connectsTo': ['3']}
}))