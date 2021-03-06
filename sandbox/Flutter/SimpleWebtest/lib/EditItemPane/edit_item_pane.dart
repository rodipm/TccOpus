import 'dart:developer';

import 'package:front/MoveableStackItem/movable_stack_item.dart';
import 'package:flutter/material.dart';

class EditItemPane extends StatefulWidget {
  final MoveableStackItem selectedItem;
  final Function updateItemDetails;
  EditItemPane(this.selectedItem, this.updateItemDetails);
  @override
  _EditItemPaneState createState() => _EditItemPaneState();
}

class _EditItemPaneState extends State<EditItemPane> {
  List<Widget> editItems = [];
  Map<String, TextEditingController> editItemsControllers = {};

  Map<String, dynamic> generateNewItemDetails() {
    Map<String, dynamic> newItemDetails = {};
    print(editItemsControllers);
    for (String editItem in widget.selectedItem.componentConfigs.keys) {
      newItemDetails.addAll({editItem: editItemsControllers[editItem].text});
    }
    return newItemDetails;
  }

  @override
  Widget build(BuildContext context) {
    this.editItems = [];
    this.editItemsControllers = {};
    for (String editItem in widget.selectedItem.componentConfigs.keys) {
      editItemsControllers.addAll({editItem: TextEditingController()});
      editItemsControllers[editItem].text =
          widget.selectedItem.componentConfigs[editItem];
      print(widget.selectedItem.componentConfigs);
      editItems.add(
        TextFormField(
          decoration: InputDecoration(labelText: editItem),
          controller: editItemsControllers[editItem],
        ),
      );
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
