import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../app/theme.dart';
import '../data/dummy.dart';
import '../models/trail.dart';

class TrailCard extends StatelessWidget{
  final Trail trail;
  final bool isBanner;

  const TrailCard({super.key, required this.trail, required this.isBanner});

  // Helper for the small info chips (dynamic)
  Widget _buildStatChip(int itemCount, IconData icon, Color cardBackgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TracelyTheme.primary900,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: TracelyTheme.primary900),
          const SizedBox(width: 4),
          Text(
            "$itemCount ${itemCount == 1 ? 'item' : 'items'}",
            style: const TextStyle(fontSize: 12, color: TracelyTheme.primary900),
          ),
        ],
      ),
    );
  }


  Widget _buildCircularIcon(IconData icon, Color iconColor) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white, // background color of the circle
        shape: BoxShape.circle,
        border: Border.all(
          color: TracelyTheme.primary900.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: 16,
          color: iconColor,
        ),
      ),
    );
  }


  Widget _buildCircularImage(String assetPath) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, // outer background
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor = isBanner ? TracelyTheme.primary500 : TracelyTheme.primary100;
    Color textColor = isBanner ? TracelyTheme.neutral0 : TracelyTheme.primary900;
    Color subTextColor = isBanner ? TracelyTheme.neutral100 : TracelyTheme.primary900;

    return Animate(
      effects: const [
        FadeEffect(),
        MoveEffect(),
      ],
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if(!isBanner) BoxShadow(color: TracelyTheme.neutral200.withValues(alpha: 0.1), offset: const Offset(0, 3), blurRadius: 5)
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trail.title,
                        style: TextStyle(
                          color: textColor,
                          fontFamily: "PlusJakartaSans",
                          fontSize:  20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      if (isBanner) ...[
                        const SizedBox(height: 5),
                        Text(
                          trail.subtitle,
                          style: TextStyle(
                            color: subTextColor,
                            fontFamily: "PlusJakartaSans",
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )
                      ]
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                if (isBanner)
                  Transform.rotate(
                    angle: 50 * 3.1415926535 / 180, // 50 degrees in radians
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TracelyTheme.secondary500,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        IconsaxPlusLinear.arrow_up,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            // Progress tracking will be added when Trail model supports it
            if (!isBanner)
            // Social/Media Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // LEFT: Chip - Get resources for this trail from dummy data
                  _buildStatChip(getResourcesForTrail(trail.id).length, IconsaxPlusLinear.folder_2, cardColor),

                  // RIGHT: Icons in a row
                  SizedBox(
                    height: 40,
                    width: 99, // adjust as needed
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          child: _buildCircularIcon(IconsaxPlusLinear.note_2, TracelyTheme.links),
                        ),
                        Positioned(
                          left: 22, // overlap amount
                          child: _buildCircularIcon(IconsaxPlusLinear.global, Color(0xffFF7A00)),
                        ),
                        Positioned(
                          left: 44,
                          child: _buildCircularImage('assets/images/youtube.png'),
                        ),
                        Positioned(
                          left: 66,
                          child: _buildCircularIcon(IconsaxPlusLinear.add, Colors.black),
                        ),
                      ],
                    ),
                  )

                ],
              )
          ]
        ),
      ),
    );
  }
}