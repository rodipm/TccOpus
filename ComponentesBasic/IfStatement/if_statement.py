from .basic_component import BasicComponent
from copy import deepcopy


class IfStatement(BasicComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

        condition = current_node['condition']

        then_line = current_node['connectsTo'][0]
        else_line = current_node['connectsTo'][1]

        print(condition, "condition")
        print(then_line, "then_line")
        print(else_line, "else_line")

        new_generated_code = f"{current_node_number} IF {condition} THEN {then_line}\n{current_node_number}1 GOTO {else_line}\n"

        rec_code = ""
        deps = ""

        branches = []

        for child_node_number in current_node['connectsTo']:
            rec_code, _ = generate_code(
                items_info, child_node_number, generated_code, new_visited_nodes, new_dependencies)
            branches.append(rec_code)

        print("branches", branches)
        return (new_generated_code + "".join(branches[::-1]), deps)
