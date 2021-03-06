from .kalei_component import KaleiComponent
from copy import deepcopy


class AssignStatement(KaleiComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

        var_name = current_node['var_name']
        expression = current_node['expression']

        print(var_name, "var_name")
        print(expression, "expression")

        new_generated_code = f"var {var_name} = {expression} in\n"

        rec_code = ""
        deps = ""

        for child_node_number in current_node['connectsTo']:
            rec_code, deps = generate_code(
                items_info, child_node_number, generated_code, new_visited_nodes, new_dependencies)

        return (new_generated_code + rec_code, deps)
