import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../widgets/buttons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String routeName = "onboarding";
  static const String path = "/onboarding";

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TracelyTheme.neutral100,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_currentPage == 0)
                    GestureDetector(
                      onTap: () {
                        // Handle skip
                        _pageController.jumpToPage(1);
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [_buildFirstPage(), _buildSecondPage()],
              ),
            ),
            // Page Indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIndicator(isActive: _currentPage == 0),
                  const SizedBox(width: 6),
                  _buildIndicator(isActive: _currentPage == 1),
                ],
              ),
            ),
            // Bottom Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PrimaryButton(
                label: _currentPage == 0 ? 'Next' : 'Get started',
                onPressed: () {
                  if (_currentPage == 0) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    context.go('/auth/signup');
                  }
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration (SVG)
          SizedBox(
            height: 351,
            child: Center(
              child: Image.asset(
                'assets/images/onboarding_1.png',
                height: 351,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 48),
          // Title
          const Text(
            'Learning is\nscattered',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: TracelyTheme.primary700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          // Description
          const Text(
            'You jump between links and\nvideos, but lose track of what\nhelped.',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF9E9E9E),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondPage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ----------------------------------------
                  // LEFT CARD (no rotation)
                  // ----------------------------------------
                  Positioned(
                    top: 1,
                    left: -1,
                    child: Image.asset(
                      "assets/images/card_left.png",
                      width: 110,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // ----------------------------------------
                  // RIGHT CARD (scaled up)
                  // ----------------------------------------
                  Positioned(
                    top: 40,
                    right: -10,
                    child: Transform.scale(
                      scale: 1.25,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/card_right.png",
                        width: 260,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // ----------------------------------------
                  // FLOATING DOTS
                  // ----------------------------------------
                  Positioned(top: 90, left: 40, child: _dot(8)),
                  Positioned(top: 150, right: 30, child: _dot(10)),
                  Positioned(top: 200, right: 120, child: _dot(7)),
                  Positioned(top: 120, left: 140, child: _dot(6)),

                  // ----------------------------------------
                  // MAIN CONTENT
                  // ----------------------------------------
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.15),

                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 351,
                            minHeight: 200,
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/onboarding_2.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Tracely maps your\nlearning journey',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: TracelyTheme.primary700,
                            height: 1.2,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Your activity becomes a simple\ntrail you can revisit anytime.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF9E9E9E),
                            height: 1.5,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: TracelyTheme.secondary500.withValues(alpha: 0.25),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildIndicator({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 4,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF3ECFA1) : const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
