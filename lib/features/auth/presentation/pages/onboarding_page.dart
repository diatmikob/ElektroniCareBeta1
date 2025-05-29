import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: 'Expert Repair Services',
      description: 'Connect with certified technicians for all your electronic device repairs',
      image: '🔧',
      color: AppTheme.primaryColor,
    ),
    OnboardingData(
      title: 'Track Your Repairs',
      description: 'Monitor the progress of your device repairs in real-time',
      image: '📱',
      color: AppTheme.accentColor,
    ),
    OnboardingData(
      title: 'Fast & Reliable',
      description: 'Get your devices fixed quickly with our trusted repair network',
      image: '⚡',
      color: AppTheme.successColor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: TextButton(
                  onPressed: _navigateToLogin,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return AnimationLimiter(
                    child: _buildOnboardingPage(_onboardingData[index], index),
                  );
                },
              ),
            ),
            
            // Page indicator and navigation
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  // Page indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      _buildPageIndicator,
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.largePadding),
                  
                  // Navigation buttons
                  Row(
                    children: [
                      if (_currentPage > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: AppConstants.mediumAnimation,
                                curve: Curves.easeInOut,
                              );
                            },
                            child: const Text('Previous'),
                          ),
                        ),
                      
                      if (_currentPage > 0) const SizedBox(width: 16),
                      
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentPage == _onboardingData.length - 1) {
                              _navigateToLogin();
                            } else {
                              _pageController.nextPage(
                                duration: AppConstants.mediumAnimation,
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Text(
                            _currentPage == _onboardingData.length - 1
                                ? 'Get Started'
                                : 'Next',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data, int index) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: AnimationConfiguration.staggeredList(
          position: index,
          duration: AppConstants.longAnimation,
          child: Column(
            children: [
              SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: data.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        data.image,
                        style: const TextStyle(fontSize: 80),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppConstants.largePadding * 2),
              
              SlideAnimation(
                verticalOffset: 30.0,
                child: FadeInAnimation(
                  child: Text(
                    data.title,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              
              const SizedBox(height: AppConstants.defaultPadding),
              
              SlideAnimation(
                verticalOffset: 20.0,
                child: FadeInAnimation(
                  child: Text(
                    data.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondaryColor,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return AnimatedContainer(
      duration: AppConstants.shortAnimation,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? AppTheme.primaryColor
            : AppTheme.textLightColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void _navigateToLogin() {
    context.go(AppRoutes.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingData {

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
  final String title;
  final String description;
  final String image;
  final Color color;
}