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
  Map<String, TextEditingController> inputTextoControllers = {};
  Map<String, dynamic> dropDownOptionsControllers = {};
  Map<String, dynamic> inputAutomaticoControllers = {};
  Map<String, dynamic> editItemsValues = {};

  Map<String, dynamic> generateNewItemDetails() {
    Map<String, dynamic> newItemDetails = {};

    for (String editItem in widget.selectedItem.childDetails.keys) {
      // Input de texto -> String
      if (widget.selectedItem.childDetails[editItem] is String)
        newItemDetails.addAll({editItem: inputTextoControllers[editItem].text});

      // DropDown button -> List(List(String(),...), String())
      else if (widget.selectedItem.childDetails[editItem] is List &&
          widget.selectedItem.childDetails[editItem].length == 3 &&
          (widget.selectedItem.childDetails[editItem][1] is String ||
              widget.selectedItem.childDetails[editItem][1] == null)) {
        var protocolOptions = List();

        if (editItemsValues[editItem] != null) {
          for (var protocolOption in widget.selectedItem.childDetails[editItem]
              [0][editItemsValues[editItem]]) {
            protocolOptions
                .add(dropDownOptionsControllers[protocolOption].text);
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

      // Lista de input de texto automatico -> Lista
      else if (widget.selectedItem.childDetails[editItem] == null ||
          (widget.selectedItem.childDetails[editItem] is List &&
              widget.selectedItem.childDetails[editItem][0] is List)) {
        newItemDetails.addAll({editItem: []});
        for (var choiceTargetID in inputAutomaticoControllers[editItem].keys) {
          newItemDetails[editItem].add([
            choiceTargetID,
            inputAutomaticoControllers[editItem][choiceTargetID].text
          ]);
        }
      }
    }
    return newItemDetails;
  }

  @override
  Widget build(BuildContext context) {
    this.editItems = [];
    // this.inputTextoControllers = {};

    // Input de texto -> String
    for (String editItem in widget.selectedItem.childDetails.keys) {
      // Input de texto -> ""
      if (widget.selectedItem.childDetails[editItem] is String) {
        inputTextoControllers.addAll({editItem: TextEditingController()});

        inputTextoControllers[editItem].text =
            widget.selectedItem.childDetails[editItem];
        editItems.add(
          TextFormField(
            decoration: InputDecoration(labelText: editItem),
            controller: inputTextoControllers[editItem],
          ),
        );
      }

      // DropDown button -> List(List(String(),...), String())
      else if (widget.selectedItem.childDetails[editItem] is List &&
          widget.selectedItem.childDetails[editItem].length == 3 &&
          (widget.selectedItem.childDetails[editItem][1] is String ||
              widget.selectedItem.childDetails[editItem][1] == null)) {
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
            dropDownOptionsControllers
                .addAll({protocolOption: TextEditingController()});

            String controllerTextValue = "";
            if (protocolOptionIndex <
                widget.selectedItem.childDetails[editItem][2].length) {
              controllerTextValue = widget.selectedItem.childDetails[editItem]
                  [2][protocolOptionIndex];
              protocolOptionIndex++;
            }

            dropDownOptionsControllers[protocolOption].text =
                controllerTextValue;

            editItems.add(
              TextFormField(
                decoration: InputDecoration(labelText: protocolOption),
                controller: dropDownOptionsControllers[protocolOption],
              ),
            );
          }
        }
      }

      // Lista de input de texto automatico -> Lista
      else if (widget.selectedItem.childDetails[editItem] == null ||
          (widget.selectedItem.childDetails[editItem] is List &&
              widget.selectedItem.childDetails[editItem][0] is List)) {
        if (widget.selectedItem.childDetails[editItem] == null) {
          inputAutomaticoControllers.addAll({editItem: {}});
          for (int i in widget.itemsPositions[widget.selectedItemID]
              ["connectsTo"]) {
            inputAutomaticoControllers[editItem]
                .addAll({i: TextEditingController()});
            inputAutomaticoControllers[editItem][i].text =
                widget.selectedItem.childDetails[editItem];

            editItems.add(
              TextFormField(
                decoration: InputDecoration(labelText: editItem + " [$i]"),
                controller: inputAutomaticoControllers[editItem][i],
              ),
            );
          }
        } else {
          inputAutomaticoControllers.addAll({editItem: {}});
          for (var i in widget.selectedItem.childDetails[editItem]) {
            inputAutomaticoControllers[editItem]
                .addAll({i[0]: TextEditingController()});
            inputAutomaticoControllers[editItem][i[0]].text = i[1];

            editItems.add(
              TextFormField(
                decoration: InputDecoration(labelText: editItem + " [${i[0]}]"),
                controller: inputAutomaticoControllers[editItem][i[0]],
              ),
            );
          }

          for (int i in widget.itemsPositions[widget.selectedItemID]
              ["connectsTo"]) {
            if (!inputAutomaticoControllers[editItem]
                .keys
                .toList()
                .contains(i)) {
              inputAutomaticoControllers[editItem]
                  .addAll({i: TextEditingController()});
              inputAutomaticoControllers[editItem][i].text = "";

              editItems.add(
                TextFormField(
                  decoration: InputDecoration(labelText: editItem + " [$i]"),
                  controller: inputAutomaticoControllers[editItem][i],
                ),
              );
            }
          }
        }
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
      child: Center(
        child: Column(
          children: <Widget>[
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
