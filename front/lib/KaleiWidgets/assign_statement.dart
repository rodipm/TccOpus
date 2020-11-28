import 'package:flutter/material.dart';

class AssignStatement {
  final String type = "AssignStatement";
  final String subType = "Expression";

  final double width;
  final double height;

  Widget componentWidget;
  Map<String, dynamic> componentConfigs = {"var_name": "", "expression": ""};

  Map<String, dynamic> parseComponentConfigsFromJson(dynamic jsonConfig) {
    Map<String, dynamic> _compConfigs =
        Map<String, dynamic>.from(componentConfigs);
    _compConfigs["var_name"] = jsonConfig["var_name"];
    _compConfigs["expression"] = jsonConfig["expression"];
    return _compConfigs;
  }

  Map<String, dynamic> componentConfigControllers = {
    "messageTranslatorControllers": {}
  };

  Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {
    print("UPDATE CONFIGS");
    print(selectedItem);
    print(config);
    print(configControllers);
    return {
      "var_name": configControllers["messageTranslatorControllers"]["var_name"].text,
      "expression": configControllers["messageTranslatorControllers"]["expression"].text
    };
  }

  List<Widget> buildEditPane(selectedItem, selectedItemID, itemsPositions,
      config, configControllers, editItems, baseWidget) {
    configControllers["messageTranslatorControllers"]
        .addAll({config: TextEditingController()});

    configControllers["messageTranslatorControllers"][config].text =
        selectedItem.componentConfigs[config];

    editItems.add(
      TextFormField(
        autofocus: true,
        // keyboardType: TextInputType.multiline,
        controller: configControllers["messageTranslatorControllers"][config],
      ),
    );
    return editItems;
  }

  AssignStatement(this.width, this.height) {
    componentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/AssignStatement.png'),
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
