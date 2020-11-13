import 'package:flutter/material.dart';

class MessageEndpoint {
  final String type = "MessageEndpoint";
  final String subType = "MessagingSystem";
  
  final double width;
  final double height;

  Widget componentWidget;
  Map<String, dynamic> componentConfigs = {
    "protocol": [
      {
        "file": ["dir"],
        "http": ["hostname", "query parameters"],
        "ftp": ["host", "port", "filename"]
      },
      null,
      []
    ]
  };

  Map<String, dynamic> parseComponentConfigsFromJson(dynamic jsonConfig) {
    
    Map<String, dynamic> _compConfigs = Map<String, dynamic>.from(componentConfigs);
    _compConfigs["protocol"][0] = jsonConfig["protocol"][0];
    _compConfigs["protocol"][1] = jsonConfig["protocol"][1];
    _compConfigs["protocol"][2] = jsonConfig["protocol"][2];

    return _compConfigs;
  }
  
 Map<String, dynamic> componentConfigControllers = {
    "messageControllers": {},
    "editItemsValues": {}
  };

  Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {
    var protocolOptions = List();

    if (configControllers["editItemsValues"][config] != null) {
      for (var protocolOption in selectedItem.componentConfigs[config][0]
          [configControllers["editItemsValues"][config]]) {
        protocolOptions
            .add(configControllers["messageControllers"][protocolOption].text);
      }
    }
    return {
      config: [
        selectedItem.componentConfigs[config][0],
        configControllers["editItemsValues"][config],
        protocolOptions
      ]
    };
  }

  List<Widget> buildEditPane(
      selectedItem, selectedItemID, itemsPositions, config, configControllers, editItems, baseWidget) {
    String _chosenValue;

    if (selectedItem.componentConfigs[config][1] != null)
      _chosenValue = selectedItem.componentConfigs[config][1];
    else if (configControllers["editItemsValues"][config] != null)
      _chosenValue = configControllers["editItemsValues"][config];
    else
      _chosenValue = selectedItem.componentConfigs[config][0][0];
    configControllers["editItemsValues"].addAll({config: _chosenValue});
    editItems.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            config,
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            value: configControllers["editItemsValues"][config],
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            onChanged: (String newValue) {
              baseWidget.setState(() {
                configControllers["editItemsValues"][config] = newValue;
              });
            },
            items: selectedItem.componentConfigs[config][0].keys
                .toList()
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )
        ],
      ),
    );

    if (_chosenValue != null) {
      int protocolOptionIndex = 0;
      for (var protocolOption in selectedItem.componentConfigs[config][0]
          [_chosenValue]) {
        configControllers["messageControllers"]
            .addAll({protocolOption: TextEditingController()});

        String controllerTextValue = "";
        if (protocolOptionIndex <
            selectedItem.componentConfigs[config][2].length) {
          controllerTextValue =
              selectedItem.componentConfigs[config][2][protocolOptionIndex];
          protocolOptionIndex++;
        }

        configControllers["messageControllers"][protocolOption].text =
            controllerTextValue;

        editItems.add(
          TextFormField(
            decoration: InputDecoration(labelText: protocolOption),
            controller: configControllers["messageControllers"][protocolOption],
          ),
        );
      }
    }

    return editItems;
  }
  
  MessageEndpoint(this.width, this.height) {
    componentWidget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/MessageEndpoint.png'),
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
