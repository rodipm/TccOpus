from .kalei_component import KaleiComponent
from copy import deepcopy


class ExpressionStatement(KaleiComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

        expression = current_node['expression']

        new_generated_code = f"({expression})"

        rec_code = ""
        deps = ""

        for child_node_number in current_node['connectsTo']:
            rec_code, deps = generate_code(
                items_info, child_node_number, generated_code, new_visited_nodes, new_dependencies)

        if rec_code != "":
            print("aarec_code", rec_code)

            rec_code = ":\n" + rec_code
        return (new_generated_code + rec_code, deps)
