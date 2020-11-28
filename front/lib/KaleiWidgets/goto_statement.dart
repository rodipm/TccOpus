import 'package:flutter/material.dart';

class GotoStatement {
  final String type = "GotoStatement";
  final String subType = "Conditional";

  final double width;
  final double height;

  Widget componentWidget;
  Map<String, dynamic> componentConfigs = {};

  Map<String, dynamic> parseComponentConfigsFromJson(dynamic jsonConfig) {
    Map<String, dynamic> _compConfigs =
        Map<String, dynamic>.from(componentConfigs);
    return _compConfigs;
  }

  Map<String, dynamic> componentConfigControllers = {
    "GotoStatementControllers": {}
  };

  Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {
    print("UPDATE CONFIGS");
    print(selectedItem);
    print(config);
    print(configControllers);
    return {
      "condition": configControllers["GotoStatementControllers"]["condition"].text,
      "then": configControllers["GotoStatementControllers"]["then"].text,
      "else": configControllers["GotoStatementControllers"]["else"].text
    };
  }

  List<Widget> buildEditPane(selectedItem, selectedItemID, itemsPositions,
      config, configControllers, editItems, baseWidget) {
    configControllers["GotoStatementControllers"]
        .addAll({config: TextEditingController()});

    configControllers["GotoStatementControllers"][config].text =
        selectedItem.componentConfigs[config];

    editItems.add(
      TextFormField(
        autofocus: true,
        // keyboardType: TextInputType.multiline,
        controller: configControllers["GotoStatementControllers"][config],
      ),
    );
    return editItems;
  }

  GotoStatement(this.width, this.height) {
    componentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/GotoStatement.png'),
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
