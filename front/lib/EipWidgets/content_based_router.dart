import 'package:flutter/material.dart';

class ContentBasedRouter {
  final String type = "ContentBasedRouter";
  final String subType = "MessageRouting";
  final double width;
  final double height;

  Widget componentWidget;
  Map<String, dynamic> componentConfigs = {
    "choices": null,
  };

  Map<String, dynamic> componentConfigControllers = {
    "contentBasedRouterControllers": {},
  };

  Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {
    Map<String, dynamic> newComponentConfigs = {};
    newComponentConfigs.addAll({config: []});

    for (var choiceTargetID
        in configControllers["contentBasedRouterControllers"][config].keys) {
      newComponentConfigs[config].add([
        choiceTargetID,
        configControllers["contentBasedRouterControllers"][config]
                [choiceTargetID]
            .text
      ]);
    }
    return newComponentConfigs;
  }

  List<Widget> buildEditPane(selectedItem, selectedItemID, itemsPositions,
      config, configControllers, editItems, baseWidget) {
    if (selectedItem.componentConfigs[config] == null) {
      configControllers["contentBasedRouterControllers"].addAll({config: {}});
      for (int i in itemsPositions[selectedItemID]["connectsTo"]) {
        configControllers["contentBasedRouterControllers"][config]
            .addAll({i: TextEditingController()});
        configControllers["contentBasedRouterControllers"][config][i].text =
            selectedItem.componentConfigs[config];

        editItems.add(
          TextFormField(
            decoration: InputDecoration(labelText: config + " [$i]"),
            controller: configControllers["contentBasedRouterControllers"]
                [config][i],
          ),
        );
      }
    } else {
      configControllers["contentBasedRouterControllers"].addAll({config: {}});
      for (var i in selectedItem.componentConfigs[config]) {
        configControllers["contentBasedRouterControllers"][config]
            .addAll({i[0]: TextEditingController()});
        configControllers["contentBasedRouterControllers"][config][i[0]].text =
            i[1];

        editItems.add(
          TextFormField(
            decoration: InputDecoration(labelText: config + " [${i[0]}]"),
            controller: configControllers["contentBasedRouterControllers"]
                [config][i[0]],
          ),
        );
      }

      for (int i in itemsPositions[selectedItemID]["connectsTo"]) {
        if (!configControllers["contentBasedRouterControllers"][config]
            .keys
            .toList()
            .contains(i)) {
          configControllers["contentBasedRouterControllers"][config]
              .addAll({i: TextEditingController()});
          configControllers["contentBasedRouterControllers"][config][i].text =
              "";

          editItems.add(
            TextFormField(
              decoration: InputDecoration(labelText: config + " [$i]"),
              controller: configControllers["contentBasedRouterControllers"]
                  [config][i],
            ),
          );
        }
      }
    }
    return editItems;
  }

  ContentBasedRouter(this.width, this.height) {
    componentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/ContentBasedRouter.png'),
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
