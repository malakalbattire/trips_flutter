import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Heart extends StatefulWidget {
  const Heart({super.key});

  @override
  _HeartState createState() => _HeartState();
}

class _HeartState extends State<Heart> with SingleTickerProviderStateMixin {
  bool isFav = false;
  bool liked = true;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;

  final tripRef = FirebaseFirestore.instance.collection('trips');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _colorAnimation = ColorTween(begin: Colors.grey[400], end: Colors.red)
        .animate(_controller);
    _sizeAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 30, end: 50),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 50, end: 30),
        weight: 50,
      ),
    ]).animate(_controller);

    _controller.addListener(
      () {
        setState(() {});
        //print(_controller.value);
        // print(_colorAnimation.value);
      },
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isFav = true;
      }
      if (status == AnimationStatus.dismissed) {
        isFav = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: tripRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
        } else if (!snapshot.hasData) {}
        return AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, _) {
            return IconButton(
              icon: Icon(
                Icons.favorite,
                color: _colorAnimation.value,
                size: _sizeAnimation.value,
              ),
              onPressed: () {
                isFav ? _controller.reverse() : _controller.forward();
                tripRef.add({
                  'likes': liked,
                  'tripId': 'ff',
                });
              },
            );
          },
        );
      },
    );
  }
}
