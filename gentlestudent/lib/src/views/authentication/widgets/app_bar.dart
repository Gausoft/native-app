import 'package:flutter/material.dart';

Widget appBar(String title) => AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    );
