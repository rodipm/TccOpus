import 'package:flutter/material.dart';

class ForStatement {
  final String type = "ForStatement";
  final String subType = "Conditional";

  final double width;
  final double height;

  Widget componentWidget;
  Map<String, dynamic> componentConfigs = {"var_name": "", "initial": "", "final": "", "increment": ""};

  Map<String, dynamic> parseComponentConfigsFromJson(dynamic jsonConfig) {
    Map<String, dynamic> _compConfigs =
        Map<String, dynamic>.from(componentConfigs);
    _compConfigs["var_name"] = jsonConfig["var_name"];
    _compConfigs["initial"] = jsonConfig["initial"];
    _compConfigs["final"] = jsonConfig["final"];
    _compConfigs["increment"] = jsonConfig["increment"];
    return _compConfigs;
  }

  Map<String, dynamic> componentConfigControllers = {
    "ForStatementControllers": {}
  };

  Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {
    return {
      "var_name": configControllers["ForStatementControllers"]["var_name"].text,
      "initial": configControllers["ForStatementControllers"]["initial"].text,
      "final": configControllers["ForStatementControllers"]["final"].text,
      "increment": configControllers["ForStatementControllers"]["increment"].text,
    };
  }

  List<Widget> buildEditPane(selectedItem, selectedItemID, itemsPositions,
      config, configControllers, editItems, baseWidget) {
    configControllers["ForStatementControllers"]
        .addAll({config: TextEditingController()});

    configControllers["ForStatementControllers"][config].text =
        selectedItem.componentConfigs[config];

    editItems.add(
      TextFormField(
        autofocus: true,
        // keyboardType: TextInputType.multiline,
        controller: configControllers["ForStatementControllers"][config],
      ),
    );
    return editItems;
  }

  ForStatement(this.width, this.height) {
    componentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/ForStatement.png'),
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
