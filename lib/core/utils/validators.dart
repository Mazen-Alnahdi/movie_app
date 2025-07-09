class Validators {
  static final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{6,}$',
  );

  static final RegExp nameRegex = RegExp(r"^[a-zA-Z ]{2,30}$");

  static bool isValidEmail(String email) => emailRegex.hasMatch(email);

  static bool isValidPassword(String password) =>
      passwordRegex.hasMatch(password);

  static bool isValidName(String name) => nameRegex.hasMatch(name);
}
