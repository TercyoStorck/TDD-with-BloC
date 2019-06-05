import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tdd_with_bloc/bloc/login/validator.dart';
import 'package:tdd_with_bloc/infrastructure/service/my_service/my_service.dart';

class LoginBloc extends BlocBase with Validator {
  MyService _myService;

  final _userName = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _isPostingForm = BehaviorSubject.seeded(false);
  final _formErrorMessage = BehaviorSubject<String>();

  bool _isFormValid = false;
  Function _onLoginDone;

  LoginBloc({
    @required MyService myService,
  }): assert(myService != null) {
    _myService = myService;

    _formValidation = _form.listen(
      (_) => _validateForm(),
      onError: (error) => _isFormValid = false,
    );

    _postingForm = _isPostingForm.listen(_formPostingListener);

    _formError = _formErrorMessage.listen((_) => _isPostingForm.add(false));
  }

  Stream<String> get userNameStream => _userName.transform(usernameValidator);
  Function(String) get userName => _userName.add;

  Stream<String> get passwordStream => _password.transform(passwordValidator);
  Function(String) get password => _password.add;

  Stream<bool> get isPostingFormStream => _isPostingForm.stream;
  submit() => _isPostingForm.add(true);

  Stream<String> get formErrorMessage => _formErrorMessage.stream;

  set onLoginDone(Function onLoginDone) => _onLoginDone = onLoginDone;

  Stream get _form => Observable.merge([
        userNameStream,
        passwordStream,
      ]);

  StreamSubscription _formValidation;
  StreamSubscription _postingForm;
  StreamSubscription _formError;

  _validateForm() {
    _isFormValid = _userName?.value?.isNotEmpty == true &&
        _password?.value?.isNotEmpty == true;

    if (_formErrorMessage.value != null) {
      _formErrorMessage.add(null);
    }
  }

  _formPostingListener(bool value) async {
    if (value == true) {
      if (!_isFormValid) {
        _showFormErrors();
        _formErrorMessage.add("Please fill in all fields correctly");
        return;
      }

      try {
        final token = await _myService.login(_userName.value, _password.value);
        
        ///save [token] where you prefer

        if (_onLoginDone != null) {
          _onLoginDone();
        }
        
        _isPostingForm.add(false);
      } catch (e) {
        _formErrorMessage.add(e);
      }
    }
  }

  _showFormErrors() {
    if (_userName?.value == null) {
      _userName.add("");
    }

    if (_password?.value == null) {
      _password.add("");
    }
  }

  @override
  void dispose() {
    //Closing streams
    _userName.close();
    _password.close();
    _isPostingForm.close();
    _formErrorMessage.close();

    //Cancel subscriptions
    _formValidation.cancel();
    _postingForm.cancel();
    _formError.cancel();

    super.dispose();
  }
}
