class OnboardingItem {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

final List<OnboardingItem> onboardingItems = [
  const OnboardingItem(
    imagePath: 'assets/images/onboarding/welcome.png',
    title: 'Welcome to EcoPamoja',
    description:
        'An app to help you live sustainably and connect with a community of like minded individuals.',
  ),
  const OnboardingItem(
    imagePath: 'assets/images/onboarding/events.png',
    title: 'Join Local Events',
    description:
        'Participate in community events focused on sustainability.',
  ),
  const OnboardingItem(
    imagePath: 'assets/images/onboarding/community.png',
    title: 'Shop Sustainably',
    description: 'Discover eco-friendly products from trusted partners.',
  ),
];
