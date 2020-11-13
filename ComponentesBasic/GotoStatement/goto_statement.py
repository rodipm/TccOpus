from .basic_component import BasicComponent
from copy import deepcopy


class GotoStatement(BasicComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

        dest_line = current_node['connectsTo'][0]

        new_generated_code = f"{current_node_number} GOTO {dest_line}\n"

        return (new_generated_code, "")
