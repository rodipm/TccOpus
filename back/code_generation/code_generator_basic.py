from copy import deepcopy
from .basic_components.components_imports import *
import json

# Gera o codigo basic a partir do diagrama
def create_basic(items_info):
    codigo = []
    dependencies = set()

    for itemKey in items_info:
        item = items_info[itemKey]

        # Cada diagrama pode conter mais de uma rota especificada
        # Cada rota tem inicio com um elemento do tipo Message
        print("ITEM TYPE", item['type'])
        if item['type'] in ["DefStatement", "CallStatement"]:
            route, deps = generate_code(items_info, itemKey, "", [], set())
            codigo.append(route)
            dependencies.update(deps)

    return codigo, list(dependencies)

# Percorre a estrutura de dados do diagrama de forma recursiva gerando código respectivo de cada nó
def generate_code(items_info, current_node_number="0", generated_code="", visited_nodes=[], dependencies=set()):
    if current_node_number not in visited_nodes:
        # Tratamento de diferentes tipos de elementos EIP
        # Cada elemento tem sua própria forma de tratamento e gera códigos específicos
        # Baseia-se na descrição dos componentConfigs da classe representante do elemento no front-end

        current_node = items_info[str(current_node_number)]

        # Obtém o tipo do elemento e sua respectiva classe
        basic_component_type = current_node['type']
        basic_component_class = globals()[basic_component_type]
        basic_component = basic_component_class()

        # Efetua a chamada do parse para o componente especificado
        return basic_component.parse(generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies)

