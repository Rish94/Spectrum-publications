import 'package:flutter/material.dart';

class BookLoader extends StatefulWidget {
  final double size;
  final Color? color;

  const BookLoader({
    super.key,
    this.size = 50.0,
    this.color,
  });

  @override
  State<BookLoader> createState() => _BookLoaderState();
}

class _BookLoaderState extends State<BookLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_flipAnimation.value * 3.14159)
            ..translate(0.0, -_bounceAnimation.value * 10.0),
          child: Icon(
            Icons.book,
            size: widget.size,
            color: color,
          ),
        );
      },
    );
  }
}
