import 'package:flutter/material.dart';
import 'package:random_food/Models/restaurantInfo.dart';
import 'package:random_food/Data/globals.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantInfo info;

  RestaurantCard(this.info);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: cardRatio * screenHeight, width: screenWidth, child: getCard());
  }

  Widget getCard() {
    return new Card(
        child: Column(
      children: [Image.network(info.imageUrl), getRestaurantInfo()],
    ));
  }

  Widget getRestaurantInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        getRestaurantName(),
        horizontalSpacing(10),
        getRestaurantDistance()
      ],
    );
  }

  Widget getRestaurantName() {
    return Text(info.name);
  }

  Widget getRestaurantDistance() {
    return Text(
        info.distance.toStringAsFixed(digitsAfterDecimal) + " miles away");
  }

  Widget horizontalSpacing([double spacing = 50]) {
    return SizedBox(
      width: spacing,
    );
  }

  Widget verticalSpacing([double spacing = 10]) {
    return SizedBox(
      height: spacing,
    );
  }
}
