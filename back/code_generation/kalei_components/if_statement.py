from .kalei_component import KaleiComponent
from copy import deepcopy


class IfStatement(KaleiComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

        condition = current_node['condition']

        then_line = current_node['connectsTo'][0]
        else_line = current_node['connectsTo'][1]

        print(condition, "condition")
        print(then_line, "then_line")
        print(else_line, "else_line")


        then_code = ""
        else_code = ""

        for node_num in current_node['connectsTo']:
            new_code, _ = generate_code(
                items_info, node_num, generated_code, new_visited_nodes, new_dependencies)
            if "then" in new_code:
                then_code = new_code
            else:
                else_code = new_code
        


        new_generated_code = f"if ({condition})\n{then_code}\n{else_code}\n"

        deps = ""

        return (new_generated_code, deps)
