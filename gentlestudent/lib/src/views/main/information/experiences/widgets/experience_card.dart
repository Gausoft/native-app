import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gentlestudent/src/models/experience.dart';
import 'package:gentlestudent/src/views/main/information/experiences/experience_detail_page/experience_detail_page.dart';
import 'package:gentlestudent/src/widgets/loading_spinner.dart';

class ExperienceCard extends StatelessWidget {
  final Experience experience;

  ExperienceCard({this.experience});

  void _navigateToExperienceDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ExperienceDetailPage(experience: experience),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _navigateToExperienceDetailPage(context),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListBody(
            children: <Widget>[
              experienceImage(),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  experienceTitle(),
                  experienceShortDescription(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget experienceImage() => Container(
    height: 200,
    child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        child: CachedNetworkImage(
          imageUrl: experience.imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, message) => Container(
            padding: EdgeInsets.all(10),
            child: loadingSpinner(),
          ),
          errorWidget: (context, message, object) => Container(
            padding: EdgeInsets.all(10),
            child: Center(child: Icon(Icons.error)),
          ),
        ),
      ),
  );

  Widget experienceTitle() => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Text(
          experience.title,
          style: TextStyle(fontSize: 21),
        ),
      );

  Widget experienceShortDescription() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          experience.shortText,
          style: TextStyle(fontSize: 14),
        ),
      );
}