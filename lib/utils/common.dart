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

class BodyText extends StatelessWidget {
  final String text;
  final Color? color;

  const BodyText({required this.text, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: color == null ? Theme.of(context).textTheme.bodyMedium : Theme.of(context).textTheme.bodyMedium!.copyWith(color: color));
  }
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~
// BUTTONS

class RoundButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final Color backgroundColor;

  const RoundButton({required this.onPressed, required this.text, this.textColor = Colors.black, this.backgroundColor = Colors.white, super.key});

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
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor)),
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