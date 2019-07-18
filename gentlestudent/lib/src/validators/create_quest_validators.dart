import 'dart:async';

mixin CreateQuestValidators {
  final validateTitle = StreamTransformer<String, String>.fromHandlers(
      handleData: (title, sink) {
    if (title.length >= 1) {
      sink.add(title);
    } else {
      sink.addError('Titel is verplicht');
    }
  });

  final validateDescription = StreamTransformer<String, String>.fromHandlers(
      handleData: (description, sink) {
    if (description.length >= 1) {
      sink.add(description);
    } else {
      sink.addError('Beschrijving is verplicht');
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

  final validatePhone = StreamTransformer<String, String>.fromHandlers(
      handleData: (phone, sink) {
    if (phone.length == 10) {
      sink.add(phone);
    } else {
      sink.addError('Het gsm-nummer moet 10 cijfers lang zijn');
    }
  });

  final validateLatitude = StreamTransformer<double, double>.fromHandlers(
      handleData: (double latitude, sink) {
    if (latitude != 0) {
      sink.add(latitude);
    } else {
      sink.addError('Latitude is vereist');
    }
  });

  final validateLongitude = StreamTransformer<double, double>.fromHandlers(
      handleData: (double longitude, sink) {
    if (longitude != 0) {
      sink.add(longitude);
    } else {
      sink.addError('Longitude is vereist');
    }
  });

}