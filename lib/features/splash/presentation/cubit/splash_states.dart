sealed class SplashState {}

class SplashInitialState extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {}

class SplashError extends SplashState {
  final String message;

  SplashError(this.message);
}

class FirstTimeUser extends SplashState {}
