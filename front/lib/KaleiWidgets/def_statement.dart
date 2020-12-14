import 'package:flutter/material.dart';

class DefStatement {
  final String type = "DefStatement";
  final String subType = "Def";

  final double width;
  final double height;

  Widget componentWidget;
  Map<String, dynamic> componentConfigs = {"name": "", "arguments": ""};

  Map<String, dynamic> parseComponentConfigsFromJson(dynamic jsonConfig) {
    Map<String, dynamic> _compConfigs =
        Map<String, dynamic>.from(componentConfigs);
    _compConfigs["name"] = jsonConfig["name"];
    _compConfigs["arguments"] = jsonConfig["arguments"];
    return _compConfigs;
  }

  Map<String, dynamic> componentConfigControllers = {
    "DefStatementControllers": {}
  };

  Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {
    //print("UPDATE CONFIGS");
    //print(selectedItem);
    //print(config);
    //print(configControllers);
    return {
      "name": configControllers["DefStatementControllers"]["name"].text,
      "arguments":
          configControllers["DefStatementControllers"]["arguments"].text,
    };
  }

  List<Widget> buildEditPane(selectedItem, selectedItemID, itemsPositions,
      config, configControllers, editItems, baseWidget) {
    configControllers["DefStatementControllers"]
        .addAll({config: TextEditingController()});

    configControllers["DefStatementControllers"][config].text =
        selectedItem.componentConfigs[config];

    editItems.add(
      TextFormField(
        autofocus: true,
        // keyboardType: TextInputType.multiline,
        controller: configControllers["DefStatementControllers"][config],
      ),
    );
    return editItems;
  }

  DefStatement(this.width, this.height) {
    componentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/DefStatement.png'),
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
