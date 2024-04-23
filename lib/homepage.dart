import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

class Homesate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomesateState();
  }
}

class _HomesateState extends State<Homesate> {
  late Future<List<Photodata>> _photosDataFuture;

  @override
  void initState() {
    super.initState();
    _photosDataFuture = getPhotosData();
  }

  Future<List<Photodata>> getPhotosData() async {
    final responseData = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    if (responseData.statusCode == 200) {
      var dataStore = jsonDecode(responseData.body) as List<dynamic>;
      List<Photodata> dataList = dataStore
          .map((json) => Photodata(
        albumId: json['albumId'],
        id: json['id'],
        title: json['title'],
        url: json['url'],
        thumbnailUrl: json['thumbnailUrl'],
      ))
          .toList();
      return dataList;
    } else {
      // If there's an error, throw an exception
      throw Exception('Failed to load photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos Data'),
      ),
      body: FutureBuilder<List<Photodata>>(
        future: _photosDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Image.network(
                      snapshot.data![index].thumbnailUrl,
                      errorBuilder: (context, error, stackTrace) {
                        return Placeholder(
                          fallbackWidth: 150,
                          fallbackHeight: 150,
                          color: Colors.grey, // Placeholder color
                        );
                      },
                    )
                  ),
                  title: Text(snapshot.data![index].title),
                  subtitle: Text('ID: ${snapshot.data![index].id}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
