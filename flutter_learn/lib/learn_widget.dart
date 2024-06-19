import 'package:flutter/material.dart';

//ignore: must_be_immutable
class MyWidget2 extends StatefulWidget {
  bool isLoading = true;

  MyWidget2(this.isLoading, {super.key});

  @override
  State<MyWidget2> createState() => _MyWidget2State();
}

class _MyWidget2State extends State<MyWidget2> {
  late bool _localLoading;

  @override
  void initState() {
    _localLoading = widget.isLoading;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _localLoading
        ? const CircularProgressIndicator()
        : Center(
      child: RichText(
        text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: const <TextSpan>[
              TextSpan(text: "Hello"),
              TextSpan(
                text: "world",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    // fontFamily: "Times New Rome",
                    wordSpacing: 10,
                    letterSpacing: 1.6,
                    decoration: TextDecoration.lineThrough),
              )
            ]),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}