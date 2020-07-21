from copy import deepcopy
import json

def create_routes(items_info):
    rotas = []

    for itemKey in items_info:
        item = items_info[itemKey]

        if item['type'] == 'PollingConsumer' or item['type'] == "Message":
            rotas.append(generate_code(items_info, itemKey, "", []))

    return rotas

def generate_code(items_info, current_node_number="0", generated_code="", visited_nodes=[]):
    print(current_node_number)
    if current_node_number not in visited_nodes:
        current_node = items_info[str(current_node_number)]
        
        new_visited_nodes = deepcopy(visited_nodes)
        new_visited_nodes.append(current_node_number)
        print("visited nodes", visited_nodes)
        print("generated_code", generated_code)

        if current_node['type'] == 'PollingConsumer' or current_node['type'] == "Message":
            uri = ""
            protocol_name = current_node['protocol'][1]
            protocol_opts = current_node['protocol'][2]

            if protocol_name == "file":
                uri = f"file:{protocol_opts[0]}"
            elif protocol_name == "http":
                uri = f"http://{protocol_opts[0]}:{protocol_opts[1]}"
            elif protocol_name == "ftp":
                uri = f"ftp://{protocol_opts[0]}:{protocol_opts[1]}/{protocol_opts[2]}"

            new_generated_code = f"from(\"{uri}\")"

            for child_node_number in current_node['connectsTo']:
                return new_generated_code + generate_code(items_info, child_node_number, generated_code, new_visited_nodes)
        
        if current_node['type'] == 'MessageTranslator':
            new_generated_code = f".process(\"{current_node['process']}\")"

            for child_node_number in current_node['connectsTo']:
                return new_generated_code + generate_code(items_info, child_node_number, generated_code, new_visited_nodes)

        if current_node['type'] == "ContentBasedRouter":

            choices = []            
            for [child_node_number, choice] in current_node['choices']:
                if choice:
                    choices.append(f"\n\t.when({choice})\n\t\t" + generate_code(items_info,
                                                                  child_node_number, generated_code, new_visited_nodes))
                else:
                    choices.append(f"\n\t.otherwise()\n\t\t" + generate_code(items_info,
                                                                  child_node_number, generated_code, new_visited_nodes))
            
            return generated_code + "\n.choice()" + "".join(choices) + "\n.end()"

        if current_node['type'] == 'MessageFilter':

            [child_node_number, choice] = current_node['choices'][0]

            new_generated_code = f".filter({choice})"

            return generated_code + new_generated_code + generate_code(items_info, child_node_number, generated_code, new_visited_nodes)

        if current_node['type'] == "MessageEndpoint":
            uri = ""
            protocol_name = current_node['protocol'][1]
            protocol_opts = current_node['protocol'][2]

            if protocol_name == "file":
                uri = f"file:{protocol_opts[0]}"
            elif protocol_name == "http":
                uri = f"http://{protocol_opts[0]}:{protocol_opts[1]}"
            elif protocol_name == "ftp":
                uri = f"ftp://{protocol_opts[0]}:{protocol_opts[1]}/{protocol_opts[2]}"

            new_generated_code = f".to(\"{uri}\")"

            return generated_code + new_generated_code

        return generated_code

