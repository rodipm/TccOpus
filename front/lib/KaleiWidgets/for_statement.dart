import 'package:flutter/material.dart';

class ForStatement {
  final String type = "ForStatement";
  final String subType = "Conditional";

  final double width;
  final double height;

  late Widget componentWidget;
  Map<String, dynamic> componentConfigs = {"init_exp": "", "condition_exp": ""};

  Map<String, dynamic> parseComponentConfigsFromJson(dynamic jsonConfig) {
    Map<String, dynamic> _compConfigs =
        Map<String, dynamic>.from(componentConfigs);
    _compConfigs["init_exp"] = jsonConfig["init_exp"];
    _compConfigs["condition_exp"] = jsonConfig["condition_exp"];
    return _compConfigs;
  }

  Map<String, dynamic> componentConfigControllers = {
    "ForStatementControllers": {}
  };

  Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {
    return {
      "init_exp": configControllers["ForStatementControllers"]["init_exp"].text,
      "condition_exp": configControllers["ForStatementControllers"]["condition_exp"].text,
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
