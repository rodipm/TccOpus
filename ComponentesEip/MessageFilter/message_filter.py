from .eip_component import EipComponent
from copy import deepcopy


class MessageFilter(EipComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

        [child_node_number, choice] = current_node['choices'][0]

        new_generated_code = f".filter({choice})"

        rec_code, deps = generate_code(
            items_info, child_node_number, generated_code, new_visited_nodes, dependencies)
        return (generated_code + new_generated_code + rec_code, deps)
