//import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  final String text;
  Details(this.text);
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  //final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _key,
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              // FlutterClipboard.copy(widget.text).then((value) => _key
              //     .currentState
              //     .ScaffoldMessenger.showSnackBar(new SnackBar(content: Text('Copied'))));
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        child: SelectableText(
            widget.text.isEmpty ? 'No Text Available' : widget.text),
      ),
    );
  }
}