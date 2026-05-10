import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_states.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit()
    : pageController = PageController(),
      slideController = AnimationController(
        vsync: const _TickerProvider(),
        duration: const Duration(milliseconds: 800),
      ),
      fadeController = AnimationController(
        vsync: const _TickerProvider(),
        duration: const Duration(milliseconds: 600),
      ),
      super(OnboardingState.initial()) {
    startAnimation();
  }

  final PageController pageController;

  final AnimationController slideController;
  final AnimationController fadeController;

  final List<Map<String, dynamic>> pages = [
    {
      'image': 'assets/images/onboarding1.png',
      'title': 'اكتشف تصاميم \nبطابع فريد',
      'subtitle':
          'تصفح مجموعة كبيرة من التصاميم والأفكار المستوحاة من الفن والهوية العربية الحديثة.',
    },
    {
      'image': 'assets/images/onboarding2.png',
      'title': 'صمم تحفتك \nبطريقتك الخاصة',
      'subtitle':
          'حوّل أفكارك إلى منتجات حقيقية مثل التيشيرتات والأكواب بسهولة واحترافية.',
    },
    {
      'image': 'assets/images/onboarding3.png',
      'title': 'شارك إبداعك \n مع الجميع',
      'subtitle':
          'اعرض أعمالك وتفاعل مع مجتمع من المبدعين والفنانين في مكان واحد.',
    },
  ];

  void startAnimation() {
    slideController.forward();
    fadeController.forward();
  }

  void onPageChanged(int page) {
    emit(state.copyWith(currentPage: page));

    slideController.reset();
    fadeController.reset();

    slideController.forward();
    fadeController.forward();
  }

  @override
  Future<void> close() {
    pageController.dispose();
    slideController.dispose();
    fadeController.dispose();
    return super.close();
  }
}

class _TickerProvider extends TickerProvider {
  const _TickerProvider();

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
