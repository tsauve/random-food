import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:random_food/Data/globals.dart';
import 'package:random_food/Views/restaurantCard.dart';
import 'package:random_food/Models/restaurantInfo.dart';
import 'package:geolocator/geolocator.dart';

class RestaurantCardStack extends StatefulWidget {
  @override
  _RestaurantCardStackState createState() => _RestaurantCardStackState();
}

class _RestaurantCardStackState extends State<RestaurantCardStack> {
  final Queue<RestaurantCard> cards = new Queue<RestaurantCard>();
  final List<RestaurantCard> likedCards = new List<RestaurantCard>();
  String pageToken;
  bool outOfOptions = false;

  final places =
      new GoogleMapsPlaces(apiKey: "AIzaSyCqqCoHKSYCECamix0xpysyB_qMLrIemWE");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [getTopCard(), getButtons()],
    );
  }

  Widget getTopCard() {
    if (cards.isNotEmpty) {
      return cards.first;
    }
    return Card();
  }

  Widget getButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [getDislikeButton(), getLikeButton(), fillCardButton()],
    );
  }

  Widget getDislikeButton() {
    return new FloatingActionButton.extended(
      onPressed: () => dislikeCard(),
      label: Text('No'),
      icon: Icon(Icons.thumb_down),
      backgroundColor: Colors.red,
    );
  }

  Widget getLikeButton() {
    return new FloatingActionButton.extended(
      onPressed: () => likeCard(),
      label: Text('Yes'),
      icon: Icon(Icons.thumb_up),
      backgroundColor: Colors.green,
    );
  }

  Widget fillCardButton() {
    return new FloatingActionButton.extended(
      onPressed: () => locationBasedFillCards(),
      label: Text('Fill'),
      icon: Icon(Icons.file_upload),
      backgroundColor: Colors.grey,
    );
  }

  void dislikeCard() {
    print("Disliked restaurant " + cards.first.info.name);
    setState(() {
      cards.removeFirst();
    });
  }

  void likeCard() {
    print("Liked restaurant " + cards.first.info.name);
    setState(() {
      likedCards.add(cards.first);
      cards.removeFirst();
    });
  }

  void fillCards() {}

  void locationBasedFillCards() async {
    if (outOfOptions) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition();
    Location location = new Location(position.latitude, position.longitude);
    double searchRadius = 30000;
    String type = "restaurant";
    print("Position : " + position.toString());
    PlacesSearchResponse response;
    if (this.pageToken != null) {
      response = await places.searchNearbyWithRadius(location, searchRadius,
          type: type, pagetoken: this.pageToken);
      this.pageToken = response.nextPageToken;
    } else {
      response = await places.searchNearbyWithRadius(location, searchRadius,
          type: type);
      this.pageToken = response.nextPageToken;
    }

    if (response.results.isEmpty) {
      outOfOptions = true;
      return;
    }
    print("Num results : " + response.results.length.toString());
    setState(() {
      response.results.forEach((element) {
        print("Name: " + element.name);
        print("PlaceId: " + element.placeId);
        print("Ratio : " + cardRatio.toString());
        print("Screen height : " + screenHeight.toString());
        if (element.photos != null) {
          String photoUrl = places.buildPhotoUrl(
              photoReference: element.photos[0].photoReference,
              maxHeight: (cardRatio * screenHeight).toInt(),
              maxWidth: (screenWidth).toInt());
          double distanceBetween = Geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              element.geometry.location.lat,
              element.geometry.location.lng);
          RestaurantInfo restaurantInfo =
              new RestaurantInfo(element.name, distanceBetween, photoUrl);
          RestaurantCard restaurantCard = new RestaurantCard(restaurantInfo);
          cards.add(restaurantCard);
        }
      });
    });
  }
}
