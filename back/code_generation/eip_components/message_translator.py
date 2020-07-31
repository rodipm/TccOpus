from .eip_component import EipComponent
from copy import deepcopy

class MessageTranslator(EipComponent):
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        new_visited_nodes = deepcopy(visited_nodes)
        new_dependencies = deepcopy(dependencies)

        new_generated_code = ".process(new Processor() { \n" + \
            current_node['process'] + "\n})"

        for child_node_number in current_node['connectsTo']:
            rec_code, deps = generate_code(
                items_info, child_node_number, generated_code, new_visited_nodes, dependencies)
            return (new_generated_code + rec_code, deps)
