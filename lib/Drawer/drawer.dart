
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestAnimation extends StatefulWidget {
  @override
  _TestAnimationState createState() => _TestAnimationState();
}


class _TestAnimationState extends State<TestAnimation> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animation = IntTween(begin: 100, end: 0).animate(_animationController!);
    _animation!.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 100,
              child: OutlinedButton(
                child: Text("Left"),
                onPressed: () {
                  if (_animationController!.value == 0.0) {
                    _animationController!.forward();
                  } else {
                    _animationController!.reverse();
                  }
                },
              ),
            ),
            Expanded(
              flex: _animation!.value,
              // Uses to hide widget when flex is going to 0
              child: SizedBox(
                width: 0,
                child: OutlinedButton(
                  child: Text(
                    "Right",
                  ),
                  onPressed: () {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}