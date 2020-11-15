from .basic_component import BasicComponent
from copy import deepcopy


class ForStatement(BasicComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

        var_name = current_node['var_name']
        initial = current_node['initial']
        final = current_node['final']
        increment = current_node['increment']

        after_for = current_node['connectsTo'][0]
        inside_for = current_node['connectsTo'][1]

        inside_for_code = ""

        inside_for_code, _ = generate_code(
            items_info, inside_for, generated_code, new_visited_nodes, new_dependencies)

        new_generated_code = f"{current_node_number} FOR {var_name} = {initial} TO {final} INCREMENT {increment} \n{inside_for_code}0{current_node_number}NEXT {var_name}\n"

        rec_code = ""

        branches = []

        rec_code, _ = generate_code(
            items_info, after_for, generated_code, new_visited_nodes, new_dependencies)

        return (new_generated_code + rec_code, "")
