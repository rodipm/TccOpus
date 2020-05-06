from flask import Flask
from flask import request
from flask_cors import CORS
from copy import deepcopy
import json
from code_generator import create_routes

app = Flask(__name__)
CORS(app)


@app.route('/')
def index():
    return "EIPEditor back-end."


# items_info_debug = {
#     '0': {'id': 0, 'type': 'PollingConsumer', 'uri': None, 'connectsTo': ['1', '2']}, 
#     '1': {'id': 1, 'type': 'MessageEndpoint', 'uri': None, 'connectsTo': []},
#     '2': {'id': 2, 'type': 'MessageEndpoint', 'uri': None, 'connectsTo': []},
#     '3': {'id': 3, 'type': 'PollingConsumer', 'uri': None, 'connectsTo': ['2']}
# }

@app.route('/send_diagram', methods=['POST'])
def send_diagram():
    test = []
    items_info = {}

    items = request.json['items']
    positions = request.json['positions']

    for itemKey in items:
        items_info[itemKey] = items[itemKey]
        items_info[itemKey]["connectsTo"] = positions[itemKey]['connectsTo']

    print(create_routes(items_info))

    # string_code = []
    # # Search for route startes
    # for itemKey in items_info:
    #     item = items_info[itemKey]

    #     if item['type'] == 'PollingConsumer':
    #         # string_code.append("".join(generate_code(items_info, itemKey, [], [])))
    #         print(generate_code(items_info, itemKey, [], []))

    # print(test)
    # # print(string_code)

    return 'OK', 200


# test = []


# def generate_code(items_info, current_node_number="0", generated_code=[], visited_nodes=[]):
#     global test
#     if current_node_number not in visited_nodes:
#         current_node = items_info[current_node_number]
#         print(current_node['uri'])
#         new_visited_nodes = deepcopy(visited_nodes)
#         new_visited_nodes.append(current_node_number)
#         print("visited nodes", visited_nodes)
#         print("generated_code", generated_code)

#         new_generated_code = ""

#         if current_node['type'] == 'PollingConsumer':
#             new_generated_code = f"from(\"{current_node['uri']}\")"

#         if current_node['type'] == "MessageEndpoint":
#             new_generated_code = f".to(\"{current_node['uri']}\")"

#         generated_code_arr = deepcopy(generated_code)
#         generated_code_arr.append(new_generated_code)

#         for child_node_number in current_node['connectsTo']:
#             generated_code = generate_code(items_info, child_node_number,
#                                            generated_code_arr, new_visited_nodes)
#         generated_code.append(new_generated_code)
#         if len(current_node['connectsTo']) == 0:
#             print("End", generated_code_arr, current_node['uri'])
#             test.append(generated_code_arr)
#         return generated_code
#     print("Ret", current_node['uri'])


if __name__ == '__main__':
    app.run(debug=True, port=5000)
    # # Search for route startes
    # generated_code = []
    # for itemKey in items_info_debug:
    #     print("ITEM KEY: ", itemKey)
    #     item = items_info_debug[itemKey]

    #     if item['type'] == 'PollingConsumer':
    #         generate_code(
    #             items_info_debug, itemKey, generated_code, [])
    # print("Resultado: ", generated_code)
