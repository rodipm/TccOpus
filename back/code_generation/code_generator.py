from copy import deepcopy
import json

# Gera as rotas e dependências de projeto Apache Camel segundo
# os dados contidos no diagrama gerado
def create_routes(items_info):
    rotas = []
    dependencies = set()

    for itemKey in items_info:
        item = items_info[itemKey]

        # Cada diagrama pode conter mais de uma rota especificada
        # Cada rota tem inicio com um elemento do tipo Message
        if item['type'] == 'PollingConsumer' or item['type'] == "Message":
            route, deps = generate_code(items_info, itemKey, "", [], set())
            rotas.append(route)
            dependencies.update(deps)

    return rotas, list(dependencies)

# Percorre a estrutura de dados do diagrama de forma recursiva gerando código respectivo de cada nó
def generate_code(items_info, current_node_number="0", generated_code="", visited_nodes=[], dependencies=set()):
    print(current_node_number)
    if current_node_number not in visited_nodes:
        current_node = items_info[str(current_node_number)]
        
        new_visited_nodes = deepcopy(visited_nodes)
        new_visited_nodes.append(current_node_number)

        new_dependencies = deepcopy(dependencies)

        print("visited nodes", visited_nodes)
        print("generated_code", generated_code)

        # Tratamento de diferentes tipos de elementos EIP
        # Cada elemento tem sua própria forma de tratamento e gera códigos específicos
        # Baseia-se na descrição dos childDetails da classe representante do elemento no front-end

        if current_node['type'] == 'PollingConsumer' or current_node['type'] == "Message":
            uri = ""
            protocol_name = current_node['protocol'][1]
            protocol_opts = current_node['protocol'][2]

            if protocol_name == "file":
                uri = f"file:{protocol_opts[0]}"
                new_dependencies.add(protocol_name)
            elif protocol_name == "http":
                new_dependencies.add(protocol_name)
                uri = f"http://{protocol_opts[0]}?{protocol_opts[1]}"
            elif protocol_name == "ftp":
                uri = f"ftp://{protocol_opts[0]}:{protocol_opts[1]}/{protocol_opts[2]}"
                new_dependencies.add(protocol_name)

            new_generated_code = f"from(\"{uri}\")"

            for child_node_number in current_node['connectsTo']:
                rec_code, deps = generate_code(
                    items_info, child_node_number, generated_code, new_visited_nodes, new_dependencies)
                return (new_generated_code + rec_code, deps)
        
        if current_node['type'] == 'MessageTranslator':
            new_generated_code = ".process(new Processor() { \n" + current_node['process'] + "\n})"

            for child_node_number in current_node['connectsTo']:
                rec_code, deps = generate_code( items_info, child_node_number, generated_code, new_visited_nodes, dependencies)
                return (new_generated_code + rec_code, deps)

        if current_node['type'] == "ContentBasedRouter":
            
            new_dependencies = deepcopy(dependencies)

            choices = []            
            for [child_node_number, choice] in current_node['choices']:
                if choice:
                    rec_code, deps = generate_code(items_info, child_node_number, generated_code, new_visited_nodes, dependencies)
                    new_dependencies.update(deps)
                    choices.append(f"\n\t.when({choice})\n\t\t" + rec_code)
                else:
                    rec_code, deps = generate_code(items_info, child_node_number, generated_code, new_visited_nodes, dependencies)
                    new_dependencies.update(deps)
                    choices.append(f"\n\t.otherwise()\n\t\t" + rec_code)
            
            return (generated_code + "\n.choice()" + "".join(choices) + "\n.end()", new_dependencies)

        if current_node['type'] == 'MessageFilter':

            [child_node_number, choice] = current_node['choices'][0]

            new_generated_code = f".filter({choice})"

            rec_code, deps = generate_code(items_info, child_node_number, generated_code, new_visited_nodes, dependencies)
            return (generated_code + new_generated_code + rec_code, deps)

        if current_node['type'] == "MessageEndpoint":
            uri = ""
            protocol_name = current_node['protocol'][1]
            protocol_opts = current_node['protocol'][2]

            new_dependencies = deepcopy(dependencies)

            if protocol_name == "file":
                uri = f"file:{protocol_opts[0]}"
                new_dependencies.add(protocol_name)
            elif protocol_name == "http":
                uri = f"http://{protocol_opts[0]}?{protocol_opts[1]}"
                new_dependencies.add(protocol_name)
            elif protocol_name == "ftp":
                uri = f"ftp://{protocol_opts[0]}:{protocol_opts[1]}/{protocol_opts[2]}"
                new_dependencies.add(protocol_name)

            new_generated_code = f".toD(\"{uri}\")"

            return (generated_code + new_generated_code, new_dependencies)

        return (generated_code, dependencies)

