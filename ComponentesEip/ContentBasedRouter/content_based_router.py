from .eip_component import EipComponent
from copy import deepcopy

class ContentBasedRouter(EipComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

        choices = []
        for [child_node_number, choice] in current_node['choices']:
            if choice:
                rec_code, deps = generate_code(
                    items_info, child_node_number, generated_code, new_visited_nodes, dependencies)
                new_dependencies.update(deps)
                choices.append(f"\n\t.when({choice})\n\t\t" + rec_code)
            else:
                rec_code, deps = generate_code(
                    items_info, child_node_number, generated_code, new_visited_nodes, dependencies)
                new_dependencies.update(deps)
                choices.append(f"\n\t.otherwise()\n\t\t" + rec_code)

        return (generated_code + "\n.choice()" + "".join(choices) + "\n.end()", new_dependencies)
