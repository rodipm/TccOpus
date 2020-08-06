import 'package:flutter/material.dart';

class MessageFilter {
  final String type = "MessageFilter";
  final String subType = "MessageRouting";

  final double width;
  final double height;

  Widget componentWidget;
  Map<String, dynamic> componentConfigs = {
    "choices": null,
  };

  Map<String, dynamic> componentConfigControllers = {
    "messageFilterControllers": {},
  };

  Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {
    Map<String, dynamic> newComponentConfigs = {};
    newComponentConfigs.addAll({config: []});

    for (var choiceTargetID
        in configControllers["messageFilterControllers"][config].keys) {
      newComponentConfigs[config].add([
        choiceTargetID,
        configControllers["messageFilterControllers"][config][choiceTargetID]
            .text
      ]);
    }
    return newComponentConfigs;
  }

  List<Widget> buildEditPane(selectedItem, selectedItemID, itemsPositions,
      config, configControllers, editItems, baseWidget) {
    if (itemsPositions[selectedItemID]["connectsTo"].length == 1) {
      configControllers["messageFilterControllers"].addAll({config: {}});

      int connectsToID;
      String textValue = "";
      if (selectedItem.componentConfigs[config] == null) {
        connectsToID = itemsPositions[selectedItemID]["connectsTo"].toList()[0];
        textValue = "";
      } else {
        connectsToID = selectedItem.componentConfigs[config][0][0];
        textValue = selectedItem.componentConfigs[config][0][1];
      }

      configControllers["messageFilterControllers"][config]
          .addAll({connectsToID: TextEditingController()});

      configControllers["messageFilterControllers"][config][connectsToID].text =
          textValue;

      editItems.add(
        TextFormField(
          decoration: InputDecoration(labelText: config + " [$connectsToID]"),
          controller: configControllers["messageFilterControllers"][config]
              [connectsToID],
        ),
      );
    }
    return editItems;
  }

  MessageFilter(this.width, this.height) {
    componentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/MessageFilter.png'),
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
