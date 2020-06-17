import 'package:flutter/material.dart';

class PredicateEditor extends StatefulWidget {
  final expressions = {
    "body": [],
    "header": ["string"]
  };
  final predicates = {
    "isNull": [],
    "isNotNull": [],
    "isEqualTo": ["string"],
    "isGreaterThan": ["string"],
    "isLessThan": ["string"],
    "startsWith": ["string"],
    "endsWith": ["string"],
    "not": ["predicate", "predicate"],
    "and": ["predicate", "predicate"],
    "or": ["predicate", "predicate"],
  };

  final generatedPredicate = [{0: {}}];

  @override
  _PredicateEditorState createState() => _PredicateEditorState();
}

class _PredicateEditorState extends State<PredicateEditor> {
  @override
  Widget build(BuildContext context) {
    String _value;
    Map<String, dynamic> _items = {};

    if (widget.generatedPredicate.length == 1) {
      _items.addAll({...widget.expressions});
      _items.addAll({
        "not": widget.predicates["not"],
        "and": widget.predicates["and"],
        "or": widget.predicates["or"]
      });
      _value = _items.keys.toList().first;
    } else {
      dynamic lastItem = widget.generatedPredicate.last;

      // if (lastItem.keys[0])
    }
    return Container(
      height: 500,
      child: GridView.count(
        crossAxisCount: 2,
        children: widget.generatedPredicate.map((pred) {
          DropdownButton<String>(
            value: _value,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            onChanged: (String newValue) {
              setState(() {
                widget.generatedPredicate.add({
                  widget.generatedPredicate.length: {
                    "op": newValue,
                  }
                });
              });
            },
            items: _items.keys
                .toList()
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
