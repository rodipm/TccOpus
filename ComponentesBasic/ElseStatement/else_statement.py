from .basic_component import BasicComponent
from copy import deepcopy


class ElseStatement(BasicComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

        exp_code, _ = generate_code(
            items_info, current_node['connectsTo'][0], generated_code, new_visited_nodes, new_dependencies)

        new_generated_code = f"else\n{exp_code}\n"

        return (new_generated_code, "")