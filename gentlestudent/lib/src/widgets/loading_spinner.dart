import 'package:flutter/material.dart';

Widget loadingSpinner() => Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.lightBlue,
        ),
      ),
    );