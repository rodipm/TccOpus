from .basic_component import BasicComponent
from copy import deepcopy


class PrintStatement(BasicComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

        print_items = current_node['print_items']

        new_generated_code = f"{current_node_number} PRINT {print_items}\n"

        rec_code = ""
        deps = ""

        for child_node_number in current_node['connectsTo']:
            rec_code, deps = generate_code(
                items_info, child_node_number, generated_code, new_visited_nodes, new_dependencies)

        return (new_generated_code + rec_code, deps)
