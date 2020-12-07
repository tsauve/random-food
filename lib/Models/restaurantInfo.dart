import 'package:flutter/material.dart';

class RestaurantInfo {
  static const double metersToMiles = 0.000621371;
  String name;
  double distance;
  String imageUrl;

  static double convertMetersToMiles(double dist) {
    return dist * metersToMiles;
  }

  RestaurantInfo(this.name, distance, this.imageUrl) {
    this.distance = convertMetersToMiles(distance);
  }
}
