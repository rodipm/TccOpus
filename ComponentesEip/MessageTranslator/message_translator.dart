import 'package:flutter/material.dart';

class MessageTranslator {
  final String type = "MessageTranslator";
  final String subType = "MessagingSystem";

  final double width;
  final double height;

  Widget componentWidget;
  Map<String, dynamic> componentConfigs = {
    "process":
        "public void process(Exchange exchange) {\n\tMessage in = exchange.getIn();\n\tin.setBody();\n}"
  };

  Map<String, dynamic> parseComponentConfigsFromJson(dynamic jsonConfig) {
    Map<String, dynamic> _compConfigs = Map<String, dynamic>.from(componentConfigs);
    _compConfigs["process"] = jsonConfig["process"];

    return _compConfigs;
  }

  Map<String, dynamic> componentConfigControllers = {
    "messageTranslatorControllers": {},
  };

  Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {
    return {
      config: configControllers["messageTranslatorControllers"][config].text
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
        maxLines: 10,
        // keyboardType: TextInputType.multiline,
        controller: configControllers["messageTranslatorControllers"][config],
      ),
    );
    return editItems;
  }

  MessageTranslator(this.width, this.height) {
    componentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/MessageTranslator.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget icon(Function insertNewEipItem) {
    return SizedBox(
      width: 100,
      child: Draggable(
          feedback: componentWidget,
          onDraggableCanceled: (velocity, offset) {
            insertNewEipItem(this, offset);
          },
          child: componentWidget),
    );
  }
}
