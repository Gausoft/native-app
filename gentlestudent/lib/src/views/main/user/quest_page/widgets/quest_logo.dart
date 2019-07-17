import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/constants/string_constants.dart';

Widget questLogo(double imageWidth) => Padding(
      padding: EdgeInsets.fromLTRB(12, 8, 4, 8),
      child: SizedBox(
        width: imageWidth,
        height: imageWidth,
        child: CachedNetworkImage(
          imageUrl: questCircleImageUrl,
          placeholder: (context, message) => CircularProgressIndicator(),
          errorWidget: (context, message, object) => Icon(Icons.error),
        ),
      ),
    );
