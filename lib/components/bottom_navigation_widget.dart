import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int colorIndex;
  final Function(int) tabIndex;

  const BottomNavigationWidget({
    super.key,
    required this.tabIndex,
    required this.colorIndex,
});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 8.0,
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: Icon(Icons.home), onPressed: () => tabIndex(0)),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => {tabIndex(1)},
          ),
          SizedBox(width: 40.0),
          IconButton(icon: Icon(Icons.color_lens), onPressed: () => {tabIndex(2)}),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => {tabIndex(3)},
          ),
        ],
      ),
    );
  }
}
