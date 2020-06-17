import 'package:EIPEditor/Commom/PredicateEditor.dart';
import 'package:EIPEditor/MoveableStackItem/movable_stack_item.dart';
import 'package:flutter/material.dart';

class EditItemPane extends StatefulWidget {
  final MoveableStackItem selectedItem;
  final int selectedItemID;
  final Function updateItemDetails;
  final Map<int, Map<String, dynamic>> itemsPositions;
  EditItemPane(this.selectedItem, this.selectedItemID, this.updateItemDetails,
      this.itemsPositions);

  @override
  _EditItemPaneState createState() => _EditItemPaneState();
}

class _EditItemPaneState extends State<EditItemPane> {
  List<Widget> editItems = [];

  // Estruturas de dados especificas para diferentes tipos de elementos
  // Message e MessageEndpoint
  Map<String, dynamic> messageControllers = {};
  Map<String, dynamic> editItemsValues = {};

  // ContentBasedRouter
  Map<String, dynamic> contentBasedRouterControllers = {};

  // MessageFilter
  Map<String, dynamic> messageFilterControllers = {};

  // MessageTranslator
  Map<String, dynamic> messageTranslatorControllers = {};

  Map<String, dynamic> generateNewItemDetails() {
    Map<String, dynamic> newItemDetails = {};

    for (String editItem in widget.selectedItem.childDetails.keys) {
      // Message e MessageEndpoint
      if (widget.selectedItem.type == "Message" ||
          widget.selectedItem.type == "MessageEndpoint") {
        var protocolOptions = List();

        if (editItemsValues[editItem] != null) {
          for (var protocolOption in widget.selectedItem.childDetails[editItem]
              [0][editItemsValues[editItem]]) {
            protocolOptions.add(messageControllers[protocolOption].text);
          }
        }
        newItemDetails.addAll({
          editItem: [
            widget.selectedItem.childDetails[editItem][0],
            editItemsValues[editItem],
            protocolOptions
          ]
        });
      }

      // MessageTranslator
      else if (widget.selectedItem.type == "MessageTranslator") {
        newItemDetails
            .addAll({editItem: messageTranslatorControllers[editItem].text});
      }

      // ContentBasedRouter
      else if (widget.selectedItem.type == "ContentBasedRouter") {
        newItemDetails.addAll({editItem: []});
        for (var choiceTargetID
            in contentBasedRouterControllers[editItem].keys) {
          newItemDetails[editItem].add([
            choiceTargetID,
            contentBasedRouterControllers[editItem][choiceTargetID].text
          ]);
        }
      }

      // MessageFilter
      else if (widget.selectedItem.type == "MessageFilter") {
        newItemDetails.addAll({editItem: []});
        for (var choiceTargetID in messageFilterControllers[editItem].keys) {
          newItemDetails[editItem].add([
            choiceTargetID,
            messageFilterControllers[editItem][choiceTargetID].text
          ]);
        }
      }
    }
    return newItemDetails;
  }

