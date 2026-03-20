class OnboardingForm {
  const OnboardingForm({
    this.name = '',
    this.email = '',
    this.password = '',
  });

  final String name;
  final String email;
  final String password;

  OnboardingForm copyWith({
    String? name,
    String? email,
    String? password,
  }) {
    return OnboardingForm(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
