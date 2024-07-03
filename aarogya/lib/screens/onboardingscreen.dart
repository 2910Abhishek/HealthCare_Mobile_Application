import 'package:flutter/material.dart';
import 'package:aarogya/widgets/customButton.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  OnboardingPageOne(nextPage: () {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  }),
                  OnboardingPageTwo(nextPage: () {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  }),
                  OnboardingPageThree(),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          OnboardingIndicators(currentPage: _currentPage, pageCount: 3),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class OnboardingPageOne extends StatelessWidget {
  final VoidCallback nextPage;

  const OnboardingPageOne({required this.nextPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Let's Get Started",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Easy to manage your health records from mobile application",
                style: TextStyle(fontSize: 16),
              ),
              Image.asset('assets/images/onboarding_screen.png'),
              SizedBox(
                height: 40,
              ),
              CustomButton(
                text: "Get Started",
                onPressed: nextPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPageTwo extends StatelessWidget {
  final VoidCallback nextPage;

  const OnboardingPageTwo({required this.nextPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Adjust padding as needed
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Track Your Health",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Easy to manage your health records from mobile application",
                  style: TextStyle(fontSize: 16),
                ),
                Image.asset('assets/images/onboarding_screen_2.png'),
                SizedBox(height: 40),
                CustomButton(
                  text: "Next",
                  onPressed: nextPage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingPageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Adjust padding as needed
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Personalized AI System",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Easy Appointment Booking, AI Healthcare Chatbot, Video Consultation",
                  style: TextStyle(fontSize: 16),
                ),
                Image.asset('assets/images/onboarding_screen_3.png'),
                SizedBox(height: 40),
                CustomButton(
                  text: "Next",
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingIndicators extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const OnboardingIndicators({
    Key? key,
    required this.currentPage,
    required this.pageCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentPage ? Colors.blue : Colors.grey,
          ),
        );
      }),
    );
  }
}
