from abc import abstractmethod

class EipComponent:
    @abstractmethod
    def parse(self, generate_code, items_info, current_node_number, current_node, generated_code, visited_nodes, dependencies):
        pass
