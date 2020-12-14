// Base widget for stackable movable item
import 'package:front/MoveableStackItem/movable_stack_item.dart';
import 'package:flutter/material.dart';

class EditItemPane extends StatefulWidget {
  final MoveableStackItem selectedItem;
  final int selectedItemID;
  final Function updateItemDetails;
  final Function deleteItem;
  final Map<int, Map<String, dynamic>> itemsPositions;
  EditItemPane(this.selectedItem, this.selectedItemID, this.updateItemDetails, this.deleteItem,
      this.itemsPositions);

  @override
  _EditItemPaneState createState() => _EditItemPaneState();
}

class _EditItemPaneState extends State<EditItemPane> {
  List<Widget> editItems = [];

  Map<String, dynamic> componentConfigControllers;

  Map<String, dynamic> updateComponentConfigs() {
    Map<String, dynamic> newComponentConfigs;
    for (String componentConfig in widget.selectedItem.componentConfigs.keys) {
      newComponentConfigs = widget.selectedItem.updateConfigs(
          widget.selectedItem, componentConfig, componentConfigControllers);
    }

    return newComponentConfigs;
  }

  @override
  Widget build(BuildContext context) {
    //print("WIDGET SELECTEDITEM COMPONENTCONFIGS");
    //print(widget.selectedItem.componentConfigs);
    this.editItems = [];
    this.componentConfigControllers =
        Map<String, dynamic>.from(widget.selectedItem.componentConfigControllers);

    for (String componentConfig in widget.selectedItem.componentConfigs.keys) {
      editItems = widget.selectedItem.buildEditPane(
          widget.selectedItem,
          widget.selectedItemID,
          widget.itemsPositions,
          componentConfig,
          this.componentConfigControllers,
          this.editItems,
          this);
    }

    return Container(
      padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
      decoration: BoxDecoration(color: Colors.grey.shade700, borderRadius: BorderRadius.circular(10),),
      margin: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width * 0.02, 0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () => widget.updateItemDetails(
                    widget.selectedItem.id,
                    this.updateComponentConfigs(),
                    this.componentConfigControllers,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red,),
                  onPressed: () => widget.deleteItem(
                    widget.selectedItem.id,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
