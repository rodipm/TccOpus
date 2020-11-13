import 'package:flutter/material.dart';

class IfStatement {
  final String type = "IfStatement";
  final String subType = "Conditional";

  final double width;
  final double height;

  Widget componentWidget;
  Map<String, dynamic> componentConfigs = {"condition": "", "then": "", "else": ""};

  Map<String, dynamic> parseComponentConfigsFromJson(dynamic jsonConfig) {
    Map<String, dynamic> _compConfigs =
        Map<String, dynamic>.from(componentConfigs);
    _compConfigs["condition"] = jsonConfig["condition"];
    _compConfigs["then"] = jsonConfig["then"];
    _compConfigs["else"] = jsonConfig["else"];
    return _compConfigs;
  }

  Map<String, dynamic> componentConfigControllers = {
    "ifStatementControllers": {}
  };

  Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {
    print("UPDATE CONFIGS");
    print(selectedItem);
    print(config);
    print(configControllers);
    return {
      "condition": configControllers["ifStatementControllers"]["condition"].text,
      "then": configControllers["ifStatementControllers"]["then"].text,
      "else": configControllers["ifStatementControllers"]["else"].text
    };
  }

  List<Widget> buildEditPane(selectedItem, selectedItemID, itemsPositions,
      config, configControllers, editItems, baseWidget) {
    configControllers["ifStatementControllers"]
        .addAll({config: TextEditingController()});

    configControllers["ifStatementControllers"][config].text =
        selectedItem.componentConfigs[config];

    editItems.add(
      TextFormField(
        autofocus: true,
        // keyboardType: TextInputType.multiline,
        controller: configControllers["ifStatementControllers"][config],
      ),
    );
    return editItems;
  }

  IfStatement(this.width, this.height) {
    componentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/IfStatement.png'),
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
