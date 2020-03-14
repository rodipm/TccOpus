import 'package:flutter/material.dart';
import '../MoveableStackItem/movable_stack_item.dart';

class SampleEIP extends MoveableStackItem {
  final Function clickHandler;
  final Function updatePositionHandler;
  SampleEIP(this.clickHandler, this.updatePositionHandler)
      : super(
          clickHandler,
          updatePositionHandler,
          Container(
            width: 100,
            height: 100,
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        );
}
