import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:async';

class ContentBasedRouter {
  final String type = "ContentBasedRouter";
  final String subType = "MessageRouting";

  final List<String> autocompletions = [
    'header("")',
    'body("")',
    'bodyAs(String.class)',
    'contains("")',
    'isEqualTo("")',
    'isGreaterThan("")',
    'isLessThan("")',
    'startsWith("")',
    'endsWith("")',
    'in()',
    'not()',
    'and(,)',
    'or(,)'
  ];
  final String documentacao =
      "https://people.apache.org/~dkulp/camel/content-based-router.html";

  final double width;
  final double height;

  String patt;

  final TextEditingController _typeAheadController = TextEditingController();

  Widget componentWidget;
  Map<String, dynamic> componentConfigs = {
    "choices": null,
  };

  Map<String, dynamic> parseComponentConfigsFromJson(dynamic jsonConfig) {
    Map<String, dynamic> _compConfigs =
        Map<String, dynamic>.from(componentConfigs);
    _compConfigs["choices"] = jsonConfig["choices"];

    return _compConfigs;
  }

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
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                autofocus: false,
                decoration: InputDecoration(labelText: config + " [$i]"),
                controller: configControllers["contentBasedRouterControllers"]
                    [config][i]),
            suggestionsCallback: (pattern) {
              if (pattern.contains(".") == true) {
                pattern = pattern.substring(pattern.lastIndexOf(".") + 1);
                //print("new pattern:");
                //print(pattern);
              }
              this.patt = pattern;
              return this
                  .autocompletions
                  .where((element) => element.contains(pattern));
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion));
            },
            onSuggestionSelected: (suggestion) {
              configControllers["contentBasedRouterControllers"][config][i]
                  .text = configControllers["contentBasedRouterControllers"]
                      [config][i]
                  .text
                  .substring(
                      0,
                      configControllers["contentBasedRouterControllers"][config]
                              [i]
                          .text
                          .lastIndexOf(this.patt));

              return configControllers["contentBasedRouterControllers"][config]
                      [i]
                  .text += suggestion;
            },
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
          TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                autofocus: false,
                decoration: InputDecoration(labelText: config + " [$i]"),
                controller: configControllers["contentBasedRouterControllers"]
                    [config][i[0]]),
            suggestionsCallback: (pattern) {
              if (pattern.contains(".") == true) {
                pattern = pattern.substring(pattern.lastIndexOf(".") + 1);
                //print("new pattern:");
                //print(pattern);
              }
              this.patt = pattern;
              return this
                  .autocompletions
                  .where((element) => element.contains(pattern));
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion));
            },
            onSuggestionSelected: (suggestion) {
              configControllers["contentBasedRouterControllers"][config][i[0]]
                  .text = configControllers["contentBasedRouterControllers"]
                      [config][i[0]]
                  .text
                  .substring(
                      0,
                      configControllers["contentBasedRouterControllers"][config]
                              [i[0]]
                          .text
                          .lastIndexOf(this.patt));

              return configControllers["contentBasedRouterControllers"][config]
                      [i[0]]
                  .text += suggestion;
            },
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
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                  autofocus: false,
                  decoration: InputDecoration(labelText: config + " [$i]"),
                  controller: configControllers["contentBasedRouterControllers"]
                      [config][i]),
              suggestionsCallback: (pattern) {
                if (pattern.contains(".") == true) {
                  pattern = pattern.substring(pattern.lastIndexOf(".") + 1);
                  //print("new pattern:");
                  //print(pattern);
                }
                this.patt = pattern;
                return this
                    .autocompletions
                    .where((element) => element.contains(pattern));
              },
              itemBuilder: (context, suggestion) {
                return ListTile(title: Text(suggestion));
              },
              onSuggestionSelected: (suggestion) {
                configControllers["contentBasedRouterControllers"][config][i]
                    .text = configControllers["contentBasedRouterControllers"]
                        [config][i]
                    .text
                    .substring(
                        0,
                        configControllers["contentBasedRouterControllers"]
                                [config][i]
                            .text
                            .lastIndexOf(this.patt));

                return configControllers["contentBasedRouterControllers"]
                        [config][i]
                    .text += suggestion;
              },
            ),
          );
        }
      }
    }
    editItems.add(
      Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: RaisedButton(
          onPressed: _launchURL,
          child: new Text('Documentação'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Color(0xff01A0C7),
        ),
      ),
    );
    return editItems;
  }

  _launchURL() async {
    var url = this.documentacao;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

  Widget icon(Function insertNewItem) {
    return SizedBox(
      width: 100,
      child: Draggable(
        feedback: componentWidget,
        onDraggableCanceled: (velocity, offset) {
          insertNewItem(this, offset);
        },
        child: Tooltip(message: this.type, child: componentWidget),
      ),
    );
  }
}
