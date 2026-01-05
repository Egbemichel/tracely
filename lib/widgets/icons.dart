import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TracelyIcon extends StatelessWidget {
  final String path;
  final double? size;
  final Color? color;

  const TracelyIcon({super.key, required this.path, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      alignment: Alignment.center,
      path,
      width: size,
      height: size,
      color: color,
      colorBlendMode: BlendMode.srcIn,
      fit: BoxFit.scaleDown,
    );
  }
}
