from .eip_component import EipComponent
from copy import deepcopy

class MessageEndpoint(EipComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

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
