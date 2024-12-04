import 'package:flutter/material.dart';

// ~~~~~~~~~~~~~~~~~~~~~~~~~
// SPACERS

class Spacer1 extends StatelessWidget {
  const Spacer1({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 25, width: 25);
  }
}

class Spacer2 extends StatelessWidget {
  const Spacer2({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 50, width: 50);
  }
}

class Spacer3 extends StatelessWidget {
  const Spacer3({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 75, width: 75);
  }
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~
// TEXT

class MenuText extends StatelessWidget {
  final String text;
  final Color? color;

  const MenuText({required this.text, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: color == null ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.titleLarge!.copyWith(color: color));
  }
}

class SubtitleText extends StatelessWidget {
  final String text;
  final Color? color;

  const SubtitleText({required this.text, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: color == null ? Theme.of(context).textTheme.displaySmall : Theme.of(context).textTheme.displaySmall!.copyWith(color: color));
  }
}

class BodyText extends StatelessWidget {
  final String text;
  final Color? color;

  const BodyText({required this.text, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: color == null ? Theme.of(context).textTheme.displaySmall : Theme.of(context).textTheme.displaySmall!.copyWith(color: color));
  }
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~
// BUTTONS

class RoundButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Widget child;

  const RoundButton({required this.onPressed, this.backgroundColor = Colors.white, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        foregroundColor: MaterialStateProperty.all<Color>(backgroundColor),
        overlayColor: MaterialStateProperty.all<Color>(backgroundColor),
        shadowColor: MaterialStateProperty.all<Color>(backgroundColor),
        elevation: MaterialStateProperty.all<double>(0.1),
      ), 
      child: child,
    );
  }
}

class ColoredTextButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;

  const ColoredTextButton({required this.text, required this.onPressed, this.color, super.key});
  
  @override
  ColoredTextButtonState createState() => ColoredTextButtonState();
}

class ColoredTextButtonState extends State<ColoredTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: _isHovered ? 10 : 0),
      child: TextButton(
        style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
        onHover: (value) {
          setState(() {
            _isHovered = value;
          });
        },
        onPressed: widget.onPressed,
        child: MenuText(text: widget.text, color: widget.color),
      ),
    );
  }
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~
// CONTAINERS

class CenteredContainer extends StatelessWidget {
  final Widget child;

  const CenteredContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 740, maxWidth: 740), 
        child: child,
      ),
    );
  }
}

class RoundedContainer extends StatelessWidget {
  final List<Widget> children;
  final bool light;

  const RoundedContainer({required this.children, this.light = true, super.key});

  @override
  Widget build(BuildContext context) {
    return CenteredContainer(
      child: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: light ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~
// ANIMATIONS

class SlideAnimation extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const SlideAnimation({required this.onPressed, required this.child, super.key});

  @override
  SlideAnimationState createState() => SlideAnimationState();
}

class SlideAnimationState extends State<SlideAnimation> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween(begin: -5.0, end: 5.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onHover: (value) {
        if (value) {
          _controller.forward(from: 0);
        } else {
          _controller.reverse();
        }
      },
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Transform.translate(
        offset: Offset(_animation.value, 0),
        child: widget.child,
      ),
    );
  }
}