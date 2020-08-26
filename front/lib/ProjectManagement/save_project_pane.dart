import 'package:flutter/material.dart';

class SaveProjectPane extends StatefulWidget {
  final Function updateProjectInfoHandler;
  final double canvasPaneHeight;
  final double mainCanvasSize;

  SaveProjectPane(this.updateProjectInfoHandler, this.canvasPaneHeight,
      this.mainCanvasSize);

  @override
  _SaveProjectPaneState createState() => _SaveProjectPaneState();
}

class _SaveProjectPaneState extends State<SaveProjectPane> {
  final projectNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Salvar Projeto"),
      content: Text("Projeto Salvo."),
      actions: <Widget>[
        FlatButton(
          child: Text("Fechar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
