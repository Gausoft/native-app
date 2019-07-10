import 'dart:async';

mixin RegistrationValidators {
  final validateFirstName = StreamTransformer<String, String>.fromHandlers(
      handleData: (firstName, sink) {
    if (firstName.length >= 1) {
      sink.add(firstName);
    } else {
      sink.addError('Voornaam is verplicht');
    }
  });

  final validateLastName = StreamTransformer<String, String>.fromHandlers(
      handleData: (lastName, sink) {
    if (lastName.length >= 1) {
      sink.add(lastName);
    } else {
      sink.addError('Achternaam is verplicht');
    }
  });

  final validateEducation = StreamTransformer<String, String>.fromHandlers(
      handleData: (education, sink) {
    if (education.length >= 1) {
      sink.add(education);
    } else {
      sink.addError('Onderwijsinstelling is verplicht');
    }
  });

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (RegExp(
            r"^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?")
        .hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('Voer een geldig e-mailadres in');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 6) {
      sink.add(password);
    } else {
      sink.addError('Het wachtwoord moet minstens 6 karakters lang zijn');
    }
  });

  final validateCountry = StreamTransformer<String, String>.fromHandlers(
      handleData: (country, sink) {
    if (country.length >= 1) {
      sink.add(country);
    } else {
      sink.addError('Land is vereist');
    }
  });

  final validateIsChecked =
      StreamTransformer<bool, bool>.fromHandlers(handleData: (isChecked, sink) {
    if (isChecked) {
      sink.add(isChecked);
    } else {
      sink.addError('U moet akkoord gaan om verder te kunnen gaan');
    }
  });
}