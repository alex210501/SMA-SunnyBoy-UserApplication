import 'package:flutter/material.dart';

import './listview_container.dart';

class ListViewContainerWithTitle extends StatelessWidget {
  final String title;
  final List<Widget> children;

  ListViewContainerWithTitle(
      {Key? key, required this.title, required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
            ListViewContainer(children: children)
          ],
        ));
  }
}
