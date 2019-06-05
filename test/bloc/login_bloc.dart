import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:mockito/mockito.dart' as mockito;
import 'package:tdd_with_bloc/bloc/login/login_bloc.dart';

import '../mocks.dart';

main() {
  LoginBloc loginBloc;
  MockMyService service;

  flutter_test.setUp(() async {
    service = MockMyService();
    loginBloc = LoginBloc(
      myService: service,
    );
  });

  flutter_test.test("when username is empty emits error", () {
    loginBloc.userName("");

    flutter_test.expect(
      loginBloc.userNameStream,
      flutter_test.emitsError("Username cannot be empty"),
    );
  });

  flutter_test.test("when password is empty emits error", () {
    loginBloc.password("");

    flutter_test.expect(
      loginBloc.passwordStream,
      flutter_test.emitsError("Password cannot be empty"),
    );
  });

  flutter_test.test("when submit form set isPostingFormStream to true", () {
    loginBloc.submit();

    flutter_test.expect(
      loginBloc.isPostingFormStream,
      flutter_test.emits(true),
    );
  });

  flutter_test.test("when submit form and username is null, emits errors", () {
    loginBloc.submit();

    flutter_test.expect(
      loginBloc.userNameStream,
      flutter_test.emitsError("Username cannot be empty"),
    );

    flutter_test.expect(
      loginBloc.formErrorMessage,
      flutter_test.emits("Please fill in all fields correctly"),
    );
  });

  flutter_test.test("when submit form and username is empty, emits errors", () {
    loginBloc.userName("");

    loginBloc.submit();

    flutter_test.expect(
      loginBloc.userNameStream,
      flutter_test.emitsError("Username cannot be empty"),
    );

    flutter_test.expect(
      loginBloc.formErrorMessage,
      flutter_test.emits("Please fill in all fields correctly"),
    );
  });

  flutter_test.test("when submit form and password is null, emits errors", () {
    loginBloc.submit();

    flutter_test.expect(
      loginBloc.passwordStream,
      flutter_test.emitsError("Password cannot be empty"),
    );

    flutter_test.expect(
      loginBloc.formErrorMessage,
      flutter_test.emits("Please fill in all fields correctly"),
    );
  });

  flutter_test.test("when submit form and password is empty, emits errors", () {
    loginBloc.password("");

    loginBloc.submit();

    flutter_test.expect(
      loginBloc.passwordStream,
      flutter_test.emitsError("Password cannot be empty"),
    );

    flutter_test.expect(
      loginBloc.formErrorMessage,
      flutter_test.emits("Please fill in all fields correctly"),
    );
  });

  flutter_test.test("when submit from and request fails, emits error", () {
    final username = "username";
    final password = "password";

    loginBloc.userName(username);
    loginBloc.password(password);

    mockito
        .when(service.login(username, password))
        .thenThrow("Error from service");

    loginBloc.submit();

    flutter_test.expect(
      loginBloc.formErrorMessage,
      flutter_test.emits("Error from service"),
    );
  });
}
