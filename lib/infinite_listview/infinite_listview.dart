import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InfiniteListview extends StatefulWidget {
  const InfiniteListview({Key? key}) : super(key: key);

  @override
  _InfiniteListviewState createState() => _InfiniteListviewState();
}

class _InfiniteListviewState extends State<InfiniteListview> {
  late bool _hasMore;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _defaultPhotosPerPageCount = 10;
  late List<Photo> _photos;
  final int _nextPageThreshold = 1;

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _pageNumber = 1;
    _error = false;
    _loading = true;
    _photos = [];
    fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Photos App")),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (_photos.isEmpty) {
      if (_loading) {
        return const Center(
            child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
      } else if (_error) {
        return Center(
          child: InkWell(
            onTap: () => setState(
              () {
                _loading = true;
                _error = false;
                fetchPhotos();
              },
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text("Error while loading photos, tap to try agin"),
            ),
          ),
        );
      }
    } else {
      return ListView.builder(
        itemCount: _photos.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _photos.length - _nextPageThreshold) {
            fetchPhotos();
          }
          if (index == _photos.length) {
            if (_error) {
              return Center(
                child: InkWell(
                  onTap: () => setState(
                    () {
                      _loading = true;
                      _error = false;
                      fetchPhotos();
                    },
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Error while loading photos, tap to try agin"),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }
          final Photo photo = _photos[index];
          return Card(
            child: Column(
              children: <Widget>[
                Image.network(
                  photo.thumbnailUrl,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  height: 160,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    photo.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    return Container();
  }

  Future<void> fetchPhotos() async {
    try {
      final response = await http.get(Uri.parse(
          "https://jsonplaceholder.typicode.com/photos?_page=$_pageNumber"));
      List<Photo> fetchedPhotos = Photo.parseList(json.decode(response.body));
      setState(
        () {
          _hasMore = fetchedPhotos.length == _defaultPhotosPerPageCount;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          _photos.addAll(fetchedPhotos);
        },
      );
    } catch (e) {
      setState(
        () {
          _loading = false;
          _error = true;
        },
      );
    }
  }
}

class Photo {
  final String title;
  final String thumbnailUrl;

  Photo(this.title, this.thumbnailUrl);

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(json["title"], json["thumbnailUrl"]);
  }

  static List<Photo> parseList(List<dynamic> list) {
    return list.map((i) => Photo.fromJson(i)).toList();
  }
}
