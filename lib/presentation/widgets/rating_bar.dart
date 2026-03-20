import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// 읽기 전용 별점 위젯
class ReadOnlyRatingBar extends StatelessWidget {
  const ReadOnlyRatingBar({
    super.key,
    required this.rating,
    this.size = 16,
    this.color = AppTheme.starColor,
  });

  final double rating;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = index + 1 <= rating;
        final half = !filled && index + 0.5 <= rating;
        return Icon(
          filled
              ? Icons.star
              : half
                  ? Icons.star_half
                  : Icons.star_outline,
          size: size,
          color: (filled || half) ? color : Colors.grey.shade300,
        );
      }),
    );
  }
}

/// 사용자 입력 가능한 별점 위젯
class InteractiveRatingBar extends StatefulWidget {
  const InteractiveRatingBar({
    super.key,
    required this.initialRating,
    required this.onRatingChanged,
    this.size = 32,
    this.color = AppTheme.starColor,
    this.allowHalfRating = true,
  });

  final double initialRating;
  final ValueChanged<double> onRatingChanged;
  final double size;
  final Color color;
  final bool allowHalfRating;

  @override
  State<InteractiveRatingBar> createState() => _InteractiveRatingBarState();
}

class _InteractiveRatingBarState extends State<InteractiveRatingBar> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  void _onTap(int index, TapUpDetails details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final localX = box.globalToLocal(details.globalPosition).dx;
    final starWidth = box.size.width / 5;
    final starIndex = (localX / starWidth).floor();
    final starLocalX = localX - starIndex * starWidth;

    double newRating;
    if (widget.allowHalfRating && starLocalX < starWidth / 2) {
      newRating = starIndex + 0.5;
    } else {
      newRating = starIndex + 1.0;
    }

    setState(() => _currentRating = newRating);
    widget.onRatingChanged(newRating);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => _onTap(0, details, context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          final filled = index + 1 <= _currentRating;
          final half = !filled && index + 0.5 <= _currentRating;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              filled
                  ? Icons.star
                  : half
                      ? Icons.star_half
                      : Icons.star_outline,
              size: widget.size,
              color: (filled || half) ? widget.color : Colors.grey.shade300,
            ),
          );
        }),
      ),
    );
  }
}
