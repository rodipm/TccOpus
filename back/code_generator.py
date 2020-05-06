from copy import deepcopy
import json

# items_info_debug = {
#     '0': {'id': 0, 'type': 'PollingConsumer', 'uri': "Start1", 'connectsTo': ['1']}, 
#     '1': {'id': 1, 'type': 'ContentBasedRouter', 'uri': "Router1", 'connectsTo': [2,4]},
#     '2': {'id': 2, 'type': 'MessageFilter', 'uri': "Filter", 'connectsTo': [3]},
#     '3': {'id': 3, 'type': 'MessageEndpoint', 'uri': "End11", 'connectsTo': []},
#     '4': {'id': 4, 'type': 'MessageEndpoint', 'uri': "End12", 'connectsTo': []},
#     # '4': {'id': 4, 'type': 'MessageEndpoint', 'uri': "End13", 'connectsTo': []}
# }

# code = []

def create_routes(items_info):
    # global code
    # global items_info_debug

    rotas = []

    for itemKey in items_info:
        item = items_info[itemKey]

        if item['type'] == 'PollingConsumer' or item['type'] == "Message":
            rotas.append(generate_code(items_info, itemKey, "", []))

    return rotas

def generate_code(items_info, current_node_number="0", generated_code="", visited_nodes=[]):
    # global code
    print(current_node_number)
    if current_node_number not in visited_nodes:
        current_node = items_info[str(current_node_number)]
        print(current_node['uri'])
        
        new_visited_nodes = deepcopy(visited_nodes)
        new_visited_nodes.append(current_node_number)
        print("visited nodes", visited_nodes)
        print("generated_code", generated_code)

        if current_node['type'] == 'PollingConsumer' or current_node['type'] == "Message":
            new_generated_code = f"from(\"{current_node['uri']}\")"

            for child_node_number in current_node['connectsTo']:
                return new_generated_code + generate_code(items_info, child_node_number, generated_code, new_visited_nodes)

        if current_node['type'] == "ContentBasedRouter":

            choices = []            
            for child_node_number in current_node['connectsTo']:
                choices.append(".when()" + generate_code(items_info, child_node_number, generated_code, new_visited_nodes))
            
            return generated_code + "".join(choices) + ".end()"

        if current_node['type'] == 'MessageFilter':
            new_generated_code = ".filter()"

            for child_node_number in current_node['connectsTo']:
                return generated_code + new_generated_code + generate_code(items_info, child_node_number, generated_code, new_visited_nodes)

        if current_node['type'] == "MessageEndpoint":
            new_generated_code = f".to(\"{current_node['uri']}\")"

            return generated_code + new_generated_code

        return generated_code

    print("Ret", current_node['uri'])
