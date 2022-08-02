import 'dart:ui' as ui;

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
    required this.body,
    required this.showLoader,
    this.text = "Authenticating",
    this.textStyle =
        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
  }) : super(key: key);
  final Widget body;
  final bool showLoader;
  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        body,
        if (showLoader)
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              height: size.height,
              width: size.width,
              color: Colors.grey.withOpacity(0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(text, style: textStyle),
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            '...',
                            textStyle: textStyle,
                            speed: const Duration(milliseconds: 200),
                          ),
                        ],
                        totalRepeatCount: 100,
                        pause: const Duration(milliseconds: 100),
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
