from .basic_component import BasicComponent
from copy import deepcopy


class ForStatement(BasicComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

        init_exp = current_node['init_exp']
        condition_exp = current_node['condition_exp']

        inside_for = current_node['connectsTo'][0]
        after_for = current_node['connectsTo'][1]

        inside_for_code, _ = generate_code(
            items_info, inside_for, generated_code, new_visited_nodes, new_dependencies)

        new_generated_code = f"(for {init_exp}, {condition_exp} in \n{inside_for_code})"

        rec_code = ""

        rec_code, _ = generate_code(
            items_info, after_for, generated_code, new_visited_nodes, new_dependencies)

        if rec_code != "":
            print("rec_code", rec_code)
            rec_code = ":\n" + rec_code

        return (new_generated_code + rec_code, "")