  @override
  Widget build(BuildContext context) {
    this.editItems = [];

    for (String editItem in widget.selectedItem.childDetails.keys) {
      // Message e Message Endpoint
      if (widget.selectedItem.type == "Message" ||
          widget.selectedItem.type == "MessageEndpoint") {
        String _chosenValue;

        if (widget.selectedItem.childDetails[editItem][1] != null)
          _chosenValue = widget.selectedItem.childDetails[editItem][1];
        else if (editItemsValues[editItem] != null)
          _chosenValue = editItemsValues[editItem];
        else
          _chosenValue = widget.selectedItem.childDetails[editItem][0][0];
        editItemsValues.addAll({editItem: _chosenValue});
        editItems.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                editItem,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: editItemsValues[editItem],
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                onChanged: (String newValue) {
                  setState(() {
                    editItemsValues[editItem] = newValue;
                  });
                },
                items: widget.selectedItem.childDetails[editItem][0].keys
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
          for (var protocolOption in widget.selectedItem.childDetails[editItem]
              [0][_chosenValue]) {
            messageControllers
                .addAll({protocolOption: TextEditingController()});

            String controllerTextValue = "";
            if (protocolOptionIndex <
                widget.selectedItem.childDetails[editItem][2].length) {
              controllerTextValue = widget.selectedItem.childDetails[editItem]
                  [2][protocolOptionIndex];
              protocolOptionIndex++;
            }

            messageControllers[protocolOption].text = controllerTextValue;

            editItems.add(
              TextFormField(
                decoration: InputDecoration(labelText: protocolOption),
                controller: messageControllers[protocolOption],
              ),
            );
          }
        }
      }

      // MessageTranslator
      else if (widget.selectedItem.type == "MessageTranslator") {
        messageTranslatorControllers
            .addAll({editItem: TextEditingController()});

        messageTranslatorControllers[editItem].text =
            widget.selectedItem.childDetails[editItem];

        editItems.add(
          TextFormField(
            autofocus: true,
            maxLines: 10,
            // keyboardType: TextInputType.multiline,
            controller: messageTranslatorControllers[editItem],
          ),
        );
      }

      // ContentBasedRouter
      else if (widget.selectedItem.type == "ContentBasedRouter") {
        if (widget.selectedItem.childDetails[editItem] == null) {
          contentBasedRouterControllers.addAll({editItem: {}});
          for (int i in widget.itemsPositions[widget.selectedItemID]
              ["connectsTo"]) {
            contentBasedRouterControllers[editItem]
                .addAll({i: TextEditingController()});
            contentBasedRouterControllers[editItem][i].text =
                widget.selectedItem.childDetails[editItem];

            editItems.add(
              TextFormField(
                decoration: InputDecoration(labelText: editItem + " [$i]"),
                controller: contentBasedRouterControllers[editItem][i],
              ),
            );
          }
        } else {
          contentBasedRouterControllers.addAll({editItem: {}});
          for (var i in widget.selectedItem.childDetails[editItem]) {
            contentBasedRouterControllers[editItem]
                .addAll({i[0]: TextEditingController()});
            contentBasedRouterControllers[editItem][i[0]].text = i[1];

            editItems.add(
              TextFormField(
                decoration: InputDecoration(labelText: editItem + " [${i[0]}]"),
                controller: contentBasedRouterControllers[editItem][i[0]],
              ),
            );
            
          }
         

          for (int i in widget.itemsPositions[widget.selectedItemID]
              ["connectsTo"]) {
            if (!contentBasedRouterControllers[editItem]
                .keys
                .toList()
                .contains(i)) {
              contentBasedRouterControllers[editItem]
                  .addAll({i: TextEditingController()});
              contentBasedRouterControllers[editItem][i].text = "";

              editItems.add(
                TextFormField(
                  decoration: InputDecoration(labelText: editItem + " [$i]"),
                  controller: contentBasedRouterControllers[editItem][i],
                ),
              );
            }
          }
        }
        editItems.add(PredicateEditor());

      }

      // MessageFilter
      else if (widget.selectedItem.type == "MessageFilter") {
        if (widget.itemsPositions[widget.selectedItemID]["connectsTo"].length ==
            1) {
          messageFilterControllers.addAll({editItem: {}});

          int connectsToID;
          String textValue = "";
          if (widget.selectedItem.childDetails[editItem] == null) {
            connectsToID = widget.itemsPositions[widget.selectedItemID]
                    ["connectsTo"]
                .toList()[0];
            textValue = "";
          } else {
            connectsToID = widget.selectedItem.childDetails[editItem][0][0];
            textValue = widget.selectedItem.childDetails[editItem][0][1];
          }

          messageFilterControllers[editItem]
              .addAll({connectsToID: TextEditingController()});

          messageFilterControllers[editItem][connectsToID].text = textValue;

          editItems.add(
            TextFormField(
              decoration:
                  InputDecoration(labelText: editItem + " [$connectsToID]"),
              controller: messageFilterControllers[editItem][connectsToID],
            ),
          );
        }
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 25),
              child: Text(widget.selectedItem.type,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center),
            ),
            ...editItems,
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () => widget.updateItemDetails(
                widget.selectedItem.id,
                this.generateNewItemDetails(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
