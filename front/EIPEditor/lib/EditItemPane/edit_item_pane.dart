import 'dart:developer';

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
  Map<String, TextEditingController> editItemsControllers = {};
  Map<String, dynamic> inputAutomaticoControllers = {};
  Map<String, dynamic> editItemsValues = {};
  String testeEscolha = "direct";

  Map<String, dynamic> generateNewItemDetails() {
    Map<String, dynamic> newItemDetails = {};
    print(editItemsControllers);

    for (String editItem in widget.selectedItem.childDetails.keys) {
      // Input de texto -> String
      if (widget.selectedItem.childDetails[editItem] is String)
        newItemDetails.addAll({editItem: editItemsControllers[editItem].text});

      // DropDown button -> List(List(String(),...), String())
      else if (widget.selectedItem.childDetails[editItem] is List &&
          widget.selectedItem.childDetails[editItem].length == 2 &&
          (widget.selectedItem.childDetails[editItem][1] is String ||
              widget.selectedItem.childDetails[editItem][1] == null)) {
        newItemDetails.addAll({
          editItem: [
            widget.selectedItem.childDetails[editItem][0],
            editItemsValues[editItem]
          ]
        });
      }

      // Lista de input de texto automatico -> Lista
      else if (widget.selectedItem.childDetails[editItem] == null ||
          (widget.selectedItem.childDetails[editItem] is List &&
              widget.selectedItem.childDetails[editItem][0] is List)) {
        print("GENERATE NEW ITEMS DETAILS");

        newItemDetails.addAll({editItem: []});
        for (var choiceTargetID in inputAutomaticoControllers[editItem].keys) {
          print(inputAutomaticoControllers[editItem][choiceTargetID].text);
          newItemDetails[editItem].add([
            choiceTargetID,
            inputAutomaticoControllers[editItem][choiceTargetID].text
          ]);
        }
        print(newItemDetails);
      }
    }
    return newItemDetails;
  }

  @override
  Widget build(BuildContext context) {
    this.editItems = [];
    // this.editItemsControllers = {};

    // Input de texto -> String
    for (String editItem in widget.selectedItem.childDetails.keys) {
      // Input de texto -> ""
      if (widget.selectedItem.childDetails[editItem] is String) {
        editItemsControllers.addAll({editItem: TextEditingController()});

        editItemsControllers[editItem].text =
            widget.selectedItem.childDetails[editItem];
        print(widget.selectedItem.childDetails);
        editItems.add(
          TextFormField(
            decoration: InputDecoration(labelText: editItem),
            controller: editItemsControllers[editItem],
          ),
        );
      }

      // DropDown button -> List(List(String(),...), String())
      else if (widget.selectedItem.childDetails[editItem] is List &&
          widget.selectedItem.childDetails[editItem].length == 2 &&
          (widget.selectedItem.childDetails[editItem][1] is String ||
              widget.selectedItem.childDetails[editItem][1] == null)) {
        String _chosenValue;
        print("EXECUTADO!");

        if (widget.selectedItem.childDetails[editItem][1] != null)
          _chosenValue = widget.selectedItem.childDetails[editItem][1];
        else if (editItemsValues[editItem] != null)
          _chosenValue = editItemsValues[editItem];
        else
          _chosenValue = widget.selectedItem.childDetails[editItem][0][0];
        print(_chosenValue);
        editItemsValues.addAll({editItem: _chosenValue});
        editItems.add(
          DropdownButton<String>(
            value: editItemsValues[editItem],
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            onChanged: (String newValue) {
              setState(() {
                print("old");
                print(editItemsValues);
                editItemsValues[editItem] = newValue;
                print(editItemsValues);
              });
            },
            items: widget.selectedItem.childDetails[editItem][0]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ); // editItem.add
      }

      // Lista de input de texto automatico -> Lista
      else if (widget.selectedItem.childDetails[editItem] == null ||
          (widget.selectedItem.childDetails[editItem] is List &&
              widget.selectedItem.childDetails[editItem][0] is List)) {
        print("LISTA INPUT AUTOMATICO");
        print(widget.selectedItem.childDetails[editItem]);

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
          print("LISTA INPUT ||| ELSE |||");
          print(widget.selectedItem.childDetails[editItem]);
          print(inputAutomaticoControllers);
          inputAutomaticoControllers.addAll({editItem: {}});
          for (var i in widget.selectedItem.childDetails[editItem]) {
            print(i);
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
              inputAutomaticoControllers[editItem][i].text =
                  "";

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

      print(inspect(editItemsControllers));
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
