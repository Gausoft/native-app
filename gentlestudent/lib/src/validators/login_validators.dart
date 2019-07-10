import 'dart:async';

import 'package:gentlestudent/src/constants/regex_constants.dart';
import 'package:gentlestudent/src/constants/string_constants.dart';

mixin LoginValidators {
  final validateEmail = StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (RegExp(emailRegex)
        .hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError(errorLoginInvalidEmail);
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 6) {
      sink.add(password);
    } else {
      sink.addError(errorLoginInvalidPassword);
    }
  });
}
