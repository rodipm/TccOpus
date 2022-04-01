import 'package:flutter/material.dart';

class PrintStatement {
  final String type = "PrintStatement";
  final String subType = "IO";

  final double width;
  final double height;

  late Widget componentWidget;
  Map<String, dynamic> componentConfigs = {"print_items": ""};

  Map<String, dynamic> parseComponentConfigsFromJson(dynamic jsonConfig) {
    Map<String, dynamic> _compConfigs =
        Map<String, dynamic>.from(componentConfigs);
    _compConfigs["print_items"] = jsonConfig["print_items"];
    return _compConfigs;
  }

  Map<String, dynamic> componentConfigControllers = {
    "printStatementControllers": {}
  };

  Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {
    //print("UPDATE CONFIGS");
    //print(selectedItem);
    //print(config);
    //print(configControllers);
    return {
      "print_items": configControllers["printStatementControllers"]["print_items"].text,
    };
  }

  List<Widget> buildEditPane(selectedItem, selectedItemID, itemsPositions,
      config, configControllers, editItems, baseWidget) {
    configControllers["printStatementControllers"]
        .addAll({config: TextEditingController()});

    configControllers["printStatementControllers"][config].text =
        selectedItem.componentConfigs[config];

    editItems.add(
      TextFormField(
        autofocus: true,
        // keyboardType: TextInputType.multiline,
        controller: configControllers["printStatementControllers"][config],
      ),
    );
    return editItems;
  }

  PrintStatement(this.width, this.height) {
    componentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/PrintStatement.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget icon(Function insertNewItem) {
    return SizedBox(
      width: 100,
      child: Draggable(
          feedback: componentWidget,
          onDraggableCanceled: (velocity, offset) {
            insertNewItem(this, offset);
          },
          child: componentWidget),
    );
  }
}
