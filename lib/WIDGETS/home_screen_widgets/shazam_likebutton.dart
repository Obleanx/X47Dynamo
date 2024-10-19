import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable(
      feedback: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      childWhenDragging: Container(),
      child: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // TODO: Implement create post functionality
        },
      ),
    );
  }
}
