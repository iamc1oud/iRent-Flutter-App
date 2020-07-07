abstract class FirebaseHandlers {
  void loginUser({String email, String password});
  void registerUser(
      {String firstName, String lastName, String email, String password});

  void findIdentityOfUser({
  String email
});
}
