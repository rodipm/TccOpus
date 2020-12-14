import 'package:flutter/material.dart';

class ExpressionStatement {
  final String type = "ExpressionStatement";
  final String subType = "Expression";

  final double width;
  final double height;

  Widget componentWidget;
  Map<String, dynamic> componentConfigs = {"expression": ""};

  Map<String, dynamic> parseComponentConfigsFromJson(dynamic jsonConfig) {
    Map<String, dynamic> _compConfigs =
        Map<String, dynamic>.from(componentConfigs);
    _compConfigs["expression"] = jsonConfig["expression"];
    return _compConfigs;
  }

  Map<String, dynamic> componentConfigControllers = {
    "expressionStatementControllers": {}
  };

  Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {
    //print("UPDATE CONFIGS");
    //print(selectedItem);
    //print(config);
    //print(configControllers);
    return {
      "expression": configControllers["expressionStatementControllers"]["expression"].text,
    };
  }

  List<Widget> buildEditPane(selectedItem, selectedItemID, itemsPositions,
      config, configControllers, editItems, baseWidget) {
    configControllers["expressionStatementControllers"]
        .addAll({config: TextEditingController()});

    configControllers["expressionStatementControllers"][config].text =
        selectedItem.componentConfigs[config];

    editItems.add(
      TextFormField(
        autofocus: true,
        // keyboardType: TextInputType.multiline,
        controller: configControllers["expressionStatementControllers"][config],
      ),
    );
    return editItems;
  }

  ExpressionStatement(this.width, this.height) {
    componentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/ExpressionStatement.png'),
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
