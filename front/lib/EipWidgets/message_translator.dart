import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageTranslator {
  final String type = "MessageTranslator";
  final String subType = "MessagingSystem";

  final String documentacao =
      "https://people.apache.org/~dkulp/camel/message-translator.html";

  final double width;
  final double height;

  Widget? componentWidget;
  Map<String, dynamic> componentConfigs = {
    "process": [
      "public void process(Exchange exchange) {\nMessage in = exchange.getIn();\n",
      "//in.setBody(" ");\n",
      "\n}"
    ],
  };

  Map<String, dynamic> parseComponentConfigsFromJson(dynamic jsonConfig) {
    Map<String, dynamic> _compConfigs =
        Map<String, dynamic>.from(componentConfigs);
    _compConfigs["process"] = jsonConfig["process"];

    return _compConfigs;
  }

  Map<String, dynamic> componentConfigControllers = {
    "messageTranslatorControllers": {},
  };

  Map<String, dynamic> updateConfigs(selectedItem, config, configControllers) {
    return {
      config: [selectedItem.componentConfigs[config][0], configControllers["messageTranslatorControllers"][config].text, selectedItem.componentConfigs[config][2]],
    };
  }

  List<Widget> buildEditPane(selectedItem, selectedItemID, itemsPositions,
      config, configControllers, editItems, baseWidget) {
    configControllers["messageTranslatorControllers"]
        .addAll({config: TextEditingController()});

    configControllers["messageTranslatorControllers"][config].text =
        selectedItem.componentConfigs[config][1];

    editItems.add(
      Text(
        selectedItem.componentConfigs[config][0],
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
    editItems.add(
      TextFormField(
        autofocus: true,
        maxLines: null,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        controller: configControllers["messageTranslatorControllers"][config],
      ),
    );
    editItems.add(
      Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedItem.componentConfigs[config][2],
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
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

  Widget icon(Function insertNewItem) {
    return SizedBox(
      width: 100,
      child: Draggable(
        feedback: componentWidget!,
        onDraggableCanceled: (velocity, offset) {
          insertNewItem(this, offset);
        },
        child: Tooltip(message: this.type, child: componentWidget),
      ),
    );
  }
}
