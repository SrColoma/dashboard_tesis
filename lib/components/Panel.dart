import 'package:flutter/material.dart';

class Panel extends StatelessWidget {
  Widget child;
  Panel({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      // color: Colors.blueGrey[700],
      elevation: 5,
      margin: const EdgeInsets.all(5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      )
    );
  }
}