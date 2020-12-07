import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Contains information about each place
class Places {}

// Contains information about place search response
class PlacesSearchResponse {
  PlacesSearchResponse();

  /*factory PlacesSearchResponse.fromJson(Map<String, dynamic> json) {
    List<Places>
    return PlacesSearchResponse();
  }*/
}

// Used to search for a place query
class PlacesSearch {
  final PlacesRequest request;

  PlacesSearch(this.request);

  Future<PlacesSearchResponse> getSearchResponse() async {
    String requestUrl = request.buildUrl();
    http.Response response = await fetchInfo(requestUrl);
    if (response.statusCode == 200) {
      //return PlacesSearchResponse.fromJson(jsonDecode(response));
    }
    return PlacesSearchResponse();
  }

  Future<http.Response> fetchInfo(String requestUrl) async {
    return http.get(requestUrl);
  }
}

// Used to generate a place query
class PlacesRequest {
  static String apiRequestStart =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?";

  String key;
  Location location;
  double searchRadius;
  String pageToken;

  PlacesRequest(this.key, this.location, this.searchRadius, {this.pageToken});

  String buildUrl() {
    StringBuffer buffer = new StringBuffer();
    buffer.write(apiRequestStart);
    buffer.write("key=");
    buffer.write(key);
    if (pageToken != null) {
      buffer.write("&pagetoken=");
      buffer.write(pageToken);
      return buffer.toString();
    }
    buffer.write("&location=");
    buffer.write(location.latitude.toString());
    buffer.write(",");
    buffer.write(location.longitude.toString());
    buffer.write("&radius=");
    buffer.write(searchRadius.toString());
    buffer.write("&type=restaurant&opennow=true");
    return buffer.toString();
  }
}

class Location {
  double latitude;
  double longitude;

  Location({this.latitude, this.longitude});
}
