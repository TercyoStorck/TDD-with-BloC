import 'dart:async';

mixin Validator {
  final usernameValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (username, sink) {
      if(username?.isNotEmpty != true) {
        sink.addError("Username cannot be empty");
        return;
      }

      sink.add(username);
    }
  );

  final passwordValidator = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if(password?.isNotEmpty != true) {
        sink.addError("Password cannot be empty");
        return;
      }

      sink.add(password);
    }
  );
}