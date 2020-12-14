from .kalei_component import KaleiComponent
from copy import deepcopy


class DefStatement(KaleiComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

        name = current_node['name']
        arguments = current_node['arguments']

        new_generated_code = f"def {name}({arguments})\n "

        rec_code = ""
        deps = ""

        for child_node_number in current_node['connectsTo']:
            rec_code, _ = generate_code(
                items_info, child_node_number, generated_code, new_visited_nodes, new_dependencies)

        return (new_generated_code + rec_code, deps)
