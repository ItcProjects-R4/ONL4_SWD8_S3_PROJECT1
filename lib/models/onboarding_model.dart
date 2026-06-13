class OnboardingModel {
  final String image;
  final String title;
  final String subtitle;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

final List<OnboardingModel> contents = [
    OnboardingModel(
    image: "assets/images/splash.png",
    title: "Welcome",
    subtitle: "Discover recipes",
  ),
  OnboardingModel(
    image: "assets/images/Onboarding1.jpg",
    title: "Recipe app",
    subtitle: "cook like a chef",
  ),
  OnboardingModel(
    image: "assets/images/Onboarding2.jpg",
    title: "Cook Easy",
    subtitle: "Step by step guide",
  ),
  OnboardingModel(
    image: "assets/images/Onboarding3.jpg",
    title: "Enjoy",
    subtitle: "Save favorites",
  ),
];