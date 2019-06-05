class MyService {
  Future<String> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return "";
  }
}