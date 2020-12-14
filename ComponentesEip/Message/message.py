from .eip_component import EipComponent
from copy import deepcopy


class Message(EipComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

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
