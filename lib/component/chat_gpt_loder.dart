import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/colors.dart';

/// A simple loading widget used for AI text generation feedback
class ChatGPTLoadingWidget extends StatefulWidget {
  const ChatGPTLoadingWidget({Key? key}) : super(key: key);

  @override
  State<ChatGPTLoadingWidget> createState() => _ChatGPTLoadingWidgetState();
}

class _ChatGPTLoadingWidgetState extends State<ChatGPTLoadingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final opacity = ((_controller.value + delay) % 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Opacity(
                opacity: opacity > 0.5 ? 1 - opacity : opacity + 0.5,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
