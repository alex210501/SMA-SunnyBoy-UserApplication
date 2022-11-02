import 'package:flutter/material.dart';

class ListViewContainer extends StatelessWidget {
  final String? title;
  List<Widget> children;

  ListViewContainer({required this.children, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(0.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          title != null
              ? Text(
            title!,
            style: const TextStyle(fontSize: 20),
          )
              : Container(),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(10),
              child: ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: children))
        ]));
  }
}